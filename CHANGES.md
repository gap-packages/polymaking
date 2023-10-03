0.8.7 (2023-10-04)

- fix broken link in the manual
- fix example 2.6 in the manual
- janitorial changes

0.8.6 (2021-07-08)

- restore DIM that was lost between 0.7.9 and 0.8.1 (thanks to GitHub user narc-Ontakac2)
- fixed VISUAL (thanks to GitHub user narc-Ontakac2)

------------------

0.8.5 (2021-04-14)

- updated to recover from the previous faulty update

------------------

0.8.4 (2021-04-11)

- added functionality for the polymake command ADJACENCY

------------------

0.8.3 (2021-04-07)

- polymake 4.1 compatibility (thanks to GitHub user narc-Ontakac2)
- various janitorial changes

------------------

0.8.2 (2019-02-23)

- move package to GitHub
- add the GAP Team as maintainer
- various janitorial changes

------------------

0.8.1 (2013-11-16)

no more support for "old" polymake features. 
This version is for next-generation polymake run in
compatibility mode. More specifically:
- use of clients is no longer supported
- some keywords are no longer supported (e.g. HASSE_DIAGRAM)

------------------

0.7.9 (2013-10-27)

- support for two "next-generation" keywords:
  - "FACES" calls "HASSE_DIAGRAM->FACES"
  - "DIMS"  calls "HASSE_DIAGRAM->DIMS"
  these two keywords cannot be used with old versions of polymake.

- test changed: tests of unsupported features in recent polymake
  versions removed (clients, some keywords), "FACES DIMS" tested.

------------------

0.7.8 (2010-06-03)

------------------

0.7.7:
- package homepage changed

------------------

0.7.6 (2008-12-02)
- bug fixed in SetPolymakeClientPaths
- ClearPolymakeObject and CreatePolymakeObject can now be called with 
   application and version information which will then be written to the 
   new file. 
- Package moved from Galway to Kaiserslautern

------------------

0.7.5 (2008-08-13)
- changes in README.polymaking (thanks to Andreas Distler)
- changed subtitle to something more descriptive

------------------

0.7.4 (2008-07-16)
- fixed the "warning on startup" bug
- test file written

------------------

0.7.3 (2008-05-12)
- fixed an embarrassing bug. Now HASSE_DIAGRAM really does what it should.

------------------

0.7.2:
ATTENTION! change in output type:
- Polymake(poly,"HASSE_DIAGRAM") now returns a record instead of a list.
   This change was necessary to make HASSE_DIAGRAM work with simplicial 
   complexes.

New features:
- polymaking is now supporting some clients via PolymakeClient
- variable POLYMAKE_LAST_FAIL_REASON introduced. It should contain information 
   abut the reason of the last returned <fail>.

Changes to existing methods:
- Method Polymake rewritten
- polymaking now returns an error if polymake returns one
- Change in SplitPolymakeOutputStringIntoBlocks:
   keywords are now recognised by starting with an upper chase character and 
   consisting of  uppercase letters, numbers and "_" only.
- PolymakeObjects now print their description instead of just <polymake object>
   if they know it.

Converter things:
- ConvertPolymakeBoolToGAP now also accepts "true" and "false"
- converter ConvertPolymakeDescriptionToGAP added.
- converter ConvertPolymakeMatrixOrListOfSetsToGAP added 
    (for things like FACETS that exist in the polytope and topaz world)
- converter ConvertPolymakeIntVectorToGAPPlusOne added.
- A few more entries added to ObjectConverters (now supporting 105 keywords)

Converter method assignment changed for:
GRAPH, DUAL_GRAPH, FACETS, 

------------------

0.7.1 (2008-03-07)
- polymaking now suggests GAPdoc
- changed the way POLYMAKE_COMMAND is determined (thanks to Andreas Distler)
  polymaking now tries to guess the location of polymake using the system 
  path variable via DirectoriesSystemPrograms().
- documentation now includes a couple of comments on the installation of 
  polymake.

------------------

0.7.0:
- Package is now called "polymaking" instead of "polymake" to avoid 
  confusion. 
- Added a few converters (FAR_HYPERPLANE, N_01POINTS, REL_INT_POINT)

------------------

0.6.3:
- changed PackageInfo.g to point to the new homepage
- minor changes to the installation instructions in README.polymake and 
  the manual.
-
-----------------

0.6.2:
- some changes in the manual.
- AppendToPolymakeObject now has a 3-argument version
  to be called like AppendToPolymakeObject(poly,"KEYWORD","datastring");
- the converter for HASSE_DIAGRAM now returns a list of sets of triples of sets
  rather than the strange record. To be precise, only the ".hasse" part of the
  old version is returned.
- set global variables POLYMAKE_PROGRAM and POLYMAKE_DATA_DIR to "read only"
  status (thanks to Alexander Konovalov for this hint).

------------------

0.6.1:
- more converters added to ObjectConverters.gi
- PolymakeObject is not longer a sub category of Record.
- added AppendInequalitiesToPolymakeObject for convenience

------------------

0.6:
- Added a few object converters and removed a 
- Rewrote most of the documentation

------------------

0.5:
- package does no longer depend on the IO package.

- Conversion method for HASSE_DIAGRAM changed. Output has also changed and is
  not compatible with earlier versions.

- Polymake can now be called with several keywords. In this case, fail is 
  returned but the record is updated.
  If a part of the returned values are fail, these are not updated in the 
  polygon record (but the others are!).
  Any line of polymake output starting with a capital letter will be treated
  as a line containing a single keyword.

- Conversion method for FACE_LATTICE added.

- The objects now have their own type "PolymakeObject". Lots of functions 
  for manipulating them have been added.

------------------

0.3:
- Changes in CreatePolygon:
	can now take an existing directory as an argument,
	Change in naming convention for generated file. Number is appended
	if a file with the same name exists (can happen, if CreatePolygon(dir)
	is called several times without other calculations between the calls)

------------------

0.2:
- added conversion functions for polymake output.

------------------

0.1:
- packages started with very limited functionality

------------------
