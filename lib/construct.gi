#############################################################################
##
#W construct.gi 			 polymaking Package		 Marc Roeder
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
Revision.("/home/roeder/gap/polymaking/polymaking/lib/construct_gi"):=
	"@(#)$Id$";
# just create an empty file:
InstallMethod(CreateEmptyFile,[IsString],
        function(name)
    PrintTo(name,"");
end);

# create a (possibly empty) polygon. 
# That is, a record just containing the name of a file to use with polymake.
# If the file does not exist, it is created.
####################
InstallMethod(CreatePolymakeObjectFromFile,[IsString],
        function(name)
    local filename;
    filename:=Filename(POLYMAKE_DATA_DIR,name);
    if not IsExistingFile(filename)
       then
        CreateEmptyFile(filename);
    fi;
    return Objectify(PolymakeObject,rec(filename:=name, dir:=POLYMAKE_DATA_DIR));
end);

InstallMethod(CreatePolymakeObjectFromFile,[IsDirectory,IsString],
        function(dir,name)
    local   filename,  polygon;
    filename:=Filename(dir,name);
    if not IsExistingFile(filename)
       then
        CreateEmptyFile(filename);
    fi;
    return Objectify(PolymakeObject,rec(filename:=name,dir:=dir));
end);

InstallMethod(CreatePolymakeObject,[IsString,IsDirectory],
        function(prefix,dir)
    local   name,  i,  newname;
    name:=Concatenation(prefix,String(Runtime()));
    if IsExistingFile(Filename(dir,name))
       then
        i:=1;
        repeat
            newname:=Concatenation([name,".",String(i)]);
            i:=i+1;
        until not IsExistingFile(Filename(dir,newname));
    else
        newname:=name;
    fi;
    return CreatePolymakeObjectFromFile(dir,newname);
end);


InstallMethod(CreatePolymakeObject,[IsDirectory],
        function(dir)
    local   name,  i,  newname;
    return CreatePolymakeObject("poly",dir);
end);


InstallMethod(CreatePolymakeObject,[],
        function()
    local   dir,  name;
    return CreatePolymakeObject(POLYMAKE_DATA_DIR);
end);


InstallMethod(AppendToPolymakeObject,[IsPolymakeObject,IsString,IsString],
        function(poly,keyword,data)
    local   string;
    string:=ShallowCopy(keyword);
    while string[Size(string)] in ['\n','\r','\c']
      do
        Unbind(string[Size(string)]);
    od;
    string:=Concatenation(keyword,"\n",data);
    while string[Size(string)] in ['\n','\r','\c']
      do
        Unbind(string[Size(string)]);
    od;
    Add(string,'\n');
    AppendToPolymakeObject(poly,string);
end);


InstallMethod(AppendToPolymakeObject,[IsPolymakeObject,IsString],
        function(poly,string)
    local   file,  retval;
    
    #file:=IO_File(record.filename,"w");
    #retval:=IO_WriteFlush(file,string);
    file:=OutputTextFile(FullFilenameOfPolymakeObject(poly),true);
    #SetPrintFormattingStatus(file,false);
    retval:=WriteAll(file,string);
    if not retval
       then
        Error("Error writing file");
    fi;
    CloseStream(file);
end);


InstallMethod(ConvertMatrixToPolymakeString,[IsString,IsDenseList],
        function(name,matrix)
    local   dim,  string,  point,  stringpoint;
    dim:=Size(matrix[1]);
    if not ForAll(matrix,point->Size(point)=dim)
       then
        Error("not all rows have the same dimension");
    elif not ForAll(Concatenation(matrix),IsRat)
      then
        Error("matrix contains non-rational entries.");
    fi;
    string:=ShallowCopy(name);
    Append(string,"\n");
    for point in matrix
      do
        stringpoint:=JoinStringsWithSeparator(List(point,String)," ");
        Append(string,stringpoint);
        Append(string,"\n");
    od;
    Append(string,"\n");
    return string;    
end);

# Now a few functions for convenience:

