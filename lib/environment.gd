#############################################################################
##
#W environment.gd            polymaking Package      Marc Roeder
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
DeclareInfoClass("InfoPolymaking");

##
## the effective polymake command and data directory, see lib/userpref.gi
##
DeclareGlobalFunction("PolymakeCommand");
DeclareGlobalFunction("PolymakeDataDirectory");
DeclareGlobalFunction("PolymakeVersion");
DeclareGlobalFunction("POLYMAKING_Run");
DeclareGlobalFunction("POLYMAKING_CheckVersion");
DeclareGlobalFunction("POLYMAKING_UpdateLegacyGlobals");

##
## deprecated in favour of the user preferences PolymakeCommand and
## PolymakeDataDirectory
##
DeclareOperation("SetPolymakeDataDirectory",[IsDirectory]);
DeclareOperation("SetPolymakeCommand",[IsString]);

##
## keep track of the last thing that caused Polymake to return fail:
##
DeclareGlobalVariable("POLYMAKE_LAST_FAIL_REASON");
DeclareOperation("UpdatePolymakeFailReason",[IsString]);



