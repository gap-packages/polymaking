gap> START_TEST("persistent.tst");
gap> oldpersist := UserPreference("polymaking", "PolymakePersistent");;

# the same answers either way
gap> results := [];; p := fail;;
gap> for persist in [true, false] do
>      SetUserPreference("polymaking", "PolymakePersistent", persist);
>      POLYMAKING_StopServer();
>      p := CreatePolymakeObject();;
>      AppendPointlistToPolymakeObject(p, [[1/4,1/75],[1/37,1/62],[1/91,1/24],[1/3,1/30]]);
>      Add(results, List(["N_VERTICES","VOLUME","VERTICES","FACETS","BOUNDED"],
>                        kw -> Polymake(p, kw)));
>    od;
gap> results[1] = results[2];
true

# rule preferences reach polymake in both modes. polymake compiles the helper
# script differently under --script than when the persistent process reads it,
# so this needs exercising both ways.
gap> oldprefs := UserPreference("polymaking", "PolymakePreferences");;
gap> SetUserPreference("polymaking", "PolymakePreferences",
>                      ["*.convex_hull beneath_beyond"]);;
gap> prefres := [];;
gap> for persist in [true, false] do
>      SetUserPreference("polymaking", "PolymakePersistent", persist);
>      POLYMAKING_StopServer();
>      Add(prefres, Polymake(p, "N_VERTICES" : PolymakeNolookup));
>    od;
gap> prefres;
[ 4, 4 ]
gap> SetUserPreference("polymaking", "PolymakePreferences", oldprefs);;
gap> POLYMAKING_StopServer();

# a server is started on demand, and only when asked for
gap> SetUserPreference("polymaking", "PolymakePersistent", false);;
gap> POLYMAKING_StopServer();
gap> q := CreatePolymakeObject();;
gap> AppendPointlistToPolymakeObject(q, [[0,0],[1,0],[0,1]]);
gap> Polymake(q, "N_VERTICES");
3
gap> POLYMAKING_STATE.server = fail;
true
gap> SetUserPreference("polymaking", "PolymakePersistent", true);;
gap> Polymake(q, "VOLUME" : PolymakeNolookup);
1/2
gap> POLYMAKING_STATE.server = fail;
false

# a polymake that has gone away is replaced rather than reported
gap> CloseStream(POLYMAKING_STATE.server);
gap> Polymake(q, "N_VERTICES" : PolymakeNolookup);
3
gap> POLYMAKING_STATE.server = fail;
false

# strings reaching perl are quoted, whatever they contain
gap> POLYMAKING_PerlString("a\"b\\c$d@e");
"\"a\\\"b\\\\c\\$d\\@e\""
gap> POLYMAKING_PerlList(["x", "y"]);
"[\"x\",\"y\"]"
gap> POLYMAKING_Bool(true);
"1"
gap> POLYMAKING_Bool(false);
"0"

#
gap> SetUserPreference("polymaking", "PolymakePersistent", oldpersist);;
gap> STOP_TEST("persistent.tst", 1);
