#############################################################################
##
#W ObjectConverters.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id: ObjectConverters.gi, v 0.7.8 2010/06/03 21:29:50 gap Exp $
##
#Y	 Copyright (C) 2006 Marc Roeder 
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
Revision.("/Users/roeder/gap/polymaking/polymaking/lib/ObjectConverters_gi"):=
	"@(#)$Id: ObjectConverters.gi, v 0.7.8 2010/06/03   21:29:50  gap Exp $";
InstallValue(ObjectConverters,
        rec(
            ALTSHULER_DET:=ConvertPolymakeScalarToGAP,
                           AMBIENT_DIM:=ConvertPolymakeScalarToGAP,
                           BALANCED:=ConvertPolymakeBoolToGAP,
                           BALANCE:=ConvertPolymakeScalarToGAP,
                           BALL:=ConvertPolymakeBoolToGAP,
                           BIPARTITE:=ConvertPolymakeBoolToGAP,
                           BOUNDARY_OF_PSEUDO_MANIFOLD:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           BOUNDED:=ConvertPolymakeBoolToGAP,
                           CENTERED:=ConvertPolymakeBoolToGAP,
                           CLOSED_PSEUDO_MANIFOLD:=ConvertPolymakeBoolToGAP,
                           COCUBICAL:=ConvertPolymakeBoolToGAP,
                           COMPLEXITY:=ConvertPolymakeScalarToGAP,
                           CUBICAL:=ConvertPolymakeBoolToGAP,
                           COCUBICALITY:=ConvertPolymakeScalarToGAP,
                           COLORING:=ConvertPolymakeIntVectorToGAPPlusOne,
                           COMPLEXITY:=ConvertPolymakeScalarToGAP,
                           CONNECTED:=ConvertPolymakeBoolToGAP,
                           CONNECTED_COMPONENTS:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           CONNECTIVITY:=ConvertPolymakeScalarToGAP,
                           DESCRIPTION:=ConvertPolymakeDescriptionToGAP,
                           DIAMETER:=ConvertPolymakeScalarToGAP,
                           DIM:=ConvertPolymakeScalarToGAP,
                           DUAL_COLORING:=ConvertPolymakeIntVectorToGAPPlusOne,
                           DUAL_CONNECTED:=ConvertPolymakeBoolToGAP,
                           DUAL_CONNECTED_COMPONENTS:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           DUAL_CONNECTIVITY:=ConvertPolymakeScalarToGAP,
                           DUAL_DIAMETER:=ConvertPolymakeScalarToGAP,
                           DUAL_BIPARTITE:=ConvertPolymakeBoolToGAP,
                           DUAL_EVEN:=ConvertPolymakeBoolToGAP,
                           DUAL_GRAPH:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           DUAL_GRAPH_SIGNATURE:=ConvertPolymakeScalarToGAP,
                           DUAL_MAX_CLIQUES:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           DUAL_TRIANGLE_FREE:=ConvertPolymakeBoolToGAP,
                           EQUATIONS:=ConvertPolymakeMatrixToGAP,
                           ESSENTIALLY_GENERIC:=ConvertPolymakeBoolToGAP,
                           EULER_CHARACTERISTIC:=ConvertPolymakeScalarToGAP,
                           EVEN:=ConvertPolymakeBoolToGAP,
                           F_VECTOR:=ConvertPolymakeVectorToGAP,
                           F2_VECTOR:=ConvertPolymakeMatrixToGAP,
                           FACE_LATTICE:=ConvertPolymakeFaceLatticeToGAP,
                           FACET_DEGREES:=ConvertPolymakeVectorToGAP,
                           FACETS:=ConvertPolymakeMatrixOrListOfSetsToGAPPlusOne,
                           FAR_HYPERPLANE:=ConvertPolymakeVectorToGAP,
                           FATNESS:=ConvertPolymakeScalarToGAP,
                           FEASIBLE:=ConvertPolymakeBoolToGAP,
                           G_DIM:=ConvertPolymakeScalarToGAP,
                           GENUS:=ConvertPolymakeBoolToGAP,
                           GEOMETRIC_REALIZATION:=ConvertPolymakeMatrixToGAP,
                           GRAPH:=ConvertPolymakeGraphToGAP,
                           GRAPH_SIGNATURE:=ConvertPolymakeScalarToGAP,
                           HASSE_DIAGRAM:=ConvertPolymakeHasseDiagramToGAP,
                           INEQUALITIES:=ConvertPolymakeMatrixToGAP,
                           LATTICE:=ConvertPolymakeBoolToGAP,
                           INPUT_FACES:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           LOCALLY_STRONGLY_CONNECTED:=ConvertPolymakeBoolToGAP,
                           MORSE_MATCHING_N_CRITICAL_FACES:=ConvertPolymakeScalarToGAP,
                           N_01POINTS:=ConvertPolymakeScalarToGAP,
                           N_BOUNDED_VERTICES:=ConvertPolymakeScalarToGAP,
                           N_CONNECTED_COMPONENTS:=ConvertPolymakeScalarToGAP,
                           N_DEGREES_OF_FREEDOM:=ConvertPolymakeScalarToGAP,
                           N_EDGES:=ConvertPolymakeScalarToGAP,
                           N_FACETS:=ConvertPolymakeScalarToGAP,
                           N_FLAGS:=ConvertPolymakeScalarToGAP,
                           N_INEQUALITIES:=ConvertPolymakeScalarToGAP,
                           N_MINIMAL_NON_FACES:=ConvertPolymakeScalarToGAP,
                           N_NODES:=ConvertPolymakeScalarToGAP,
                           N_NON_NEG_INT:=ConvertPolymakeScalarToGAP,
                           N_POINTS:=ConvertPolymakeScalarToGAP,
                           N_RIDGES:=ConvertPolymakeScalarToGAP,
                           N_SITES:=ConvertPolymakeScalarToGAP,
                           N_VERTEX_FACET_INC:=ConvertPolymakeScalarToGAP,
                           N_VERTICES:=ConvertPolymakeScalarToGAP,
                           NEIGHBORLINESS:=ConvertPolymakeScalarToGAP,
                           NEIGHBORLY:=ConvertPolymakeBoolToGAP,
                           MANIFOLD:=ConvertPolymakeBoolToGAP,
                           MAX_CLIQUES:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           MAXIMAL_VALUE:=ConvertPolymakeScalarToGAP,
                           MINIMAL_NON_FACES:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           MINIMAL_VALUE:=ConvertPolymakeScalarToGAP,
                           MINIMAL_VERTEX:=ConvertPolymakeVectorToGAPKillOne,
                           MINIMAL_VERTEX_ANGLE:=ConvertPolymakeScalarToGAP,
                           MORSE_MATCHING:=ConvertPolymakeGraphToGAP,
                           MORSE_MATCHING_CRITICAL_FACE_VECTOR:=ConvertPolymakeIntVectorToGAPPlusOne,
                           MORSE_MATCHING_CRITICAL_FACES:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           MORSE_MATCHING_N_CRITICAL_FACES:=ConvertPolymakeScalarToGAP,
                           MORSE_MATCHING_SIZE:=ConvertPolymakeScalarToGAP,
                           NEIGHBORLY:=ConvertPolymakeBoolToGAP,
                           ODD_SUBCOMPLEX:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           ORIENTED_PSEUDO_MANIFOLD:=ConvertPolymakeBoolToGAP,
                           POINTED:=ConvertPolymakeBoolToGAP,
                           POINTS:=ConvertPolymakeMatrixToGAPKillOnes,
                           POSITIVE:=ConvertPolymakeBoolToGAP,
                           PROJ_DICTIONARY:=ConvertPolymakeIntVectorToGAPPlusOne,
                           PSEUDO_MANIFOLD:=ConvertPolymakeBoolToGAP,
                           PURE:=ConvertPolymakeBoolToGAP,
                           REL_INT_POINT:=ConvertPolymakeVectorToGAPKillOne,
                           SELF_DUAL:=ConvertPolymakeBoolToGAP,
                           SIGNATURE:=ConvertPolymakeScalarToGAP,
                           SIMPLE:=ConvertPolymakeBoolToGAP,
                           SIMPLICIAL:=ConvertPolymakeBoolToGAP,
                           SURFACE:=ConvertPolymakeBoolToGAP,
                           TRIANGLE_FREE:=ConvertPolymakeBoolToGAP,
                           VALID_POINT:=ConvertPolymakeVectorToGAPKillOne,
                           VERTEX_BARYCENTER:=ConvertPolymakeVectorToGAPKillOne,
                           VERTEX_DEGREES:=ConvertPolymakeVectorToGAP,
                           VERTICES:=ConvertPolymakeMatrixToGAPKillOnes,
                           VERTICES_IN_FACETS:=ConvertPolymakeListOfSetsToGAPPlusOne,
                           VOLUME:=ConvertPolymakeScalarToGAP
                           )
                           );
