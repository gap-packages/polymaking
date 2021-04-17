[![Build Status](https://github.com/gap-packages/polymaking/workflows/CI/badge.svg?branch=master)](https://github.com/gap-packages/polymaking/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/gap-packages/polymaking/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/polymaking)

polymak(e)inG(AP)
==================

A very basic GAP-interface to the program "polymake" by
Ewgenij Gawrilow and Michael Joswig which is available at
<https://polymake.org>

Note that this package does not provide the program "polymake", which
has to be installed separately.

This package is distributed under the terms of the GNU general public
license version 2 or later (at your descretion).

(C)2007-2013 by Marc Roeder,
National University of Ireland, Galway


Requirements
------------

polymaking requires GAP version 4.8. It also needs polymake to be
installed.  The GAPDoc package is needed to display the documentation.
polymaking was written for the "first generation" polymake which was
called as a command-line tool. Using it with a current ("next generation")
version of polymake will result in longer runtimes and fewer supported
keywords/features.


Installation
------------

0. Install polymake <https://polymake.org>

1. Download one of the archives
   - `polymaking<ver>.tar.bz2`
   - `polymaking<ver>.tar.gz`
   - `polymaking<ver>-win.zip`

   (where `<ver>` is some version number) to the directory pkg/ of the
   GAP home directory. If you do not have permission to do so, create
   a directory called gap/pkg in your home directory.

2. Change directory to pkg/ and unpack the archive using the according command:
   - `tar -xjf polymaking<ver>.tar.bz2`
   - `tar -xzf polymaking<ver>.tar.gz`
   - `unzip polymaking<ver>-win.zip`
 (replace `<ver>` with the version number)

3. Start GAP. If you have created the directory gap/pkg in your home
   directory, use `gap -l '<homedir>/gap;'` where `<homedir>` is the path of
   your home directory (use `pwd` to find out what it is, if you don't know).

4. Type `LoadPackage("polymaking");` to load the polymaking package.

5. Run `ReadPackage("polymaking","tst/test.gap");` for a quick test.

If polymake is not found automatically (a warning will be printed at
level 1 in this case), try this:

6. Tell GAP where to look for polymake by adding the following lines to
   your `.gaprc` file:

        POLYMAKE_COMMAND:=Filename(Directory("/home/mypolymakebindir/"),"polymake");
        MakeImmutable(POLYMAKE_COMMAND);

    Note that you can also modify the value of the variable `POLYMAKE_COMMAND` in
    `lib/environment.gi`.



Support
-------

If you find a bug or strange behaviour, please submit a bug report to
<https://github.com/gap-packages/polymaking/issues>.
