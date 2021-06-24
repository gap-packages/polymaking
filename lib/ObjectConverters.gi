#############################################################################
##
#W ObjectConverters.gi           polymaking Package      Marc Roeder
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
InstallValue(ObjectConverters, rec(
    ALTSHULER_DET:=ConvertPolymakeScalarToGAP,
    AMBIENT_DIM:=ConvertPolymakeScalarToGAP,
    BALANCED:=ConvertPolymakeBoolToGAP,
    BALANCE:=ConvertPolymakeScalarToGAP,
    BOUNDED:=ConvertPolymakeBoolToGAP,
    CENTERED:=ConvertPolymakeBoolToGAP,
    COCUBICAL:=ConvertPolymakeBoolToGAP,
    COMPLEXITY:=ConvertPolymakeScalarToGAP,
    CUBICAL:=ConvertPolymakeBoolToGAP,
    COCUBICALITY:=ConvertPolymakeScalarToGAP,
    COMPLEXITY:=ConvertPolymakeScalarToGAP,
    DIMS:=ConvertPolymakeVectorToGAP,  ## done using mapping-hack
    DIM:=ConvertPolymakeScalarToGAP,
    DUAL_CONNECTIVITY:=ConvertPolymakeScalarToGAP,
    DUAL_DIAMETER:=ConvertPolymakeScalarToGAP,
    DUAL_EVEN:=ConvertPolymakeBoolToGAP,
    DUAL_GRAPH_SIGNATURE:=ConvertPolymakeScalarToGAP,
    DUAL_TRIANGLE_FREE:=ConvertPolymakeBoolToGAP,
    EQUATIONS:=ConvertPolymakeMatrixToGAP,
    ESSENTIALLY_GENERIC:=ConvertPolymakeBoolToGAP,
    EVEN:=ConvertPolymakeBoolToGAP,
    F_VECTOR:=ConvertPolymakeVectorToGAP,
    F2_VECTOR:=ConvertPolymakeMatrixToGAP,
    FACES:=ConvertPolymakeListOfSetsToGAPPlusOne,
    ADJACENCY:=ConvertPolymakeListOfSetsToGAPPlusOne,
    FACET_DEGREES:=ConvertPolymakeVectorToGAP,
    FACETS:=ConvertPolymakeMatrixOrListOfSetsToGAPPlusOne,
    FAR_HYPERPLANE:=ConvertPolymakeVectorToGAP,
    FATNESS:=ConvertPolymakeScalarToGAP,
    FEASIBLE:=ConvertPolymakeBoolToGAP,
    GRAPH:=ConvertPolymakeGraphToGAP,
    GRAPH_SIGNATURE:=ConvertPolymakeScalarToGAP,
    INEQUALITIES:=ConvertPolymakeMatrixToGAP,
    LATTICE:=ConvertPolymakeBoolToGAP,
    N_01POINTS:=ConvertPolymakeScalarToGAP,
    N_BOUNDED_VERTICES:=ConvertPolymakeScalarToGAP,
    N_FACETS:=ConvertPolymakeScalarToGAP,
    N_FLAGS:=ConvertPolymakeScalarToGAP,
    N_INEQUALITIES:=ConvertPolymakeScalarToGAP,
    N_POINTS:=ConvertPolymakeScalarToGAP,
    N_RIDGES:=ConvertPolymakeScalarToGAP,
    N_VERTEX_FACET_INC:=ConvertPolymakeScalarToGAP,
    N_VERTICES:=ConvertPolymakeScalarToGAP,
    NEIGHBORLINESS:=ConvertPolymakeScalarToGAP,
    NEIGHBORLY:=ConvertPolymakeBoolToGAP,
    MINIMAL_VERTEX_ANGLE:=ConvertPolymakeScalarToGAP,
    POINTED:=ConvertPolymakeBoolToGAP,
    POINTS:=ConvertPolymakeMatrixToGAPKillOnes,
    POSITIVE:=ConvertPolymakeBoolToGAP,
    REL_INT_POINT:=ConvertPolymakeVectorToGAPKillOne,
    SELF_DUAL:=ConvertPolymakeBoolToGAP,
    SIMPLE:=ConvertPolymakeBoolToGAP,
    SIMPLICIAL:=ConvertPolymakeBoolToGAP,
    VALID_POINT:=ConvertPolymakeVectorToGAPKillOne,
    VERTEX_BARYCENTER:=ConvertPolymakeVectorToGAPKillOne,
    VERTEX_DEGREES:=ConvertPolymakeVectorToGAP,
    VERTICES:=ConvertPolymakeMatrixToGAPKillOnes,
    VERTICES_IN_FACETS:=ConvertPolymakeListOfSetsToGAPPlusOne,
    VOLUME:=ConvertPolymakeScalarToGAP,
));
