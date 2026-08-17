#############################################################################
##
#W environment.gi            polymaking Package      Marc Roeder
##
##  

##
##
#Y   Copyright (C) 2006 Marc Roeder 
#Y 
#Y This program is free software; you can redistribute it and/or 
#Y modify it under the terms of the GNU General Public License 
#Y as published by the Free Software Foundation; either version 2 
#Y of the License, or (at your option) any later version. 
#Y 
#Y This program is distributed in the hope that it will be useful, 
#Y but WITHOUT ANY WARRANTY; without even the implied warranty of 
#Y MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#Y GNU General Public License for more details. 
#Y 
#Y You should have received a copy of the GNU General Public License 
#Y along with this program; if not, write to the Free Software 
#Y Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
##
SetInfoLevel(InfoPolymaking,1);

# level 2 for shims that exist purely so that code written against polymaking
# 0.8 keeps running unchanged: warning by default would make their output, and
# so their test suites, differ.
BindGlobal("POLYMAKING_InfoDeprecatedAt", function(level, name, replacement)
    Info(InfoObsolete, level, "`", name, "` is deprecated, use ", replacement,
         " instead.");
end);

BindGlobal("POLYMAKING_InfoDeprecated", function(name, replacement)
    POLYMAKING_InfoDeprecatedAt(1, name, replacement);
end);


InstallMethod(SetPolymakeCommand,[IsString],
        function(command)
    POLYMAKING_InfoDeprecated("SetPolymakeCommand",
        "SetUserPreference(\"polymaking\", \"PolymakeCommand\", command)");
    if POLYMAKING_ResolveCommand(command) = fail then
        ErrorNoReturn("polymake command must exist and be executable");
    fi;
    SetUserPreference("polymaking", "PolymakeCommand", command);
end);


InstallMethod(SetPolymakeDataDirectory,[IsDirectory],
        function(dir)
    POLYMAKING_InfoDeprecated("SetPolymakeDataDirectory",
        "SetUserPreference(\"polymaking\", \"PolymakeDataDirectory\", path)");
    SetUserPreference("polymaking", "PolymakeDataDirectory", Filename(dir, ""));
end);


##
## Running polymake. Everything goes through lib/pm.pl, which writes its result
## to a file: polymake's own chatter goes to stderr, so a result on stdout could
## never be trusted.
##
##
## The persistent polymake. Starting polymake costs about 0.8s, almost all of it
## loading the rules of an application, and a session usually makes many calls;
## one long lived process answers them in about a millisecond each. Results
## still go to a file, so the pipe only ever carries a marker line.
##
BindGlobal("POLYMAKING_DONE", "__polymaking_done__");

# perl double quoted string literal
BindGlobal("POLYMAKING_PerlString", function(str)
    local out, c;
    out := "\"";
    for c in str do
        if c in "\\\"$@" then
            Add(out, '\\');
        fi;
        Add(out, c);
    od;
    Add(out, '\"');
    return out;
end);

BindGlobal("POLYMAKING_Bool", b -> String(Number([b], x -> x = true)));

BindGlobal("POLYMAKING_PerlList",
        l -> Concatenation("[", JoinStringsWithSeparator(
                List(l, POLYMAKING_PerlString), ","), "]"));


# Read until polymake reports the call finished. fail means the process died,
# in which case the caller retries once with a fresh one.
BindGlobal("POLYMAKING_AwaitDone", function(stream)
    local line;
    while true do
        line := ReadLine(stream);
        if line = fail then
            return false;
        fi;
        line := Chomp(line);
        if line = POLYMAKING_DONE then
            return true;
        elif line <> "" then
            Info(InfoPolymaking, 2, line);
        fi;
    od;
end);


BindGlobal("POLYMAKING_StopServer", function()
    if POLYMAKING_STATE.server <> fail then
        if not IsClosedStream(POLYMAKING_STATE.server) then
            CloseStream(POLYMAKING_STATE.server);
        fi;
        POLYMAKING_STATE.server := fail;
    fi;
end);


# The settings baked into a running polymake: its config path and quiet flag are
# fixed when it starts, and rule preferences cannot be withdrawn once applied.
# Changing any of them means starting again.
BindGlobal("POLYMAKING_ServerSettings", function()
    return [ PolymakeCommand(),
             UserPreference("polymaking", "PolymakeConfigPath"),
             UserPreference("polymaking", "PolymakeQuiet"),
             UserPreference("polymaking", "PolymakePreferences") ];
end);


