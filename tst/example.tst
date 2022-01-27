gap> START_TEST("example tst file");
gap> S:=SymmetricGroup(3);
Sym( [ 1 .. 3 ] )
gap> v:=[1,2,3];
[ 1, 2, 3 ]
gap> points3:=Orbit(S,v,Permuted);;
gap> points := points3{[1..6]}{[1,2]};;
gap> permutahedron:=CreatePolymakeObject();
<polymake object. No properties known>
gap> AppendPointlistToPolymakeObject(permutahedron,points);
gap> Polymake(permutahedron,"VOLUME");
3
gap> Polymake(permutahedron,"N_VERTICES");
6
gap> PropertyOfPolymakeObject(permutahedron,"VERTICES");
fail
gap> NamesKnownPropertiesOfPolymakeObject(permutahedron);
[ "N_VERTICES", "VOLUME" ]
gap> Polymake(permutahedron,"DIM");
2
gap> STOP_TEST("example.tst", 10000);
