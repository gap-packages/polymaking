#############################################################################
##
#W hasse_diagram_old.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id: hasse_diagram_old.gi, v 0.7.8 2010/06/03 21:29:50 gap Exp $
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
Revision.("/Users/roeder/gap/polymaking/polymaking/lib/hasse_diagram_old_gi"):=
	"@(#)$Id: hasse_diagram_old.gi, v 0.7.8 2010/06/03   21:29:50  gap Exp $";
InstallMethod(ConvertPolymakeHasseDiagramToGAP,[IsDenseList],
       function(stringlist)
    local   startnumbers,  rest,  nodes,  node,  stringpair,  
            faceblocks,  facenumber,  permlist,  pi,  maxnode,  i,  
            upface,  blockindex,  downshift,  upshift,  face,  
            returnrec,  modgens,  elts;
    
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
    
    faceblocks:=List([2..Size(startnumbers)],i->[startnumbers[i-1]+1..startnumbers[i]]);
    facenumber:=startnumbers[Size(startnumbers)]+1;

    if Size(nodes[2][1])>1
       then
        Info(InfoPolymaking,1,"polymake returned dual Hasse diagram. Recovering original");
        ####
        # if the Hasse diagram ends in a list of points,
        # we do some strange permutation and renumbering to get a Hasse 
        # diagram starting with points (and the dimension of the faces 
        # increases as we proceed down)
        ####
        Apply(faceblocks,i->Reversed(facenumber-i+1));
        permlist:=[facenumber];
        Append(permlist,Concatenation(faceblocks));
        Add(permlist,1);
        
        pi:=PermList(permlist);
        nodes:=Permuted(nodes,pi);
            # now we have the faces in ascending order. But the second 
            # column is still wrong. So we do some renumbering:
        #permlist[1]:=Size(nodes);
        #pi2:=PermList(permlist); 
        for node in nodes
          do
            node[2]:=OnSets(node[2]+1,pi)-1;
        od;
    fi;
    
    ####
    # now the Hasse <nodes>diagram starts with a list of points (i.e. 
    # the faces are ordered ascendingly wrt dimension), this will work:
    ####
    Remove(nodes,1);
    Apply(nodes,i->Concatenation(i,[[]]));
    maxnode:=Size(nodes);
#    Remove(nodes,maxnode);
    for i in [1..maxnode]#-1]
      do
        Apply(nodes[i][1],i->i+1);
#        if nodes[i][2]=[maxnode]
#           then
#            nodes[i][2]:=[];
#        else
            for upface in nodes[i][2]
              do
                Add(nodes[upface][3],i);
            od;
#        fi;
    od;
    
    for node in nodes
      do
        Apply(node,Set);
    od;
    
    Apply(faceblocks,i->i-1);
    Add(faceblocks,[maxnode]);
    #
    # And now we split the nodes of the Hasse diagram according to dimension.
    # This was added when the function was already complete. So this is 
    # probably not the right order of doing things. But I didn't want to 
    # rewrite the renumbering part above...
    #
    faceblocks:=Set(faceblocks);
    for blockindex in [1..Size(faceblocks)]
      do
        nodes[blockindex]:=nodes{faceblocks[blockindex]};
    od;
    while Size(nodes)>Size(faceblocks)
      do
        Remove(nodes);
    od;     
    for blockindex in [1..Size(nodes)]
      do
        if blockindex>1
           then
            downshift:=-faceblocks[blockindex-1][1]+1;
        else
            downshift:=0;
        fi;
        if blockindex<Size(nodes)
           then
            upshift:=-faceblocks[blockindex+1][1]+1;
        else
            upshift:=0;
        fi;
        for face in nodes[blockindex]
          do
            face[2]:=face[2]+upshift;
            face[3]:=face[3]+downshift;
        od;
    od;
    
    #ForAll(faceblocks,IsRange);
#    returnrec:=rec(hasse:=nodes, 
#                   modgens:=List(nodes,n->List(n,i->i[1])),
#                   elts:=[]);    #faceindices:=Set(faceblocks));
#   return returnrec;
    MakeImmutable(nodes);
    return nodes;
end);

