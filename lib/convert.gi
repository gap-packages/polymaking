#############################################################################
##
#W convert.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id$
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
Revision.("/home/roeder/gap/polymaking/polymaking/lib/convert_gi"):=
	"@(#)$Id$";
InstallMethod(ConvertPolymakeOutputToGapNotation,[IsString],
        function(string)
    local   split,  blockpositions,  splitblocks,  returnlist,  
            splitblock,  name,  rest,  object;
    
    splitblocks:=SplitPolymakeOutputStringIntoBlocks(string);
    returnlist:=[];
    for splitblock in splitblocks
      do
        name:=NormalizedWhitespace(splitblock[1]);
        rest:=splitblock{[2..Maximum(Size(splitblock),2)]};
        if rest[Size(rest)]=""
           then
            Unbind(rest[Size(rest)]);
        fi;
#        Apply(rest,NormalizedWhitespace);
        if IsBound(ObjectConverters.(name))
           then
            object:=ObjectConverters.(name)(rest);
            if object<>fail 
               then
                Add(returnlist,rec(name:=name,object:=object));
            else
                Info(InfoPolymaking,1,"Conversion failed. Maybe invalid output from polymake. This value is not stored");
                Add(returnlist, rec(name:=name,object:=fail));
            fi; 
        else
            Info(InfoPolymaking,1,"No Method to convert ", name,". Record not updated for this block");
            Add(returnlist, rec(name:=name,object:=fail));
        fi;
    od;
    return returnlist; 
end);


#
#First the method to split polymake's output into different blocks by
# recognizing lines which may be keyword-lines
###############

InstallMethod(SplitPolymakeOutputStringIntoBlocks,[IsString],
        function(string)
    local   blocks,  newblock,  lines,  line;
    
    blocks:=[];
    newblock:=[];
    lines:=SplitString(string,"\n");
    while lines<>[]
      do
        line:=Remove(lines,1);
        if not IsEmptyString(line) 
           then
            if IsUpperAlphaChar(line[1])
               then
                if blocks=[] and newblock=[]
                   then
                    newblock:=[line];
                else
                    Add(blocks,ShallowCopy(newblock));
                    newblock:=[line];
                fi;
            else
                Add(newblock,line);
            fi;
        fi;
    od; 
    if newblock<>[]
       then
        Add(blocks,newblock);
    fi;
    return blocks;
end);



# Now the different conversion methods:
####################

InstallMethod(ConvertPolymakeNumber,[IsString],
        function(string)
    local   sstring,  denom,  enum;
    if '.' in string
       then
        Info(InfoPolymaking,1,"Warnig!converting a floating point number"); 
        sstring:=SplitString(string,".");
        denom:=10^(Length(sstring[2]));
        enum:=Int(Concatenation(sstring));
        return enum/denom;
    elif string=""
      then
        Error("string is empty");
    else
        return Rat(string);
    fi;
end);

InstallMethod(ConvertPolymakeScalarToGAP,[IsDenseList],
        function(stringlist)
    if Size(stringlist)<>1
       then
        Error("list ist too long to be converted to a scalar");
        return fail;
    else
        return ConvertPolymakeNumber(stringlist[1]);
    fi;
end);

InstallMethod(ConvertPolymakeMatrixToGAP,[IsDenseList],
        function(stringlist)
    local returnmatrix, string, vector;
    if stringlist=["==UNDEF=="]
       then
        Error("polymake declares this object undefined");
        return fail;
    fi;
    returnmatrix:=[];
    for string in stringlist
      do
        vector:=SplitString(string," ");
        Apply(vector,ConvertPolymakeNumber);
        Add(returnmatrix,vector);
    od;
    return returnmatrix;
end);


InstallMethod(ConvertPolymakeMatrixToGAPKillOnes,[IsDenseList],
        function(stringlist)
    local   returnmatrix;
    returnmatrix:=ConvertPolymakeMatrixToGAP(stringlist);
    if returnmatrix<>fail
       then
        return List(returnmatrix,i->i{[2..Size(i)]});    #kill leading ones
    else
        return fail;
    fi;
end);


