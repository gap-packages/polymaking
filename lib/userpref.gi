#############################################################################
##
#W userpref.gi               polymaking Package
##
#Y This program is free software; you can redistribute it and/or
#Y modify it under the terms of the GNU General Public License
#Y as published by the Free Software Foundation; either version 2
#Y of the License, or (at your option) any later version.
##

# Temporary directories are created on demand and re-created whenever they have
# vanished, e.g. after restoring a workspace saved in an earlier session.
BindGlobal("POLYMAKING_STATE",
        rec(tmpdir := fail, scratch := fail,
            version := fail, versionChecked := false));


BindGlobal("POLYMAKING_TempDirectory", function(key)
    if POLYMAKING_STATE.(key) = fail
       or not IsDirectoryPath(Filename(POLYMAKING_STATE.(key), "")) then
        POLYMAKING_STATE.(key) := DirectoryTemporary();
        if POLYMAKING_STATE.(key) = fail then
            ErrorNoReturn("could not create a temporary directory for polymake files");
        fi;
    fi;
    return POLYMAKING_STATE.(key);
end);


# A directory polymaking owns, for files the user never sees.
BindGlobal("POLYMAKING_ScratchFile",
        name -> Filename(POLYMAKING_TempDirectory("scratch"), name));


BindGlobal("POLYMAKING_ResolveCommand", function(cmd)
    local f;
    if not IsString(cmd) or cmd = "" then
        return fail;
    fi;
    if not ForAny("/\\", c -> c in cmd) then
        f := Filename(DirectoriesSystemPrograms(), cmd);
        if f <> fail and IsExecutableFile(f) then
            return f;
        fi;
    fi;
    if IsExecutableFile(cmd) then
        return cmd;
    fi;
    return fail;
end);


BindGlobal("POLYMAKING_EnsureDirectory", function(path)
    if not IsDirectoryPath(path) then
        if IsExistingFile(path) then
            ErrorNoReturn("polymake data directory ", path, " is not a directory");
        elif CreateDir(path) <> true then
            ErrorNoReturn("could not create polymake data directory ", path,
                          ": ", LastSystemError().message);
        fi;
    fi;
    return Directory(path);
end);


BindGlobal("POLYMAKING_WarnAboutObsoleteGlobals", function()
    local obsolete;
    obsolete := Filtered(["POLYMAKE_COMMAND", "POLYMAKE_DATA_DIR"], IsBoundGlobal);
    if not IsEmpty(obsolete) then
        Info(InfoWarning, 1,
             "polymaking no longer sets the global variables ",
             JoinStringsWithSeparator(obsolete, ", "),
             "; they are still honoured but deprecated. Use ",
             "SetUserPreference(\"polymaking\", ...) instead, see the manual.");
    fi;
    return obsolete;
end);


InstallGlobalFunction(PolymakeCommand, function()
    local pref, cmd;
    pref := UserPreference("polymaking", "PolymakeCommand");
    if IsString(pref) and pref <> "" then
        return POLYMAKING_ResolveCommand(pref);
    fi;
    if IsBoundGlobal("POLYMAKE_COMMAND") then
        cmd := POLYMAKING_ResolveCommand(VALUE_GLOBAL("POLYMAKE_COMMAND"));
        if cmd <> fail then
            return cmd;
        fi;
    fi;
    return POLYMAKING_ResolveCommand("polymake");
end);


InstallGlobalFunction(PolymakeDataDirectory, function()
    local pref, dir;
    pref := UserPreference("polymaking", "PolymakeDataDirectory");
    if IsString(pref) and pref <> "" then
        return POLYMAKING_EnsureDirectory(pref);
    fi;
    if IsBoundGlobal("POLYMAKE_DATA_DIR") then
        dir := VALUE_GLOBAL("POLYMAKE_DATA_DIR");
        if IsDirectory(dir) then
            return POLYMAKING_EnsureDirectory(Filename(dir, ""));
        elif IsString(dir) and dir <> "" then
            return POLYMAKING_EnsureDirectory(dir);
        fi;
    fi;
    return POLYMAKING_TempDirectory("tmpdir");
end);


DeclareUserPreference(rec(
  package := "polymaking",
  name := "PolymakeCommand",
  description := [
"""is the command or path used to invoke polymake.

The default, an empty string, makes <Package>polymaking</Package> look for a
program named <C>polymake</C> in <C>DirectoriesSystemPrograms()</C> each time
polymake is called. Set this preference if polymake is installed elsewhere or
should be invoked under a different name. <C>PolymakeCommand()</C> returns the
value actually used.
"""],
  default := "",
  check := x -> IsString(x) and (x = "" or POLYMAKING_ResolveCommand(x) <> fail)
));


DeclareUserPreference(rec(
  package := "polymaking",
  name := "PolymakeDataDirectory",
  description := [
"""is the directory in which <Package>polymaking</Package> creates the files it
hands to polymake.

The default, an empty string, means a temporary directory created on demand and
removed when &GAP; exits. Set this preference to a path if the files should
persist; it is created if it does not exist. <C>PolymakeDataDirectory()</C>
returns the directory actually used.
"""],
  default := "",
  check := x -> IsString(x) and (x = "" or not IsExistingFile(x) or IsDirectoryPath(x))
));


DeclareUserPreference(rec(
  package := "polymaking",
  name := "PolymakeQuiet",
  description := [
"""controls whether polymake's informational messages are suppressed.

polymake reports which third-party packages it used and when it converts a
data file to a newer format. These messages are interleaved with &GAP; output
and are usually just noise, so they are turned off by default. Set this to
<K>false</K> to see them.

Independently of this, everything polymake writes to standard error is shown at
<K>InfoPolymaking</K> level 2, and is included in the error message and in
<K>POLYMAKE&uscore;LAST&uscore;FAIL&uscore;REASON</K> when a call fails.
"""],
  default := true,
  values := [ true, false ],
  multi := false
));


DeclareUserPreference(rec(
  package := "polymaking",
  name := "PolymakeConfigPath",
  description := [
"""is passed to polymake as its <C>--config-path</C> option.

The default, an empty string, makes polymake ignore all user configuration.
This keeps results reproducible and never creates a <F>~/.polymake</F>
directory, but it forces polymake to redo its autoconfiguration on every call.
Set this to <C>"user"</C> to honour <F>~/.polymake/settings</F> instead, which
is considerably faster but makes the results depend on your polymake setup.
"""],
  default := "",
  check := IsString
));


DeclareUserPreference(rec(
  package := "polymaking",
  name := "PolymakePreferences",
  description := [
"""is a list of polymake rule preferences applied to each polymake call, for
example <C>[ "*.convex_hull cdd" ]</C>.

Each entry is passed to polymake's <C>prefer_now</C>. This works even when
<C>PolymakeConfigPath</C> is empty.
"""],
  default := [],
  check := x -> IsList(x) and ForAll(x, IsString)
));
