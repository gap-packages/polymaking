gap> START_TEST("polymaking tst file");

## The order in which polymake enumerates facets depends on the convex hull
## backend it picks (ppl, cdd, lrs, beneath_beyond, ...), and FACETS rows are
## only determined up to a positive scalar. Canonicalise before comparing.
##
gap> NormalizeRow := function(v)
>      local d, g;
>      d := Lcm(List(v, DenominatorRat));
>      v := v * d;
>      g := Gcd(v);
>      if g <> 0 then v := v / g; fi;
>      return v;
>    end;;
gap> CanonicalFaceList := function(L)
>      local c;
>      c := ShallowCopy(L);
>      SortBy(c, a -> [Size(a), a]);
>      return c;
>    end;;
gap> CoversOfFaceList := function(faces)
>      local n, lt;
>      n := Length(faces);
>      lt := function(i, j)
>              return faces[i] <> faces[j] and IsSubset(faces[j], faces[i]);
>            end;
>      return List([1..n], i -> Filtered([1..n],
>               j -> lt(i, j) and not ForAny([1..n], k -> lt(i, k) and lt(k, j))));
>    end;;

## generate an empty file>
##
gap> poly:=CreatePolymakeObject();
<polymake object. No properties known>
gap> polyfile:=FullFilenameOfPolymakeObject( poly );;
gap> IsReadableFile(polyfile);
true
gap> IsWritableFile(polyfile);
true
gap> vs:=[ [ 1/4, 1/75, 1/22 ], [ 1/37, 1/62, 1/19 ], [ 1/91, 1/24, 1/88 ],
>   [ 1/59, 1/67, 1/5 ], [ 1/85, 1/31, 1/76 ], [ 1/4, 1/72, 1/44 ],
>   [ 1/47, 1/33, 1/55 ], [ 1/79, 1/21, 1/99 ], [ 1/3, 1/30, 1/12 ],
>   [ 1/71, 1/48, 1/71 ] ]
> ;;

## Write random points to the file and do something
##
gap> AppendPointlistToPolymakeObject(poly,vs);
gap> Polymake(poly,"POINTS");
[ [ 1/4, 1/75, 1/22 ], [ 1/37, 1/62, 1/19 ], [ 1/91, 1/24, 1/88 ], 
  [ 1/59, 1/67, 1/5 ], [ 1/85, 1/31, 1/76 ], [ 1/4, 1/72, 1/44 ], 
  [ 1/47, 1/33, 1/55 ], [ 1/79, 1/21, 1/99 ], [ 1/3, 1/30, 1/12 ], 
  [ 1/71, 1/48, 1/71 ] ]
gap> last=vs;
true
gap> Polymake(poly,"N_FACETS");
14
gap> Polymake(poly,"VOLUME");
56551499691708521629/103286715323123543904000
gap> Polymake(poly,"DIM");
3
gap> Polymake(poly,"ALTSHULER_DET");
4032
gap> Polymake(poly,"AMBIENT_DIM");
3
gap> Polymake(poly,"BALANCED");
true
gap> Polymake(poly,"BALANCE");
1
gap> Polymake(poly,"BOUNDED");
true
gap> Polymake(poly,"COCUBICALITY");
1
gap> Polymake(poly,"DUAL_CONNECTIVITY");
3
gap> Polymake(poly,"DUAL_DIAMETER");
4
gap> Polymake(poly,"ESSENTIALLY_GENERIC");
true
gap> Polymake(poly,"F_VECTOR");
[ 9, 21, 14 ]
gap> Polymake(poly,"F2_VECTOR");
[ [ 9, 42, 42 ], [ 42, 21, 42 ], [ 42, 42, 14 ] ]
gap> faces := Polymake(poly,"FACES");;
gap> CanonicalFaceList(faces);
[ [  ], [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], 
  [ 1, 2 ], [ 1, 4 ], [ 1, 6 ], [ 1, 8 ], [ 2, 4 ], [ 2, 6 ], [ 2, 9 ], 
  [ 3, 4 ], [ 3, 5 ], [ 3, 7 ], [ 3, 9 ], [ 4, 5 ], [ 4, 7 ], [ 4, 8 ], 
  [ 4, 9 ], [ 5, 9 ], [ 6, 7 ], [ 6, 8 ], [ 6, 9 ], [ 7, 8 ], [ 7, 9 ], 
  [ 1, 2, 4 ], [ 1, 2, 6 ], [ 1, 4, 8 ], [ 1, 6, 8 ], [ 2, 4, 9 ], 
  [ 2, 6, 9 ], [ 3, 4, 5 ], [ 3, 4, 7 ], [ 3, 5, 9 ], [ 3, 7, 9 ], 
  [ 4, 5, 9 ], [ 4, 7, 8 ], [ 6, 7, 8 ], [ 6, 7, 9 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] ]
gap> adj := Polymake(poly,"ADJACENCY");;
gap> Length(adj) = Length(faces);
true
gap> List(adj, Set) = CoversOfFaceList(faces);
true
gap> Collected(List(adj, Length));
[ [ 0, 1 ], [ 1, 14 ], [ 2, 21 ], [ 3, 1 ], [ 4, 4 ], [ 5, 2 ], [ 6, 1 ], 
  [ 7, 1 ], [ 9, 1 ] ]
