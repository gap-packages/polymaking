LoadPackage("polymaking");
# This needs to be done manually
exclude:=["visual.tst"];
TestDirectory(
  DirectoriesPackageLibrary("polymaking", "tst"), 
  rec(exclude := exclude,
      exitGAP := true));
FORCE_QUIT_GAP(1);
