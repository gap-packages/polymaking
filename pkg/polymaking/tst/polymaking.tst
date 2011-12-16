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
## test the cube client:
##
gap> cube:=PolymakeClient("cube","3");
<polymake object. No properties known>
gap> Polymake(cube,"N_VERTICES");
8
gap> Polymake(cube,"N_FACETS");
6
gap> int:=PolymakeClient("intersection",[cube,poly]);
<polymake object. No properties known>
gap> Polymake(int,"VOLUME");
56551499691708521629/103286715323123543904000
gap> Polymake(int,"VOLUME")=Polymake(poly,"VOLUME");
true
gap> Polymake(cube,"FACE_LATTICE");
[ [ [ 1, 2, 3, 4 ], [ 1, 2, 5, 6 ], [ 1, 3, 5, 7 ], [ 2, 4, 6, 8 ],
      [ 3, 4, 7, 8 ], [ 5, 6, 7, 8 ] ],
  [ [ 1, 2 ], [ 1, 3 ], [ 1, 5 ], [ 2, 4 ], [ 2, 6 ], [ 3, 4 ], [ 3, 7 ],
      [ 4, 8 ], [ 5, 6 ], [ 5, 7 ], [ 6, 8 ], [ 7, 8 ] ],
  [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ] ] ]
gap> Polymake(cube,"HASSE_DIAGRAM");;


## test external files:
gap> dir:=Directory(Filename(DirectoriesPackageLibrary("polymaking"),"../tst/"));;
gap> plane:=CreatePolymakeObjectFromFile(dir,"pplane.poly");
<polymake object. No properties known>
gap> Polymake(plane,"EULER_CHARACTERISTIC");
0
gap> Polymake(plane,"PSEUDO_MANIFOLD");
true
gap> Polymake(plane,"DESCRIPTION");
"The projective plane."
gap> Polymake(plane,"CONNECTED");
true
gap> hasse:=Polymake(plane,"HASSE_DIAGRAM");;
gap> IsRecord(hasse);
true
gap> RecNames(hasse);
[ "hasse", "faceindices" ]

gap> STOP_TEST("polymaking.tst", 10000);