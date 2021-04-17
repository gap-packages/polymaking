#############################################################################
##
#W convert.gd              polymaking Package      Marc Roeder
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
DeclareOperation("ConvertPolymakeOutputToGapNotation",[IsString]);
DeclareOperation("SplitPolymakeOutputStringIntoBlocks",[IsString]);
DeclareOperation("ConvertedObject",[IsString,IsDenseList]);

DeclareOperation("ConverterSyntaxError",[IsString]);

DeclareOperation("ConvertPolymakeNumber",[IsString]);

DeclareOperation("ConvertPolymakeScalarToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeBoolToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeDescriptionToGAP",[IsDenseList]);

DeclareOperation("ConvertPolymakeMatrixOrListOfSetsToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeMatrixOrListOfSetsToGAPPlusOne",[IsDenseList]);

DeclareOperation("ConvertPolymakeMatrixToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeMatrixToGAPKillOnes",[IsDenseList]);
DeclareOperation("ConvertPolymakeVectorToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeVectorToGAPKillOne",[IsDenseList]);
DeclareOperation("ConvertPolymakeIntVectorToGAPPlusOne",[IsDenseList]);


DeclareOperation("ConvertPolymakeSetToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeListOfSetsToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeListOfSetsToGAPPlusOne",[IsDenseList]);

DeclareOperation("ConvertPolymakeSetOfSetsToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeGraphToGAP",[IsDenseList]);
DeclareOperation("ConvertPolymakeFaceLatticeToGAP",[IsDenseList]);
