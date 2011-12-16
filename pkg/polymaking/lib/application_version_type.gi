#############################################################################
##
#W application_version_type.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id: application_version_type.gi, v 0.7.8 2010/06/03 21:29:50 gap Exp $
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
Revision.("/Users/roeder/gap/polymaking/polymaking/lib/application_version_type_gi"):=
	"@(#)$Id: application_version_type.gi, v 0.7.8 2010/06/03   21:29:50  gap Exp $";
InstallMethod(CheckAppVerTypList,[IsDenseList],
        function(appvertyp)
    local   app,  type;
    
    if Size(appvertyp)<>3
       or not ForAll(appvertyp,IsString)
       then
        return false;
    fi;
    
    ## test applicateion and possible data types:
    
    app:=NormalizedWhitespace(appvertyp[1]);
    type:=NormalizedWhitespace(appvertyp[3]);
    if app = "polytope"
       then
        if not type in ["Polytope",
                   "RationalPolytope",
                   "FloatPolytope",
                   "SchlegelDiagram",
                   "VoronoiDiagram",
                   "TightSpan",
                   "PropagatedPolytope",
                   "Framework"
                   ]
           then
            return false;
        fi;
    elif app="surface"
      then
        if not type="Surface"
           then
            return false;
        fi;
    elif app="topaz"
      then
        if not type="SimplicialComplex"
           then
            return false;
        fi;
    fi;
    return true;
end);