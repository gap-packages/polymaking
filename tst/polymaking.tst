gap> START_TEST("polymaking tst file");

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
gap> Polymake(poly,"FACES");
[ [  ], [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], 
  [ 1, 2 ], [ 1, 4 ], [ 1, 6 ], [ 1, 8 ], [ 2, 4 ], [ 2, 6 ], [ 2, 9 ], 
  [ 3, 4 ], [ 3, 5 ], [ 3, 7 ], [ 3, 9 ], [ 4, 5 ], [ 4, 7 ], [ 4, 8 ], 
  [ 4, 9 ], [ 5, 9 ], [ 6, 7 ], [ 6, 8 ], [ 6, 9 ], [ 7, 8 ], [ 7, 9 ], 
  [ 1, 6, 8 ], [ 2, 4, 9 ], [ 3, 4, 7 ], [ 6, 7, 8 ], [ 4, 7, 8 ], 
  [ 3, 7, 9 ], [ 6, 7, 9 ], [ 1, 4, 8 ], [ 1, 2, 4 ], [ 2, 6, 9 ], 
  [ 1, 2, 6 ], [ 3, 5, 9 ], [ 4, 5, 9 ], [ 3, 4, 5 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] ]
gap> Polymake(poly,"ADJACENCY");
[ [ 2, 3, 4, 5, 6, 7, 8, 9, 10 ], [ 11, 12, 13, 14 ], [ 11, 15, 16, 17 ], 
  [ 18, 19, 20, 21 ], [ 12, 15, 18, 22, 23, 24, 25 ], [ 19, 22, 26 ], 
  [ 13, 16, 27, 28, 29 ], [ 20, 23, 27, 30, 31 ], [ 14, 24, 28, 30 ], 
  [ 17, 21, 25, 26, 29, 31 ], [ 40, 42 ], [ 39, 40 ], [ 32, 42 ], [ 32, 39 ], 
  [ 33, 40 ], [ 41, 42 ], [ 33, 41 ], [ 34, 45 ], [ 43, 45 ], [ 34, 37 ], 
  [ 37, 43 ], [ 44, 45 ], [ 34, 36 ], [ 36, 39 ], [ 33, 44 ], [ 43, 44 ], 
  [ 35, 38 ], [ 32, 35 ], [ 38, 41 ], [ 35, 36 ], [ 37, 38 ], [ 46 ], [ 46 ], 
  [ 46 ], [ 46 ], [ 46 ], [ 46 ], [ 46 ], [ 46 ], [ 46 ], [ 46 ], [ 46 ], 
  [ 46 ], [ 46 ], [ 46 ], [  ] ]
gap> Polymake(poly,"FACET_DEGREES");
[ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]
gap> Polymake(poly,"FACETS");
[ [ 87, -452, 1800, 44 ], [ -42443748, 474787219, 1685061792, 46231655 ], 
  [ 1403725, 643437067, -190478253, -47332395 ], 
  [ 27853, -108309, -630630, 351252 ], 
  [ 13885273, -1477537, -280945070, -48335100 ], 
  [ -145029, 1373099, 1147776, 7226208 ], 
  [ -235790, -456383, 2076480, 14126013 ], [ 23349, -103132, 738675, -163130 ]
    , [ -1580061339, 1195816838, 93208905900, 843077785 ], 
  [ -2006700, 2225735, 88056864, 9999187 ], [ -51826, 38850, 2915550, 71269 ],
  [ -574215, 16096535, 4705056, 17713168 ], 
  [ -519350247, 28577972485, 5781969216, -256601080 ], 
  [ -2303641863, 164204234285, 12897123192, -3359875640 ] ]
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
gap> Polymake(poly,"MINIMAL_VERTEX_ANGLE");
#I  Warning!converting a floating point number
314159265358979/100000000000000
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
gap> Polymake(poly,"VERTICES_IN_FACETS");
[ [ 1, 6, 8 ], [ 2, 4, 9 ], [ 3, 4, 7 ], [ 6, 7, 8 ], [ 4, 7, 8 ], 
  [ 3, 7, 9 ], [ 6, 7, 9 ], [ 1, 4, 8 ], [ 1, 2, 4 ], [ 2, 6, 9 ], 
  [ 1, 2, 6 ], [ 3, 5, 9 ], [ 4, 5, 9 ], [ 3, 4, 5 ] ]

## test external files:
gap> dir:=DirectoriesPackageLibrary("polymaking", "tst")[1];;
gap> SetPolymakeDataDirectory(dir);;
gap> plane:=CreatePolymakeObjectFromFile("pplane.poly");
<polymake object. No properties known>

#
gap> Polymake(plane,"FACES DIMS");
fail
gap> Polymake(plane, "FACETS");
[ [ 1, 2, 5 ], [ 1, 2, 6 ], [ 1, 3, 4 ], [ 1, 3, 5 ], [ 1, 4, 6 ], 
  [ 2, 3, 4 ], [ 2, 3, 6 ], [ 2, 4, 5 ], [ 3, 5, 6 ], [ 4, 5, 6 ] ]

#
gap> STOP_TEST("polymaking.tst", 10000);
