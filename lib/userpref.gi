#############################################################################
##
#W userpref.gi               polymaking Package
##
#Y This program is free software; you can redistribute it and/or
#Y modify it under the terms of the GNU General Public License
#Y as published by the Free Software Foundation; either version 2
#Y of the License, or (at your option) any later version.
##

# The temporary directory is created on demand and re-created whenever it has
# vanished, e.g. after restoring a workspace saved in an earlier session.
BindGlobal("POLYMAKING_STATE", rec(tmpdir := fail));


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
    if POLYMAKING_STATE.tmpdir = fail
       or not IsDirectoryPath(Filename(POLYMAKING_STATE.tmpdir, "")) then
        POLYMAKING_STATE.tmpdir := DirectoryTemporary();
        if POLYMAKING_STATE.tmpdir = fail then
            ErrorNoReturn("could not create a temporary directory for polymake files");
        fi;
    fi;
    return POLYMAKING_STATE.tmpdir;
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
