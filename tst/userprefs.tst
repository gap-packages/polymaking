gap> START_TEST("userprefs.tst");
gap> oldcmd := UserPreference("polymaking", "PolymakeCommand");;
gap> olddir := UserPreference("polymaking", "PolymakeDataDirectory");;
gap> IsString(oldcmd) and IsString(olddir);
true

# a configured directory is used, and created if it does not exist yet
gap> tmp := DirectoryTemporary();;
gap> sub := Filename(tmp, "datadir");;
gap> IsDirectoryPath(sub);
false
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", sub);;
gap> Filename(PolymakeDataDirectory(), "") = Concatenation(sub, "/");
true
gap> IsDirectoryPath(sub);
true

# issue #17: a temporary directory that has vanished is replaced, not reused
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", "");;
gap> d1 := Filename(PolymakeDataDirectory(), "");;
gap> d1 = Filename(PolymakeDataDirectory(), "");
true
gap> RemoveDirectoryRecursively(ShallowCopy(d1));  # GAP < 4.13 modifies its argument
true
gap> d2 := Filename(PolymakeDataDirectory(), "");;
gap> IsDirectoryPath(d2);
true
gap> d1 = d2;
false

# The obsolete globals are still provided, for packages that read them, and
# track the accessors. Whether the user set them before loading is decided once
# at load time, so it cannot be simulated here; POLYMAKING_LEGACY_SET says no.
gap> POLYMAKING_LEGACY_SET.command or POLYMAKING_LEGACY_SET.dataDir;
false
gap> POLYMAKING_WarnAboutObsoleteGlobals();
[  ]
gap> POLYMAKE_COMMAND = PolymakeCommand();
true
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", sub);;
gap> POLYMAKING_UpdateLegacyGlobals();
gap> Filename(POLYMAKE_DATA_DIR, "") = Filename(PolymakeDataDirectory(), "");
true
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", "");;

# the deprecated setters forward to the preferences
gap> oldinfo := InfoLevel(InfoObsolete);;
gap> SetInfoLevel(InfoObsolete, 1);;
gap> SetPolymakeDataDirectory(tmp);
#I  `SetPolymakeDataDirectory` is deprecated, use SetUserPreference("polymaking", "PolymakeDataDirectory", path) instead.
gap> UserPreference("polymaking", "PolymakeDataDirectory") = Filename(tmp, "");
true
gap> SetPolymakeCommand("no/such/polymake");
#I  `SetPolymakeCommand` is deprecated, use SetUserPreference("polymaking", "PolymakeCommand", command) instead.
Error, polymake command must exist and be executable
gap> SetInfoLevel(InfoObsolete, oldinfo);;

# PolymakeCommand resolves both bare names and paths
gap> PolymakeCommand() = fail or IsExecutableFile(PolymakeCommand());
true
gap> SetUserPreference("polymaking", "PolymakeCommand", "no/such/polymake");;
gap> PolymakeCommand();
fail

# the polymake output preferences are well-formed. Do not check them against
# their defaults: the test suite is run with PolymakePreferences set, to cover
# several convex hull backends.
gap> UserPreference("polymaking", "PolymakeQuiet") in [true, false];
true
gap> IsString(UserPreference("polymaking", "PolymakeConfigPath"));
true
gap> ForAll(UserPreference("polymaking", "PolymakePreferences"), IsString);
true

# hap and hapcryst compose these two, so the pair has to keep working
gap> poly := CreatePolymakeObject("compat", PolymakeDataDirectory(),
>              ["polytope", "2.3", "RationalPolytope"]);;
gap> AppendToPolymakeObject(poly,
>      ConvertMatrixToPolymakeString("POINTS", [[1,0,0],[1,1,0],[1,0,1]]));
gap> j := JsonStringToGap(StringFile(FullFilenameOfPolymakeObject(poly)));;
gap> j._type;
"polytope::Polytope<Rational>"
gap> j.POINTS;
[ [ "1", "0", "0" ], [ "1", "1", "0" ], [ "1", "0", "1" ] ]

# but a bare string cannot be appended to a JSON file
gap> CALL_WITH_CATCH(AppendToPolymakeObject, [poly, "POINTS\n1 0 0\n"])[1];
Error, cannot append a string, use AppendToPolymakeObject(poly, name, value)
false

#
gap> SetUserPreference("polymaking", "PolymakeCommand", oldcmd);;
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", olddir);;
gap> STOP_TEST("userprefs.tst", 1);
