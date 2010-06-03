#############################################################################
##
#W hasse_diagram.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id: hasse_diagram.gi, v 0.7.8 2010/06/03 21:29:50 gap Exp $
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
Revision.("/Users/roeder/gap/polymaking/polymaking/lib/hasse_diagram_gi"):=
	"@(#)$Id: hasse_diagram.gi, v 0.7.8 2010/06/03   21:29:50  gap Exp $";
InstallMethod(ConvertPolymakeHasseDiagramToGAP,[IsDenseList],
       function(stringlist)
    local   startnumbers,  rest,  nodes,  node,  stringpair,  
            faceblocks,  facenumber,  i,  faceindices;
    
    ###
    # convert the first line to a list of integers
    # and remove the leading "<" from the rest.
    # Throw away the last line, as it only consists of ">"
    ###
    startnumbers:=List(SplitString(stringlist[1]," "),ConvertPolymakeNumber);
    rest:=stringlist{[2..Size(stringlist)-1]};
    rest[1]:=ReplacedString(rest[1],"<","");
    nodes:=[];
    ###
    # convert each line of the remaining output 
    # to two lists of integers.
    ###    
    for node in rest 
      do
        stringpair:=ReplacedString(ReplacedString(node,")",""),"(","");
        stringpair:=SplitString(stringpair,"","}");
        Append(stringpair[1],"}");
        Append(stringpair[2],"}");
        Add(nodes,List(stringpair,i->ConvertPolymakeSetToGAP([i])));
    od;
    
    startnumbers:=Concatenation([0],startnumbers);
    
    faceblocks:=List([2..Size(startnumbers)],i->[startnumbers[i-1]..startnumbers[i]-1]);
    facenumber:=startnumbers[Size(startnumbers)]+1;
    Apply(faceblocks,i->i+1);
    Add(faceblocks,[facenumber]);
    
    for i in [1..facenumber]
      do
        Apply(nodes[i],i->i+1);
    od;
    
    for node in nodes
      do
        Apply(node,Set);
    od;
    
    MakeImmutable(nodes);
    MakeImmutable(faceblocks);
    return rec(hasse:=nodes, 
                faceindices:=Set(faceblocks)
                );
end);

