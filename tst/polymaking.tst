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

## test external files:
gap> dir:=DirectoriesPackageLibrary("polymaking", "tst")[1];;
gap> plane:=CreatePolymakeObjectFromFile(dir,"pplane.poly");
<polymake object. No properties known>

#
gap> Polymake(plane,"FACES DIMS");
fail
gap> Polymake(plane, "DIMS");
[ 1, 11, 26, 32 ]

#
gap> STOP_TEST("polymaking.tst", 10000);