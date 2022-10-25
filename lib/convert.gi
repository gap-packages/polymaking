#############################################################################
##
#W convert.gi            polymaking Package      Marc Roeder
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
InstallMethod(ConvertPolymakeOutputToGapNotation,[IsString],
        function(string)
    local   split,  blockpositions,  splitblocks,  returnlist,  
            splitblock,  name,  rest,  object;
    
    
    splitblocks:=SplitPolymakeOutputStringIntoBlocks(string);
    returnlist:=[];
    for splitblock in splitblocks
      do
        name:=NormalizedWhitespace(splitblock[1]);
        if Size(splitblock) < 2
           then
            Info(InfoPolymaking,2,"No data for ", name,". Record not updated for this block");
            UpdatePolymakeFailReason(Concatenation("polymake returned ",name," empty"));
            Add(returnlist, rec(name:=name,object:=fail));
            continue;
        fi;
        rest:=splitblock{[2..Maximum(Size(splitblock),2)]};
        if rest[Size(rest)]=""
           then
            Unbind(rest[Size(rest)]);
        fi;
#        Apply(rest,NormalizedWhitespace);
        
        if rest=["==UNDEF=="]
           then
            Info(InfoPolymaking,1,Concatenation("polymake declares object ",name," undefined"));
            UpdatePolymakeFailReason(Concatenation("polymake declares ",name," undefined"));
            Add(returnlist,rec(name:=name,object:=fail));
        elif IsBound(ObjectConverters.(name))
           then
            object:=ObjectConverters.(name)(rest);
            if object<>fail 
               then
                Add(returnlist,rec(name:=name,object:=object));
            else
                Info(InfoPolymaking,1,"Conversion failed. Maybe invalid output from polymake. Record not updated for this block");
                Add(returnlist, rec(name:=name,object:=fail));
            fi; 
        else
            Info(InfoPolymaking,1,"No Method to convert ", name,". Record not updated for this block");
            UpdatePolymakeFailReason(Concatenation("polymaking doesn't know how to convert ",name," to GAP"));
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
               and ForAll(line,c->IsUpperAlphaChar(c) or c in ['_','-','>'] or IsDigitChar(c))
               then
                if blocks=[] and newblock=[]
                   then
                    newblock:=[MapKeyWordFromPolymakeFormat(line)];
                else
                    Add(blocks,ShallowCopy(newblock));
                    newblock:=[MapKeyWordFromPolymakeFormat(line)];
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


#############################################################################
##
## update the fail reason in case of syntax errors:
##
InstallMethod(ConverterSyntaxError,[IsString],
        function(methname)
    UpdatePolymakeFailReason(
            Concatenation("input for converter method ",methname, " syntactically incorrect (cast an error and went into break loop)")
            );
    Error("incorrect input");
end);


#############################################################################
# Now the different conversion methods:
#############################################################################
##
## Basics, numbers and bools:
##
InstallMethod(ConvertPolymakeNumber,[IsString],
        function(string)
    local   sstring,  denom,  enum;
    if '.' in string
       then
        Info(InfoPolymaking,1,"Warning!converting a floating point number"); 
        sstring:=SplitString(string,".");
        denom:=10^(Length(sstring[2]));
        enum:=Int(Concatenation(sstring));
        return enum/denom;
    elif string=""
      then
        ConverterSyntaxError("ConvertPolymakeNumber");
        return fail;
    else
        return Rat(string);
    fi;
end);


InstallMethod(ConvertPolymakeScalarToGAP,[IsDenseList],
        function(stringlist)
    if Size(stringlist)<>1
       then
        ConverterSyntaxError("ConvertPolymakeScalarToGAP");
        return fail;    
    else
        return ConvertPolymakeNumber(stringlist[1]);
    fi;
end);


InstallMethod(ConvertPolymakeBoolToGAP,[IsDenseList],
        function(stringlist)
    if Size(stringlist)<>1
       then
        ConverterSyntaxError("ConvertPolymakeBoolToGAP");
        return fail;
    elif stringlist[1]="1" or stringlist[1]="true"
      then 
        return true;
    elif stringlist[1]="0" or stringlist[1]="false"
      then
        return false;
    else
        UpdatePolymakeFailReason("Boolean conversion failed, the returned value wasn't 0, 1, true, or false. Error cast");
        Error("Conversion failed");
    fi;
end);

InstallMethod(ConvertPolymakeDescriptionToGAP,[IsDenseList],
        function(stringlist)
    return JoinStringsWithSeparator(stringlist," ");
end);

#############################################################################
##
## MATRICES AND LISTS OF SETS:
##
## Unfortunately some of the keywords that return matrices
## might also return lists of sets (this is a polytope/topaz problem).
## So we try to guess the type if necessary.
##
InstallMethod(ConvertPolymakeMatrixOrListOfSetsToGAP,[IsDenseList],
        function(stringlist)
    
    if ForAll(stringlist,i->i[1]='{')
      then
        return ConvertPolymakeListOfSetsToGAP(stringlist);     
    elif ForAll(stringlist,i->not ('{' in i or '}' in i))
      then
            return ConvertPolymakeMatrixToGAP(stringlist);
    else
        UpdatePolymakeFailReason("ConvertPolymakeMatrixOrListOfSetsToGAP couldn't decide what to do. Error cast");
        Error("don't know if this is a matrix or a list of sets ");
        return fail;
    fi;
end);


InstallMethod(ConvertPolymakeMatrixOrListOfSetsToGAPPlusOne,[IsDenseList],
        function(stringlist)
    
    if ForAll(stringlist,i->i[1]='{')
      then
        return ConvertPolymakeListOfSetsToGAPPlusOne(stringlist);     
    elif ForAll(stringlist,i->not ('{' in i or '}' in i))
      then
            return ConvertPolymakeMatrixToGAP(stringlist);
    else
        UpdatePolymakeFailReason("ConvertPolymakeMatrixOrListOfSetsToGAP couldn't decide what to do. Error cast");
        Error("don't know if this is a matrix or a list of sets ");
        return fail;
    fi;
end);

                
InstallMethod(ConvertPolymakeMatrixToGAP,[IsDenseList],
        function(stringlist)
    local returnmatrix, string, vector;
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
    if not IsMatrix(returnmatrix) 
       or Size(returnmatrix[1])<2
       or not ForAll(returnmatrix,i->i[1]=1)
       then
        Error("returnmatrix is not a matrix or too small");
        UpdatePolymakeFailReason("Error in ConvertPolymakeMatrixToGAPKillOnes. The returned object is either not a matrix, has fewer than 2 columns or doesn't have all ones in the first column. (Error cast)");
        return fail;
    fi;
    if returnmatrix<>fail
       then
        return List(returnmatrix,i->i{[2..Size(i)]});    #kill leading ones
    else
        return fail;
    fi;
end);

#############################################################################
##
## Vectors
##
InstallMethod(ConvertPolymakeVectorToGAP,[IsDenseList],
        function(stringlist)
    local   vector;
    if Size(stringlist)<>1
       then
        ConverterSyntaxError("ConvertPolymakeVectorToGAP");
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
    if not IsVector(vector) or Size(vector)<2
       or vector[1]<>1
       then
        Error("vector is not a vector or too small");
        UpdatePolymakeFailReason("Error in ConvertPolymakeVectorToGAPKillOne. The returned object is either not a vector or has fewer than 2 columns or doesn't start with 1. (Error cast)");
        return fail;
    fi;
    return vector{[2..Size(vector)]};
end);


InstallMethod(ConvertPolymakeIntVectorToGAPPlusOne,[IsDenseList],
        function(stringlist)
    local   vec;
    
    vec:=ConvertPolymakeVectorToGAP(stringlist);
    if not ForAll(vec,IsInt)
       then
        Error("Vector is not a vector of integers as expected");
        UpdatePolymakeFailReason("Error in ConvertPolymakeIntVectorToGAPPlusOne. The returned vector did not consist of integers. Error cast");
        return fail;
    else
        return vec+1;
    fi;
end);
        



#############################################################################
##
## Sets, Sets of Sets, Lists of Sets
##
InstallMethod(ConvertPolymakeSetToGAP,[IsDenseList],
        function(stringlist)
    local   entries;
    if not Size(stringlist)=1 and IsString(stringlist[1])
       then
        ConverterSyntaxError("ConvertPolymakeSetToGAP");
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
        ConverterSyntaxError("ConvertPolymakeSetOfSetsToGAP");
        return fail;
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
## More complex stuff:
##

#############################################################################
##
## Graphs:
##
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
    


#############################################################################
##
## Face Lattices:
##
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



#############################################################################
##
#E  END of file convert.gi
##