gap> Polymake(poly,"FACET_DEGREES");
[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]
gap> Set(List(Polymake(poly,"FACETS"), NormalizeRow));
[ [ -2303641863, 164204234285, 12897123192, -3359875640 ], 
  [ -1580061339, 1195816838, 93208905900, 843077785 ], 
  [ -519350247, 28577972485, 5781969216, -256601080 ], 
  [ -42443748, 474787219, 1685061792, 46231655 ], 
  [ -2006700, 2225735, 88056864, 9999187 ], 
  [ -574215, 16096535, 4705056, 17713168 ], 
  [ -235790, -456383, 2076480, 14126013 ], 
  [ -145029, 1373099, 1147776, 7226208 ], [ -51826, 38850, 2915550, 71269 ], 
  [ 87, -452, 1800, 44 ], [ 23349, -103132, 738675, -163130 ], 
  [ 27853, -108309, -630630, 351252 ], 
  [ 1403725, 643437067, -190478253, -47332395 ], 
  [ 13885273, -1477537, -280945070, -48335100 ] ]
gap> Polymake(poly,"FAR_HYPERPLANE");
[ 1, 0, 0, 0 ]
gap> Polymake(poly,"FEASIBLE");
true
gap> Polymake(poly,"N_BOUNDED_VERTICES");
9
gap> Polymake(poly,"N_FLAGS");
1
gap> Polymake(poly,"N_POINTS");
10
gap> Polymake(poly,"N_RIDGES");
21
gap> Polymake(poly,"N_VERTEX_FACET_INC");
42
gap> Polymake(poly,"N_VERTICES");
9
gap> Polymake(poly,"NEIGHBORLINESS");
1
gap> Polymake(poly,"NEIGHBORLY");
true
gap> angle := Polymake(poly,"MINIMAL_VERTEX_ANGLE");;
gap> IsFloat(angle) and AbsoluteValue(angle - 3.14159265358979) < 1.e-10;
true
gap> Polymake(poly,"POINTED");
true
gap> Polymake(poly,"POSITIVE");
true
gap> Polymake(poly,"REL_INT_POINT");
[ 526671192497/5114383067430, 12246977/471063600, 2419163/48078360 ]
gap> Polymake(poly,"SIMPLICIAL");
true
gap> Polymake(poly,"VALID_POINT");
[ 1/4, 1/75, 1/22 ]
gap> Polymake(poly,"VERTEX_BARYCENTER");
[ 526671192497/5114383067430, 12246977/471063600, 2419163/48078360 ]
gap> Polymake(poly,"VERTEX_DEGREES");
[ 4, 4, 4, 7, 3, 5, 5, 4, 6 ]
gap> Polymake(poly,"VERTICES");
[ [ 1/4, 1/75, 1/22 ], [ 1/37, 1/62, 1/19 ], [ 1/91, 1/24, 1/88 ], 
  [ 1/59, 1/67, 1/5 ], [ 1/85, 1/31, 1/76 ], [ 1/4, 1/72, 1/44 ], 
  [ 1/79, 1/21, 1/99 ], [ 1/3, 1/30, 1/12 ], [ 1/71, 1/48, 1/71 ] ]
gap> Set(Polymake(poly,"VERTICES_IN_FACETS"));
[ [ 1, 2, 4 ], [ 1, 2, 6 ], [ 1, 4, 8 ], [ 1, 6, 8 ], [ 2, 4, 9 ], 
  [ 2, 6, 9 ], [ 3, 4, 5 ], [ 3, 4, 7 ], [ 3, 5, 9 ], [ 3, 7, 9 ], 
  [ 4, 5, 9 ], [ 4, 7, 8 ], [ 6, 7, 8 ], [ 6, 7, 9 ] ]

## test external files:
## polymake rewrites files in the old plain format in place, so work on a copy
## rather than on the one checked into the repository.
##
gap> dir:=DirectoriesPackageLibrary("polymaking", "tst")[1];;
gap> tmpdir:=DirectoryTemporary();;
gap> FileString(Filename(tmpdir, "pplane.poly"),
>               StringFile(Filename(dir, "pplane.poly")));;
gap> olddatadir:=UserPreference("polymaking", "PolymakeDataDirectory");;
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", Filename(tmpdir, ""));;
gap> plane:=CreatePolymakeObjectFromFile("pplane.poly");
<polymake object. No properties known>

#
gap> Polymake(plane,"FACES DIMS");
fail
gap> Polymake(plane, "FACETS");
[ [ 1, 2, 5 ], [ 1, 2, 6 ], [ 1, 3, 4 ], [ 1, 3, 5 ], [ 1, 4, 6 ], 
  [ 2, 3, 4 ], [ 2, 3, 6 ], [ 2, 4, 5 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ]

## polymake 4 spells nested properties with a dot, and polymaking no longer has
## to rewrite the keyword to reach them
##
gap> Polymake(poly,"HASSE_DIAGRAM.FACES") = faces;
true

## GRAPH comes back as documented; it used to raise an error
##
gap> g := Polymake(poly,"GRAPH");;
gap> Set(RecNames(g));
[ "edges", "vertices" ]
gap> g.vertices = [1..9];
true
gap> g.edges = Filtered(CanonicalFaceList(faces), f -> Size(f) = 2);
true

## polymaking writes polymake's own format, so nothing needs converting
##
gap> j := JsonStringToGap(StringFile(FullFilenameOfPolymakeObject(poly)));;
gap> j._type;
"polytope::Polytope<Rational>"
gap> j.POINTS[1];
[ "1", "1/4", "1/75", "1/22" ]

#
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", olddatadir);;
gap> STOP_TEST("polymaking.tst", 10000);
