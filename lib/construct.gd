#############################################################################
##
#W construct.gd              polymaking Package      Marc Roeder
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
DeclareOperation("CreateEmptyFile",[IsString]);

DeclareOperation("InitPolymakeObject",[IsPolymakeObject]);

DeclareOperation("CreatePolymakeObjectFromFile",[IsString]);
DeclareOperation("CreatePolymakeObjectFromFile",[IsDirectory,IsString]);

DeclareOperation("CreatePolymakeObject",[]);
DeclareOperation("CreatePolymakeObject",[IsDenseList]);
DeclareOperation("CreatePolymakeObject",[IsDirectory]);
DeclareOperation("CreatePolymakeObject",[IsDirectory,IsDenseList]);
DeclareOperation("CreatePolymakeObject",[IsString,IsDirectory]);
DeclareOperation("CreatePolymakeObject",[IsString,IsDirectory,IsDenseList]);

DeclareOperation("ConvertMatrixToPolymakeString",[IsString,IsDenseList]);

DeclareOperation("AppendToPolymakeObject",[IsPolymakeObject,IsString]);
DeclareOperation("AppendToPolymakeObject",[IsPolymakeObject,IsString,IsString]);
DeclareOperation("AppendPointlistToPolymakeObject",[IsPolymakeObject,IsDenseList]);
DeclareOperation("AppendVertexlistToPolymakeObject",[IsPolymakeObject,IsDenseList]);
DeclareOperation("AppendInequalitiesToPolymakeObject",[IsPolymakeObject,IsDenseList]);

DeclareOperation("Polymake",[IsPolymakeObject,IsString]);

