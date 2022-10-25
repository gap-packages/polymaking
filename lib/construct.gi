#############################################################################
##
#W construct.gi 			 polymaking Package		 Marc Roeder
##
##  

##
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
# just create an empty file:
InstallMethod(CreateEmptyFile,[IsString],
        function(name)
    PrintTo(name,"");
end);

InstallMethod(InitPolymakeObject,[IsPolymakeObject],
        function(poly)
    local appstring;
    # In polymake 4.1 this is required.
    appstring:=Concatenation(
                        "_application polytope\n",
                        "_type Polytope\n\n"
                  );
    AppendToPolymakeObject(poly, appstring);
    return poly;
end);

# create a (possibly empty) polygon. 
# That is, a record just containing the name of a file to use with polymake.
# If the file does not exist, it is created.
####################
InstallMethod(CreatePolymakeObjectFromFile,[IsString],
        function(name)
    return CreatePolymakeObjectFromFile(POLYMAKE_DATA_DIR, name);
end);

InstallMethod(CreatePolymakeObjectFromFile,[IsDirectory,IsString],
        function(dir,name)
    local   filename,  rtn, polygon;
    rtn:=Objectify(PolymakeObject,rec(filename:=name,dir:=dir));
    filename:=Filename(dir,name);
    if not IsExistingFile(filename)
       then
        CreateEmptyFile(filename);
        InitPolymakeObject(rtn);
    fi;
    return rtn;
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



InstallMethod(CreatePolymakeObject,[IsString,IsDirectory,IsDenseList],
        function(prefix,dir,appvertyp)
    local   poly;
    poly:=CreatePolymakeObject(prefix,dir);
    ClearPolymakeObject(poly,appvertyp);
    return poly;
end);
       
        
        
InstallMethod(CreatePolymakeObject,[IsDirectory],
        function(dir)
    local   name,  i,  newname;
    return CreatePolymakeObject("poly",dir);
end);



InstallMethod(CreatePolymakeObject,[IsDirectory,IsDenseList],
        function(dir,appvertyp)
    local   poly;
    poly:=CreatePolymakeObject(dir);
    ClearPolymakeObject(poly,appvertyp);
    return poly;
end);



InstallMethod(CreatePolymakeObject,[],
        function()
    local   dir,  name;
    return CreatePolymakeObject(POLYMAKE_DATA_DIR);
end);


InstallMethod(CreatePolymakeObject,[IsDenseList],
        function(appvertyp)
    local poly;
    poly:=CreatePolymakeObject();
    ClearPolymakeObject(poly,appvertyp);
    return poly;
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
# it is not checked, whether Polymake has already been called
# with this option (however, the polymake program will check 
# this by looking at the file associated to <polygon>).
#

InstallMethod(Polymake,"for PolymakeObject",[IsPolymakeObject,IsString],
        function(polygon,option)
    local   callPolymake,  gapobject,  splitoption,  knownProperties,  
            returnval,  returnedstring,  block;
    
    callPolymake:=function(object,splitoption)
        local   returnedstring,  pkgdir, scriptarg, stdout,  stdin,  dir,  exitstatus;
        
        returnedstring:=[];
        scriptarg:=["--config-path","", "--script",
                    Filename(DirectoriesPackageLibrary("polymaking"), "pm_script_arg.pl")];
        stdout:=OutputTextString(returnedstring,false);
        stdin:=InputTextNone();;
        dir:=DirectoryOfPolymakeObject(object);
        if dir=fail 
           then
            dir:=DirectoryCurrent();
        fi;
        exitstatus:=Process( dir, POLYMAKE_COMMAND, stdin, stdout, 
                            Concatenation(scriptarg, [FullFilenameOfPolymakeObject(object)],
                                     splitoption)
                            );;
        CloseStream(stdout);
        CloseStream(stdin);
        return rec(status:=exitstatus,string:=returnedstring);
    end;

    gapobject:=[];
    option:=NormalizedWhitespace(option);
    splitoption:=SplitString(option," ");
    knownProperties:=NamesKnownPropertiesOfPolymakeObject(polygon);
    returnval:=[];

    Info(InfoPolymaking,2,"option=",option);
    Info(InfoPolymaking,2,"Size(splitoption)=",Size(splitoption));
    if Size(splitoption)=0
      then
        Error("you must pass an option to polymake");
        
    elif Size(splitoption)=1
      then
        if ValueOption("PolymakeNolookup") in [fail,false]
           and knownProperties<>fail
           and splitoption[1] in knownProperties
           then
            returnval:=PropertyOfPolymakeObject(polygon,splitoption[1]);
        else
            Apply(splitoption, MapKeyWordToPolymakeFormat);
            returnedstring:=callPolymake(polygon,splitoption);
            Info(InfoPolymaking,2,String(returnedstring));
            if returnedstring.status <>0
               then
                Error("polymake returned an error (error code ", returnedstring.status, ")");
                UpdatePolymakeFailReason(Concatenation("polymake terminated with exit status ",String(returnedstring.status)));
                returnval:=fail;
            elif returnedstring.string<>[]
               then
                Info(InfoPolymaking,2,returnedstring.string);
                gapobject:=ConvertPolymakeOutputToGapNotation(returnedstring.string);
                if gapobject[1].object<>fail
                   then
                    WriteKnownPropertyToPolymakeObject(polygon,gapobject[1].name,gapobject[1].object);
                    returnval:=gapobject[1].object;
                else
                    returnval:=fail;
                fi;
            else
                UpdatePolymakeFailReason("polymake did not return anything");
                returnval:=fail;
            fi;
        fi;
        
    else
        # we return fail, whatever happens.
        ## only the reason may change...
        ###
        returnval:=fail;
        UpdatePolymakeFailReason("polymake called with multiple keywords");
        if ValueOption("PolymakeNolookup") in [fail,false]
           and knownProperties<>fail
           then
            splitoption:=Filtered(splitoption,i->not i in knownProperties);
        fi;
        if Size(splitoption)>0
           then
            Apply(splitoption, MapKeyWordToPolymakeFormat);
            returnedstring:=callPolymake(polygon,splitoption);
            if returnedstring.status <>0
               then
                Error("polymake returned an error");
                UpdatePolymakeFailReason(Concatenation("polymake terminated with exit status ",String(returnedstring.status)));
            elif returnedstring<>[]
              then
                Info(InfoPolymaking,2,returnedstring.string);
                gapobject:=ConvertPolymakeOutputToGapNotation(returnedstring.string);
                
                for block in Filtered(gapobject,i->i.object<>fail)
                  do
                    WriteKnownPropertyToPolymakeObject(polygon,block.name,block.object);
                od;
            else
                UpdatePolymakeFailReason("polymake didn't return anything. All keywords that would have triggered output were looked up.");
            fi;
            
        fi;
     fi;
     return returnval;
end);


        

    
