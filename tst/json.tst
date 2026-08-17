gap> START_TEST("json.tst");

# the type drives the decoding, so check the shapes polymake actually emits
gap> t := PolymakeParseType("common::Array<Set<Int>>");;
gap> [t.name, t.params[1].name, t.params[1].params[1].name];
[ "Array", "Set", "Int" ]
gap> PolymakeParseType("common::NodeMap<Directed, Set<Int>>").params[2].name;
"Set"
gap> PolymakeParseType(fail).name;
""

# polymake writes its own number types as strings, plain perl values natively
gap> PolymakeDecodeProperty("VOLUME", rec(_type := "common::Rational", data := "1/4"));
1/4
gap> PolymakeDecodeProperty("ALTSHULER_DET", rec(_type := "common::Integer",
>      data := "123456789012345678901234567890"));
123456789012345678901234567890
gap> PolymakeDecodeProperty("BOUNDED", rec(_type := fail, data := true));
true
gap> PolymakeDecodeProperty("N_VERTICES", rec(_type := fail, data := 8));
8

# indices are 0-based in polymake and 1-based in GAP
gap> PolymakeDecodeProperty("VERTICES_IN_FACETS",
>      rec(_type := "common::IncidenceMatrix<NonSymmetric>",
>          data := [[0,2,4],[1,3,5],rec(cols := 6)]));
[ [ 1, 3, 5 ], [ 2, 4, 6 ] ]
gap> PolymakeDecodeProperty("HASSE_DIAGRAM.FACES",
>      rec(_type := "common::NodeMap<Directed, Set<Int>>", data := [[],[0],[0,1]]));
[ [  ], [ 1 ], [ 1, 2 ] ]
gap> PolymakeDecodeProperty("TOP_NODE", rec(_type := fail, data := 7));
8

# ... but plain integer arrays are values, not indices
gap> PolymakeDecodeProperty("FACET_DEGREES",
>      rec(_type := "common::Array<Int>", data := [3,3,4]));
[ 3, 3, 4 ]

# sparse vectors and matrices
gap> PolymakeDecodeProperty("V", rec(_type := "common::SparseVector<Rational>",
>      data := rec(("3") := "1/2", _dim := 5)));
[ 0, 0, 0, 1/2, 0 ]
gap> PolymakeDecodeProperty("M", rec(_type := "common::SparseMatrix<Rational, NonSymmetric>",
>      data := [rec(("0") := "1", ("1") := "1"), rec(("3") := "-1"), rec(cols := 4)]));
[ [ 1, 1, 0, 0 ], [ 0, 0, 0, -1 ] ]

# a SparseMatrix may mix sparse rows with dense ones, and an all-zero row
# serializes as an empty record
gap> PolymakeDecodeProperty("M", rec(_type := "common::SparseMatrix<Rational, NonSymmetric>",
>      data := [["5"], rec(cols := 1)]));
[ [ 5 ] ]
gap> PolymakeDecodeProperty("M", rec(_type := "common::SparseMatrix<Rational, NonSymmetric>",
>      data := [rec(), rec(), rec(cols := 2)]));
[ [ 0, 0 ], [ 0, 0 ] ]
gap> PolymakeDecodeProperty("M", rec(_type := "common::SparseMatrix<Rational, NonSymmetric>",
>      data := [rec(cols := 3)]));
[  ]

# homogeneous coordinates are stripped
gap> PolymakeDecodeProperty("VERTICES", rec(_type := "common::Matrix<Rational, NonSymmetric>",
>      data := [["1","1/4","0"],["1","0","1/5"]]));
[ [ 1/4, 0 ], [ 0, 1/5 ] ]
gap> PolymakeDecodeProperty("REL_INT_POINT", rec(_type := "common::Vector<Rational>",
>      data := ["1","1/3","1/7"]));
[ 1/3, 1/7 ]

# ... but FACETS are not points, so they keep every coordinate
gap> PolymakeDecodeProperty("FACETS", rec(_type := "common::Matrix<Rational, NonSymmetric>",
>      data := [["1","-1","0"]]));
[ [ 1, -1, 0 ] ]

# writing: rationals become strings, which is how polymake spells them
gap> j := JsonStringToGap(
>      PolymakeEncodeObject("polytope::Polytope<Rational>", rec(POINTS := [[1,1/4]])));;
gap> [ j._type, j.POINTS, j._ns.polymake[2] ];
[ "polytope::Polytope<Rational>", [ [ "1", "1/4" ] ], "4.0" ]

# polymake before 4.0 cannot read the files polymaking writes, so it is refused
gap> oldver := POLYMAKING_STATE.version;;
gap> POLYMAKING_STATE.version := "3.6";;
gap> POLYMAKING_STATE.versionChecked := false;;
gap> CALL_WITH_CATCH(POLYMAKING_CheckVersion, [])[1];
Error, polymaking requires polymake 4.0 or newer, but found 3.6. Use polymakin\
g 0.8.9 with older versions of polymake.
false
gap> POLYMAKING_STATE.version := "4.0";;
gap> POLYMAKING_CheckVersion();
gap> POLYMAKING_STATE.versionChecked;
true
gap> POLYMAKING_STATE.version := oldver;;

#
gap> STOP_TEST("json.tst", 1);
