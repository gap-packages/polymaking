LoadPackage("polymaking");

# Set POLYMAKING_CHULL to run the tests against a specific polymake convex hull
# backend, e.g. POLYMAKING_CHULL=cdd. Results must not depend on the choice.
if IsBound(GAPInfo.SystemEnvironment.POLYMAKING_CHULL)
   and GAPInfo.SystemEnvironment.POLYMAKING_CHULL <> "" then
    SetUserPreference("polymaking", "PolymakePreferences",
      [ Concatenation("*.convex_hull ",
                      GAPInfo.SystemEnvironment.POLYMAKING_CHULL) ]);
    Print("# using polymake convex hull backend: ",
          GAPInfo.SystemEnvironment.POLYMAKING_CHULL, "\n");
fi;

# This needs to be done manually
exclude:=["visual.tst"];
TestDirectory(
  DirectoriesPackageLibrary("polymaking", "tst"), 
  rec(exclude := exclude,
      exitGAP := true));
FORCE_QUIT_GAP(1);