InstallMethod(ConvertPolymakeVectorToGAP,[IsDenseList],
        function(stringlist)
    local   vector;
    if Size(stringlist)<>1
       then
        Error("list ist too long to be converted to a vector");
        return fail;
    else
        vector:=SplitString(stringlist[1]," ");
        Apply(vector,ConvertPolymakeNumber);
        return vector;
    fi;
end);
    

InstallMethod(ConvertPolymakeVectorToGAPKillOne,[IsDenseList],
        function(stringlist)
    local   vector;
    vector:=ConvertPolymakeVectorToGAP(stringlist);
    return vector{[2..Size(vector)]};
end);


InstallMethod(ConvertPolymakeBoolToGAP,[IsDenseList],
        function(stringlist)
    if Size(stringlist)<>1
       then
        Error("list ist too long to be converted to a boolean");
        return fail;
    elif stringlist[1]="1"
      then 
        return true;
    elif stringlist[1]="0"
      then
        return false;
    else
        Error("Conversion failed");
    fi;
end);


InstallMethod(ConvertPolymakeSetToGAP,[IsDenseList],
        function(stringlist)
    local   entries;
    if not Size(stringlist)=1 and IsString(stringlist[1])
       then
        Error("malformed string");
        return fail;
    else
        entries:=ReplacedString(ReplacedString(stringlist[1],"{",""),"}","");
        entries:=Set(SplitString(entries," "));
        RemoveSet(entries,"");
        return Set(entries,ConvertPolymakeNumber);
    fi;
end);


InstallMethod(ConvertPolymakeSetOfSetsToGAP,[IsDenseList],
        function(stringlist)    
    local   returnlist,  line,  newlist,  entry;
        
    returnlist:=[];
    if Size(stringlist)<> 1 or not IsString(stringlist[1])
       then
        Error("<stringlist> must have exactly one entry");
    fi;
    line:=stringlist[1];
    newlist:=ReplacedString(line{[2..Size(line)-1]},"} {","},{");
    newlist:=SplitString(newlist,",");
    for entry in newlist
      do
        Add(returnlist,ConvertPolymakeSetToGAP([entry]));
    od;
    return returnlist;
end);


        
InstallMethod(ConvertPolymakeGraphToGAP,[IsDenseList],
        function(stringlist)
    local   edgelist,  edge,  vertices;
    edgelist:=[];
    for edge in stringlist
      do
#        verts:=ReplacedString(ReplacedString(edge,"{",""),"}","");
#        verts:=SplitString(verts," ");
        Add(edgelist,ConvertPolymakeSetToGAP(edge));
    od;
    vertices:=Set(Flat(edgelist));
    return rec(vertices:=vertices,edges:=Set(edgelist));
end);
    



InstallMethod(ConvertPolymakeHasseDiagramToGAP,[IsDenseList],
       function(stringlist)
    local   startnumbers,  rest,  nodes,  node,  stringpair,  
            faceblocks,  facenumber,  permlist,  pi,  maxnode,  i,  
            upface,  blockindex,  downshift,  upshift,  face,  
            returnrec,  modgens,  elts;
    
    ###
    # convert the first line to a list of integers
    # and remove the leading "<" from the rest.
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
                AddSet(nodes[upface][3],i);
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



InstallMethod(ConvertPolymakeFaceLatticeToGAP,[IsDenseList],
        function(stringlist)
    local   returnlist,  line,  faces;
    returnlist:=[];
    for line in stringlist
      do 
        if line<>"" and line[1]='{'
           then
            faces:=Set(ConvertPolymakeSetOfSetsToGAP([line]));
            Apply(faces,i->i+1);
            Add(returnlist,faces);
        fi;
    od;
    return returnlist;
end);


InstallMethod(ConvertPolymakeListOfSetsToGAP,[IsDenseList],
        function(stringlist)
    return List(stringlist,s->ConvertPolymakeSetToGAP([s]));
end);


InstallMethod(ConvertPolymakeListOfSetsToGAPPlusOne,[IsDenseList],
        function(stringlist)
    return List(stringlist,s->ConvertPolymakeSetToGAP([s])+1);
end);

#############################################################################
##
#E  END of file convert.gi
##