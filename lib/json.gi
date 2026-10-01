#############################################################################
##
#W json.gi                   polymaking Package
##
##  polymake serializes a value as { "data": ..., "_type": ..., "_ns": ... }.
##  The type tells us the shape, so unlike the pre-0.9 converters we do not
##  need a table mapping every keyword to a parser; only the conventions that
##  cannot be read off the type are keyword specific, see the two records at
##  the bottom of this file.
##

# "common::Array<Set<Int>>" -> rec(name:="Array", params:=[rec(name:="Set", ...)])
InstallGlobalFunction(PolymakeParseType, function(str)
    local pos, parse, name, params, depth, start, i;

    if str = fail then
        return rec(name := "", params := []);
    fi;

    # strip the application prefix
    pos := PositionSublist(str, "::");
    if pos <> fail then
        str := str{[pos+2..Length(str)]};
    fi;

    pos := Position(str, '<');
    if pos = fail then
        return rec(name := NormalizedWhitespace(str), params := []);
    fi;

    name := NormalizedWhitespace(str{[1..pos-1]});
    params := [];
    depth := 0;
    start := pos+1;
    for i in [pos+1..Length(str)] do
        if str[i] = '<' then
            depth := depth+1;
        elif str[i] = '>' then
            if depth = 0 then
                Add(params, str{[start..i-1]});
                break;
            fi;
            depth := depth-1;
        elif str[i] = ',' and depth = 0 then
            Add(params, str{[start..i-1]});
            start := i+1;
        fi;
    od;
    return rec(name := name, params := List(params, PolymakeParseType));
end);


# polymake writes its own number types as strings, plain perl values as native
# JSON, so both spellings turn up.
BindGlobal("POLYMAKING_Scalar", function(x)
    if IsString(x) then
        return Rat(x);
    fi;
    return x;
end);


BindGlobal("POLYMAKING_Indices", l -> Set(List(l, i -> i+1)));


# a dense list, or a sparse record {"3": v, "_dim": n}
BindGlobal("POLYMAKING_Vector", function(v)
    local r, k;
    if not IsRecord(v) then
        return List(v, POLYMAKING_Scalar);
    fi;
    r := ListWithIdenticalEntries(v._dim, 0);
    for k in RecNames(v) do
        if k <> "_dim" then
            r[Int(k)+1] := POLYMAKING_Scalar(v.(k));
        fi;
    od;
    return r;
end);


# rows, with an optional trailing {"cols": n} giving the width
BindGlobal("POLYMAKING_Rows", function(data)
    local rows, cols, last;
    rows := ShallowCopy(data);
    cols := fail;
    if not IsEmpty(rows) then
        last := rows[Length(rows)];
        if IsRecord(last) and IsBound(last.cols) then
            cols := Remove(rows).cols;
        fi;
    fi;
    return rec(rows := rows, cols := cols);
end);


BindGlobal("POLYMAKING_Matrix", function(data)
    local r, m;
    r := POLYMAKING_Rows(data);
    m := List(r.rows, function(row)
        local v;
        if IsRecord(row) then
            row := ShallowCopy(row);
            row._dim := r.cols;
        fi;
        v := POLYMAKING_Vector(row);
        if r.cols <> fail and Length(v) < r.cols then
            Append(v, ListWithIdenticalEntries(r.cols - Length(v), 0));
        fi;
        return v;
    end);
    return m;
end);


InstallGlobalFunction(PolymakeDecodeValue, function(type, data)
    local name;

    if data = fail then
        return fail;
    fi;
    name := type.name;

    # _type null: a plain perl value, already native JSON
    if name = "" then
        return data;

    elif name in ["Rational", "Integer", "Int", "Float", "Bool"] then
        return POLYMAKING_Scalar(data);

    elif name in ["Vector", "SparseVector"] then
        return POLYMAKING_Vector(data);

    elif name in ["Matrix", "SparseMatrix"] then
        return POLYMAKING_Matrix(data);

    # rows are index sets, shifted to GAP's 1-based convention
    elif name = "IncidenceMatrix" then
        return List(POLYMAKING_Rows(data).rows, POLYMAKING_Indices);

    elif name = "GraphAdjacency" then
        return List(data, POLYMAKING_Indices);

    elif name = "Set" then
        if not IsEmpty(type.params) and type.params[1].name in ["Int"] then
            return POLYMAKING_Indices(data);
        fi;
        return Set(List(data, POLYMAKING_Scalar));

    elif name = "Array" then
        if IsEmpty(type.params) then
            return data;
        fi;
        return List(data, x -> PolymakeDecodeValue(type.params[1], x));

    elif name = "NodeMap" then
        if Length(type.params) < 2 then
            return data;
        fi;
        return List(data, x -> PolymakeDecodeValue(type.params[2], x));
    fi;

    Info(InfoPolymaking, 1, "polymaking does not know the polymake type ",
         name, "; returning the raw JSON value");
    return data;
end);


##
## Conventions that the type cannot tell us about.
##

# polymake writes points and vectors in homogeneous coordinates; GAP users want
# them without the leading 1.
BindGlobal("POLYMAKING_DEHOMOGENIZE_ROWS",
        MakeImmutable(Set(["POINTS", "VERTICES"])));

BindGlobal("POLYMAKING_DEHOMOGENIZE",
        MakeImmutable(Set(["REL_INT_POINT", "VALID_POINT", "VERTEX_BARYCENTER"])));

# node numbers that are plain integers, so not caught by the Set<Int> rule
BindGlobal("POLYMAKING_SHIFT_SCALAR",
        MakeImmutable(Set(["TOP_NODE", "BOTTOM_NODE"])));


InstallGlobalFunction(PolymakeDecodeProperty, function(keyword, entry)
    local val;

    val := PolymakeDecodeValue(PolymakeParseType(entry._type), entry.data);

    if keyword in POLYMAKING_DEHOMOGENIZE_ROWS then
        val := List(val, r -> r{[2..Length(r)]});
    elif keyword in POLYMAKING_DEHOMOGENIZE then
        val := val{[2..Length(val)]};
    elif keyword in POLYMAKING_SHIFT_SCALAR then
        val := val+1;
    fi;
    return val;
end);


##
## Writing. polymake accepts its own number types as strings, which is the only
## faithful way to hand it a GAP rational: the json package cannot serialize
## rationals, and floats would lose exactness.
##

InstallGlobalFunction(POLYMAKING_EncodeValue, function(v)
    if IsRat(v) then
        return String(v);
    elif IsBool(v) or IsString(v) then
        return v;
    elif IsList(v) then
        return List(v, POLYMAKING_EncodeValue);
    fi;
    return v;
end);


InstallGlobalFunction(PolymakeEncodeObject, function(type, properties)
    local r, name;
    r := rec(_ns := rec(polymake := ["https://polymake.org", "4.0"]),
             _type := type);
    for name in RecNames(properties) do
        r.(name) := POLYMAKING_EncodeValue(properties.(name));
    od;
    return GapToJsonString(r);
end);