BindGlobal("POLYMAKING_StartServer", function()
    local cmd, stream, prelude;

    cmd := PolymakeCommand();
    if cmd = fail then
        return fail;
    fi;
    stream := InputOutputLocalProcess(POLYMAKING_TempDirectory("scratch"), cmd,
                      ["--config-path",
                       UserPreference("polymaking", "PolymakeConfigPath"), "-"]);
    if stream = fail then
        return fail;
    fi;

    prelude := Concatenation(
        "do ", POLYMAKING_PerlString(
                Filename(DirectoriesPackageLibrary("polymaking"), "pm.pl")), "; ",
        "polymaking_setup(",
        POLYMAKING_PerlString(POLYMAKING_ScratchFile("stderr.txt")), ", ",
        POLYMAKING_Bool(UserPreference("polymaking", "PolymakeQuiet")), "); ",
        "print ", POLYMAKING_PerlString(POLYMAKING_DONE), ", \"\\n\";");

    if WriteLine(stream, prelude) = fail
       or not POLYMAKING_AwaitDone(stream) then
        CloseStream(stream);
        return fail;
    fi;
    POLYMAKING_STATE.server := stream;
    POLYMAKING_STATE.serverSettings := POLYMAKING_ServerSettings();
    return stream;
end);


BindGlobal("POLYMAKING_Result", function(resfile, errfile, status)
    local err, res;
    err := StringFile(errfile);
    if err = fail then
        err := "";
    fi;
    if err <> "" then
        Info(InfoPolymaking, 2, Chomp(err));
    fi;
    res := StringFile(resfile);
    if res = fail then
        return rec(status := status, stderr := err, result := fail);
    fi;
    return rec(status := status, stderr := err, result := JsonStringToGap(res));
end);


# Ask the persistent polymake; fail means it could not be used at all, so the
# caller falls back to starting polymake for this one call.
BindGlobal("POLYMAKING_RunServer", function(objfile, keywords, resfile)
    local try, stream, call;

    if UserPreference("polymaking", "PolymakePersistent") <> true then
        return fail;
    fi;

    call := Concatenation(
        "polymaking_eval(", POLYMAKING_PerlString(resfile), ", ",
        POLYMAKING_PerlString(POLYMAKING_ScratchFile("stderr.txt")), ", ",
        POLYMAKING_PerlString(objfile), ", ",
        POLYMAKING_PerlList(UserPreference("polymaking", "PolymakePreferences")),
        Concatenation(List(keywords, k -> Concatenation(", ", POLYMAKING_PerlString(k)))),
        "); print ", POLYMAKING_PerlString(POLYMAKING_DONE), ", \"\\n\";");

    # one retry, in case polymake died or was closed since the last call. Talking
    # to a closed stream raises an error rather than returning fail, so the whole
    # exchange goes through CALL_WITH_CATCH.
    if POLYMAKING_STATE.server <> fail
       and POLYMAKING_STATE.serverSettings <> POLYMAKING_ServerSettings() then
        POLYMAKING_StopServer();
    fi;

    for try in [1, 2] do
        stream := POLYMAKING_STATE.server;
        if stream <> fail and IsClosedStream(stream) then
            POLYMAKING_STATE.server := fail;
            stream := fail;
        fi;
        if stream = fail then
            stream := POLYMAKING_StartServer();
            if stream = fail then
                return fail;
            fi;
        fi;
        if CALL_WITH_CATCH(function()
                   return WriteLine(stream, call) <> fail
                          and POLYMAKING_AwaitDone(stream);
               end, []) = [true, true] then
            return true;
        fi;
        POLYMAKING_StopServer();
    od;
    return fail;
end);