InstallMethod(AppendPointlistToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,pointlist)
    local   list,  point,string;
    list:=[];
    for point in pointlist
      do
        Add(list,Concatenation([1],point));
    od;
    string:=ConvertMatrixToPolymakeString("POINTS",list);
    AppendToPolymakeObject(polygon,string);
end);


InstallMethod(AppendVertexlistToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,pointlist)
    local   list,  point,string;
    list:=[];
    for point in pointlist
      do
        Add(list,Concatenation([1],point));
    od;
    string:= ConvertMatrixToPolymakeString("VERTICES",list);
    AppendToPolymakeObject(polygon,string);
end);


InstallMethod(AppendInequalitiesToPolymakeObject,[IsPolymakeObject,IsDenseList],
        function(polygon,ineqlist)
    
    AppendToPolymakeObject(polygon,ConvertMatrixToPolymakeString("INEQUALITIES",ineqlist));
end);



##############################
# Call polymake. If the option "PolymakeNolookup" is true, 
# it is not checked, wheather Polymake has already been called
# with this option (however, the polymake program will check 
# this by looking at the file associated to <polygon>).
#

InstallMethod(Polymake,"for PolymakeObject",[IsPolymakeObject,IsString],
        function(polygon,option)
    local   exitstatus,  gapobject,  splitoption,  returnval,  
            knownProperties,  returnedstring,  stdout,  stdin,  dir,  
            block;


    exitstatus:=0;
    gapobject:=[];
    option:=NormalizedWhitespace(option);
    splitoption:=SplitString(option," ");
    if ValueOption("PolymakeNolookup") in [fail,false]
       then
        knownProperties:=NamesKnownPropertiesOfPolymakeObject(polygon);
        if knownProperties<>fail and Size(splitoption)=1 and 
           splitoption[1] in NamesKnownPropertiesOfPolymakeObject(polygon)
           then
            returnval:=PropertyOfPolymakeObject(polygon,splitoption[1]);
        elif Size(splitoption)=1
          then
            returnval:=[];
        elif splitoption=[]
          then
            Error("you must pass an option to polymake");
        else
            returnval:=fail;
        fi;
        if knownProperties<> fail 
           then
            splitoption:=Filtered(splitoption,i->not i in knownProperties);
        fi;
    else
        returnval:=[];
    fi;
    
    if not splitoption=[]
       then
        returnedstring:=[];
        stdout:=OutputTextString(returnedstring,false);
        stdin:=InputTextNone();;
        dir:=DirectoryOfPolymakeObject(polygon);
        if dir=fail 
           then
            dir:=DirectoryCurrent();
        fi;
        exitstatus:=Process( dir, POLYMAKE_COMMAND, stdin, stdout, 
                            Concatenation([FullFilenameOfPolymakeObject(polygon)],
                                    splitoption)
                            );;
        CloseStream(stdout);
        CloseStream(stdin);
    else
        returnedstring:=[];
    fi;
    #returnedstring:=IO_PipeThrough(POLYMAKE_COMMAND,[polygon.filename,option],"");
    if exitstatus<>0 
       then
        Info(InfoPolymaking,1,"polymake returned an error");
        gapobject:=[];
    elif returnedstring<>[]
      then
        Info(InfoPolymaking,2,returnedstring);
        gapobject:=ConvertPolymakeOutputToGapNotation(returnedstring);
    fi;
    if Size(gapobject)=1 and gapobject[1].object<>fail 
       then
        WriteKnownPropertyToPolymakeObject(polygon,gapobject[1].name,gapobject[1].object);
#        polygon.(gapobject[1].name):=gapobject[1].object;
        if returnval<> fail
           then
            returnval:=gapobject[1].object;
        fi;
    elif Size(gapobject)>1
      then
        for block in Filtered(gapobject,i->i.object<>fail)
          do
            WriteKnownPropertyToPolymakeObject(polygon,block.name,block.object);
#            polygon.(block.name):=block.object;
        od;
        returnval:=fail;
    elif returnval = []
      then
        Info(InfoPolymaking,1,"There was no or wrong polymake output");
        returnval:= fail;
    fi;
    return returnval;    
end);


        

    
