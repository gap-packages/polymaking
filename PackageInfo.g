SetPackageInfo( rec(

PackageName := "polymaking",
Subtitle := "Interfacing the geometry software polymake",
Version := "0.8.7",
Date := "04/10/2023", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Roeder",
    FirstNames    := "Marc",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "roeder.marc@gmail.com",
  ),
  rec(
    LastName      := "GAP Team",
    FirstNames    := "The",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "support@gap-system.org",
  ),
],

Status := "deposited",

PackageWWWHome  := "https://gap-packages.github.io/polymaking/",
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/polymaking",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/polymaking-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "This package provides a very basic interface to the polymake program by Ewgenij Gawrilow, Michael Joswig et al.",

PackageDoc := rec(
  BookName  := "polymaking",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "A package for using polymake in GAP",
),

Dependencies := rec(
  GAP := ">=4.8",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [["GAPDoc", ">= 0.99"]],
  ExternalConditions := ["polymake (http://www.polymake.org) must be installed"]
),

AvailabilityTest := ReturnTrue,
TestFile := "tst/testall.g",
Keywords := ["interface","polymake","computational geometry"],

AutoDoc := rec(
    TitlePage := rec(
        Abstract := """
            This package provides a very basic interface to the polymake
            program by Ewgenij Gawrilow, Michael Joswig et al. <Cite
            Key="polymake"></Cite>. The polymake program itself is not
            included.
        """,
        Acknowledgements := """
          This work has been supported by Marie Curie Grant No. MTKD-CT-2006-042685
        """,
        Copyright := """
            &copyright; 2007--2013 Marc Roeder. <P/>

            This package is distributed under the terms of the GNU General
            Public License version 2 or later (at your convenience). See the
            file "LICENSE" or
            <URL>https://www.gnu.org/copyleft/gpl.html</URL>
        """,
        Version := Concatenation( "Version ", ~.Version ),
    )
),

));
