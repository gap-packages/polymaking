# Excluded from tst/testall.g: VISUAL wants to open a viewer.
gap> START_TEST("visual.tst");
gap> dir:=DirectoriesPackageLibrary("polymaking", "tst")[1];;
gap> tmpdir:=DirectoryTemporary();;
gap> FileString(Filename(tmpdir, "visual.poly"),
>               StringFile(Filename(dir, "visual.poly")));;
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", Filename(tmpdir, ""));;
gap> poly := CreatePolymakeObjectFromFile(tmpdir, "visual.poly");
<polymake object. No properties known>
gap> Polymake(poly, "VISUAL");
fail
gap> STOP_TEST("visual.tst", 1);
