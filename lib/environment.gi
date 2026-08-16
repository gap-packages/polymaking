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

BindGlobal("POLYMAKING_InfoDeprecated", function(name, replacement)
    Info(InfoObsolete, 1, "`", name, "` is deprecated, use ", replacement,
         " instead.");
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

