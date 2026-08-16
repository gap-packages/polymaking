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

