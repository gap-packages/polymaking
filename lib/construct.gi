#############################################################################
##
#W construct.gi 			 polymaking Package		 Marc Roeder
##
##  

##
##
#Y	 Copyright (C) 2006 Marc Roeder 
#Y 
#Y This program is free software; you can redistribute it and/or 
#Y modify it under the terms of the GNU General Public License 
#Y as published by the Free Software Foundation; either version 2 
#Y of the License, or (at your option) any later version. 
#Y 
#Y This program is distributed in the hope that it will be useful, 
#Y but WITHOUT ANY WARRANTY; without even the implied warranty of 
#Y MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#Y GNU General Public License for more details. 
#Y 
#Y You should have received a copy of the GNU General Public License 
#Y along with this program; if not, write to the Free Software 
#Y Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
##
# just create an empty file:
InstallMethod(CreateEmptyFile,[IsString],
        function(name)
    PrintTo(name,"");
end);

# polymaking writes polymake's own JSON format, so polymake never has to convert
# the file and never says so on stderr.
BindGlobal("POLYMAKING_DEFAULT_TYPE", "polytope::Polytope<Rational>");

InstallGlobalFunction(POLYMAKING_WriteObject, function(poly)
    if not "input" in NamesOfComponents(poly) then
        ErrorNoReturn("this polymake object was read from an existing file, ",
                "so polymaking cannot add properties to it");
    fi;
    FileString(FullFilenameOfPolymakeObject(poly),
            PolymakeEncodeObject(poly!.type, poly!.input));
end);

InstallMethod(InitPolymakeObject,[IsPolymakeObject],
        function(poly)
    poly!.input:=rec();
    poly!.type:=POLYMAKING_DEFAULT_TYPE;
    POLYMAKING_WriteObject(poly);
    return poly;
end);

# create a (possibly empty) polygon. 
# That is, a record just containing the name of a file to use with polymake.
# If the file does not exist, it is created.
####################
InstallMethod(CreatePolymakeObjectFromFile,[IsString],
        function(name)
    return CreatePolymakeObjectFromFile(PolymakeDataDirectory(), name);
end);

InstallMethod(CreatePolymakeObjectFromFile,[IsDirectory,IsString],
        function(dir,name)
    local   filename,  rtn, polygon;
    rtn:=Objectify(PolymakeObject,rec(filename:=name,dir:=dir));
    filename:=Filename(dir,name);
    if not IsExistingFile(filename)
       then
        CreateEmptyFile(filename);
        InitPolymakeObject(rtn);
    fi;
    return rtn;
end);

InstallMethod(CreatePolymakeObject,[IsString,IsDirectory],
        function(prefix,dir)
    local   name,  i,  newname;
    name:=Concatenation(prefix,String(Runtime()));
    if IsExistingFile(Filename(dir,name))
       then
        i:=1;
        repeat
            newname:=Concatenation([name,".",String(i)]);
            i:=i+1;
        until not IsExistingFile(Filename(dir,newname));
    else
        newname:=name;
    fi;
    return CreatePolymakeObjectFromFile(dir,newname);
end);



InstallMethod(CreatePolymakeObject,[IsString,IsDirectory,IsDenseList],
        function(prefix,dir,appvertyp)
    local   poly;
    poly:=CreatePolymakeObject(prefix,dir);
    ClearPolymakeObject(poly,appvertyp);
    return poly;
end);
       
        
        
InstallMethod(CreatePolymakeObject,[IsDirectory],
        function(dir)
    local   name,  i,  newname;
    return CreatePolymakeObject("poly",dir);
end);



InstallMethod(CreatePolymakeObject,[IsDirectory,IsDenseList],
        function(dir,appvertyp)
    local   poly;
    poly:=CreatePolymakeObject(dir);
    ClearPolymakeObject(poly,appvertyp);
    return poly;
end);



InstallMethod(CreatePolymakeObject,[],
        function()
    local   dir,  name;
    return CreatePolymakeObject(PolymakeDataDirectory());
end);


InstallMethod(CreatePolymakeObject,[IsDenseList],
        function(appvertyp)
    local poly;
    poly:=CreatePolymakeObject();
    ClearPolymakeObject(poly,appvertyp);
    return poly;
end);


InstallMethod(AppendToPolymakeObject,[IsPolymakeObject,IsString,IsObject],
        function(poly,keyword,data)
    if not "input" in NamesOfComponents(poly) then
        ErrorNoReturn("this polymake object was read from an existing file, ",
                "so polymaking cannot add properties to it");
    fi;
    poly!.input.(keyword):=data;
    POLYMAKING_WriteObject(poly);
end);


BindGlobal("POLYMAKING_CheckMatrix", function(matrix)
    local dim;
    if IsEmpty(matrix) then
        return;
    fi;
    dim:=Size(matrix[1]);
    if not ForAll(matrix,point->Size(point)=dim) then
        Error("not all rows have the same dimension");
    elif not ForAll(Concatenation(matrix),IsRat) then
        Error("matrix contains non-rational entries.");
    fi;
end);

# polymake wants points in homogeneous coordinates
BindGlobal("POLYMAKING_Homogenize",
        matrix -> List(matrix, p -> Concatenation([1],p)));