InstallGlobalFunction(POLYMAKING_Run, function(dir, args)
    local cmd, errfile, resfile, scriptarg, p, out, status, err, res;

    cmd := PolymakeCommand();
    if cmd = fail then
        UpdatePolymakeFailReason("no usable polymake executable configured");
        ErrorNoReturn("polymake not found; set it via SetUserPreference(",
                "\"polymaking\", \"PolymakeCommand\", <path>)");
    fi;

    errfile := POLYMAKING_ScratchFile("stderr.txt");
    resfile := POLYMAKING_ScratchFile("result.json");
    RemoveFile(errfile);
    RemoveFile(resfile);

    # args is [objfile, keyword...], or ["--version"]
    if Length(args) > 1 and POLYMAKING_RunServer(args[1], args{[2..Length(args)]},
                                                 resfile) = true then
        return POLYMAKING_Result(resfile, errfile, 0);
    fi;

    scriptarg := ["--config-path", UserPreference("polymaking","PolymakeConfigPath"),
                  "--script", Filename(DirectoriesPackageLibrary("polymaking"), "pm.pl"),
                  "--stderr", errfile];
    if UserPreference("polymaking","PolymakeQuiet") = true then
        Add(scriptarg, "--quiet");
    fi;
    for p in UserPreference("polymaking","PolymakePreferences") do
        Append(scriptarg, ["--prefer", p]);
    od;
    Append(scriptarg, ["--", resfile]);
    Append(scriptarg, args);

    out := OutputTextNone();
    status := Process(dir, cmd, InputTextNone(), out, scriptarg);
    CloseStream(out);

    return POLYMAKING_Result(resfile, errfile, status);
end);


InstallGlobalFunction(PolymakeVersion, function()
    local r;
    if POLYMAKING_STATE.version = fail then
        r := POLYMAKING_Run(DirectoryCurrent(), ["--version"]);
        if r.result = fail or not IsBound(r.result.version) then
            return fail;
        fi;
        POLYMAKING_STATE.version := r.result.version;
    fi;
    return POLYMAKING_STATE.version;
end);


# polymaking 0.9 writes and reads polymake's JSON format, which polymake 3 and
# earlier cannot handle at all, so this is an error rather than a warning.
InstallGlobalFunction(POLYMAKING_CheckVersion, function()
    local v;
    if POLYMAKING_STATE.versionChecked then
        return;
    fi;
    v := PolymakeVersion();
    if v = fail then
        ErrorNoReturn("could not determine the polymake version; check that ",
                PolymakeCommand(), " works");
    elif not CompareVersionNumbers(v, "4.0") then
        ErrorNoReturn("polymaking requires polymake 4.0 or newer, but found ",
                v, ". Use polymaking 0.8.9 with older versions of polymake.");
    fi;
    POLYMAKING_STATE.versionChecked := true;
end);


##
## Keep POLYMAKE_COMMAND and POLYMAKE_DATA_DIR in existence for packages that
## still read them, hap and hapcryst among them. They are plain assignments
## rather than BindGlobal, so that the post restore hook can refresh them.
##
BindGlobal("POLYMAKING_Rebind", function(name, value)
    if IsBoundGlobal(name) then
        MakeReadWriteGlobal(name);
        UnbindGlobal(name);
    fi;
    BindGlobal(name, value);
end);

InstallGlobalFunction(POLYMAKING_UpdateLegacyGlobals, function()
    if not POLYMAKING_LEGACY_SET.command then
        POLYMAKING_Rebind("POLYMAKE_COMMAND", PolymakeCommand());
    fi;
    if not POLYMAKING_LEGACY_SET.dataDir then
        POLYMAKING_Rebind("POLYMAKE_DATA_DIR", PolymakeDataDirectory());
    fi;
end);

POLYMAKING_UpdateLegacyGlobals();

# a stream does not survive into another session
CallAndInstallPostRestore(function()
    POLYMAKING_STATE.server := fail;
end);

InstallAtExit(POLYMAKING_StopServer);

# the data directory a restored workspace names is gone, see issue #17
CallAndInstallPostRestore(POLYMAKING_UpdateLegacyGlobals);


if PolymakeCommand() = fail then
    Info(InfoWarning, 1, "polymake command not found; set it via ",
         "SetUserPreference(\"polymaking\", \"PolymakeCommand\", <path>)");
fi;


####
### 
##  Handling of last fail reason:
#
InstallValue(POLYMAKE_LAST_FAIL_REASON,"");

InstallMethod(UpdatePolymakeFailReason,[IsString],
        function(reason)
    MakeReadWriteGlobal("POLYMAKE_LAST_FAIL_REASON");
    POLYMAKE_LAST_FAIL_REASON:=reason;
    MakeReadOnlyGlobal("POLYMAKE_LAST_FAIL_REASON");
end);

