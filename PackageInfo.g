SetPackageInfo( rec(

PackageName := "polymaking",
Subtitle := "Interfacing the geometry software polymake",
Version := "0.8.1",
Date := "16/11/2013", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

ArchiveURL := "http://csserver.evansville.edu/~mroeder/polymaking/polymaking0_8_1",
ArchiveFormats := ".tar.gz,.tar.bz2,-win.zip", # the others are generated automatically

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "marc_roeder@web.de",
    WWWHome       := "http://csserver.evansville.edu/~mroeder",
  ),
],

Status := "deposited",

README_URL := "http://csserver.evansville.edu/~mroeder/polymaking/README.polymaking",
PackageInfoURL := "http://csserver.evansville.edu/~mroeder/polymaking/PackageInfo.g",

AbstractHTML := "This package provides a very basic interface to the polymake program by Ewgenij Gawrilow, Michael Joswig et al.",

PackageWWWHome := "http://csserver.evansville.edu/~mroeder/polymaking.html",

PackageDoc := rec(
  BookName  := "polymaking",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "A package for using polymake in GAP",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [["GAPDoc", ">= 0.99"]],
  ExternalConditions := ["polymake (http://www.polymake.org) must be installed"]
),

AvailabilityTest := ReturnTrue,
BannerString := Concatenation(
  "----------------------------------------------------------------\n",
  "Loading  polymaking ", ~.Version, "\n",
  "(",~.PackageDoc.LongTitle,")\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,"\n",
  "----------------------------------------------------------------\n" ),

Autoload := false,
TestFile := "tst/testall.g",
Keywords := ["interface","polymake","computational geometry"]

));