InstallMethod(AppendPointlistToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,pointlist)
    POLYMAKING_CheckMatrix(pointlist);
    AppendToPolymakeObject(polygon,"POINTS",POLYMAKING_Homogenize(pointlist));
end);


InstallMethod(AppendVertexlistToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,pointlist)
    POLYMAKING_CheckMatrix(pointlist);
    AppendToPolymakeObject(polygon,"VERTICES",POLYMAKING_Homogenize(pointlist));
end);


InstallMethod(AppendInequalitiesToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,ineqlist)
    POLYMAKING_CheckMatrix(ineqlist);
    AppendToPolymakeObject(polygon,"INEQUALITIES",ineqlist);
end);


##############################
# Call polymake. If the option "PolymakeNolookup" is true, 
# it is not checked, whether Polymake has already been called
# with this option (however, the polymake program will check 
# this by looking at the file associated to <polygon>).
#

# polymake 4 spells nested properties with a dot. Keep the short names the
# pre-0.9 interface used; note DIMS is gone, polymake 4 cannot compute it from a
# polytope's Hasse diagram.
BindGlobal("POLYMAKING_ALIASES", MakeImmutable(rec(
    FACES     := "HASSE_DIAGRAM.FACES",
    ADJACENCY := "HASSE_DIAGRAM.ADJACENCY",
    GRAPH     := "GRAPH.ADJACENCY"
)));

BindGlobal("POLYMAKING_Keyword", function(kw)
    if IsBound(POLYMAKING_ALIASES.(kw)) then
        return POLYMAKING_ALIASES.(kw);
    fi;
    return kw;
end);

# GRAPH is documented to come back as a record of vertices and edges, but
# polymake gives us adjacency lists.
BindGlobal("POLYMAKING_POSTPROCESS", MakeImmutable(rec(
    GRAPH := function(adj)
        local i, j, edges;
        edges := [];
        for i in [1..Length(adj)] do
            for j in adj[i] do
                AddSet(edges, Set([i,j]));
            od;
        od;
        return rec(vertices := [1..Length(adj)], edges := edges);
    end
)));


InstallMethod(Polymake,"for PolymakeObject",[IsPolymakeObject,IsString],
        function(polygon,option)
    local   keywords,  known,  lookup,  wanted,  dir,  r,  kw,  ask,  val,  
            returnval,  failed;

    POLYMAKING_CheckVersion();

    keywords:=Filtered(SplitString(NormalizedWhitespace(option)," "), x->x<>"");
    if IsEmpty(keywords)
       then
        Error("you must pass an option to polymake");
    fi;

    known:=NamesKnownPropertiesOfPolymakeObject(polygon);
    lookup:=ValueOption("PolymakeNolookup") in [fail,false] and known<>fail;

    wanted:=keywords;
    if lookup
       then
        wanted:=Filtered(keywords, kw -> not kw in known);
    fi;

    if not IsEmpty(wanted)
       then
        dir:=DirectoryOfPolymakeObject(polygon);
        if dir=fail
           then
            dir:=DirectoryCurrent();
        fi;
        ask:=List(wanted, kw -> POLYMAKING_Keyword(kw));
        r:=POLYMAKING_Run(dir, Concatenation([FullFilenameOfPolymakeObject(polygon)], ask));

        if r.result=fail
           then
            UpdatePolymakeFailReason(Concatenation(
                    "polymake terminated with exit status ",String(r.status),
                    "\n",r.stderr));
            Error("polymake returned an error (error code ", r.status, ")\n", r.stderr);
        fi;
        if IsBound(r.result.fatal)
           then
            UpdatePolymakeFailReason(r.result.fatal);
            Error("polymake could not read ",
                    FullFilenameOfPolymakeObject(polygon),":\n",r.result.fatal);
        fi;

        failed:=[];
        for kw in wanted
          do
            if IsBound(r.result.values.(POLYMAKING_Keyword(kw)))
               then
                val:=PolymakeDecodeProperty(kw,
                             r.result.values.(POLYMAKING_Keyword(kw)));
                if IsBound(POLYMAKING_POSTPROCESS.(kw))
                   then
                    val:=POLYMAKING_POSTPROCESS.(kw)(val);
                fi;
                WriteKnownPropertyToPolymakeObject(polygon,kw,val);
            else
                Add(failed,kw);
            fi;
        od;
        if not IsEmpty(failed)
           then
            UpdatePolymakeFailReason(Concatenation(
                    "polymake could not compute ",
                    JoinStringsWithSeparator(failed,", "),":\n",
                    JoinStringsWithSeparator(
                            List(failed, kw -> Concatenation(kw,": ",
                                    r.result.errors.(POLYMAKING_Keyword(kw)))),
                            "")));
        fi;
    fi;

    # as before: a single keyword returns its value, several always return fail
    if Size(keywords)>1
       then
        if IsEmpty(wanted)
           then
            UpdatePolymakeFailReason(
                    "polymake called with multiple keywords");
        fi;
        return fail;
    fi;

    known:=NamesKnownPropertiesOfPolymakeObject(polygon);
    if known<>fail and keywords[1] in known
       then
        returnval:=PropertyOfPolymakeObject(polygon,keywords[1]);
    else
        returnval:=fail;
    fi;
    return returnval;
end);
