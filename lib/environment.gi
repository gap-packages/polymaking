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

# give the command which calls polymake. You may need to include the full path
####

if not IsBound(POLYMAKE_COMMAND)
   then
    POLYMAKE_COMMAND:=Filename( DirectoriesSystemPrograms( ), "polymake" );
fi;
if POLYMAKE_COMMAND=fail
   or not IsExecutableFile(POLYMAKE_COMMAND)
   then
    Info(InfoWarning,1,"polymake command not found. Please set POLYMAKE_COMMAND by hand");
else
    MakeReadOnlyGlobal("POLYMAKE_COMMAND");
fi;

InstallMethod(SetPolymakeCommand,[IsString],
        function(command)
    if not IsExecutableFile(command)
       then
        Error("polymake command must exist and be executable.");
    else
        MakeReadWriteGlobal("POLYMAKE_COMMAND");
        POLYMAKE_COMMAND:=command;
        MakeReadOnlyGlobal("POLYMAKE_COMMAND");
    fi;
end);


#
# This directory will hold the files generated for polymake
# It can be changed using "SetPolymakeDataDirectory"
###
if not IsBound(POLYMAKE_DATA_DIR)
   then
    POLYMAKE_DATA_DIR:=DirectoryTemporary();
fi;
MakeReadOnlyGlobal("POLYMAKE_DATA_DIR");


InstallMethod(SetPolymakeDataDirectory,[IsDirectory],
        function(dir)
    MakeReadWriteGlobal("POLYMAKE_DATA_DIR");
    POLYMAKE_DATA_DIR:=dir;
    MakeReadOnlyGlobal("POLYMAKE_DATA_DIR");
end);



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

