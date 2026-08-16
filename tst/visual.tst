gap> LoadPackage("polymaking");
gap> dir:=DirectoriesPackageLibrary("polymaking", "tst")[1];;
gap> SetUserPreference("polymaking", "PolymakeDataDirectory", Filename(dir, ""));;
gap> poly := CreatePolymakeObjectFromFile(dir, "visual.poly");
<polymake object. No properties known>
gap> Polymake(poly, "VISUAL");
fail 

