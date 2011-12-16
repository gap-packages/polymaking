#############################################################################
##
#W clients.gi 			 polymaking Package		 Marc Roeder
##
##  

##
#H @(#)$Id: clients.gi, v 0.7.8 2010/06/03 21:29:50 gap Exp $
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
Revision.("/Users/roeder/gap/polymaking/polymaking/lib/clients_gi"):=
	"@(#)$Id: clients.gi, v 0.7.8 2010/06/03   21:29:50  gap Exp $";
#############################################################################
##
## PolymakeClient(client [,outfile] [,infiles] [,options])
##
##  three optional arguments. That's 8 methods plus a non-checking one.
##


#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString],
        function(clientname)
    return PolymakeClient(clientname,[],"");
end);

#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsPolymakeObject],
        function(clientname,outobject)
    return PolymakeClient(clientname,outobject,[],"");
end);

#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsDenseList],
        function(clientname,objectlist)
    return PolymakeClient(clientname,objectlist,"");    
end);

#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsPolymakeObject,IsDenseList],
        function(clientname,outputobject,objectlist)
    return PolymakeClient(clientname,outputobject,objectlist,"");    
end);


#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsString],
        function(clientname,options)
    return PolymakeClient(clientname,[],options);
end);


#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsPolymakeObject,IsString],
        function(clientname,outobject,options)
    return PolymakeClient(clientname,outobject,[],options);
end);


#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsDenseList,IsString],
        function(clientname,objectlist,options)
    local   clientfile,  outputobject;
    
    clientfile:=Filename(POLYMAKE_CLIENT_PATHS,clientname);
    if clientfile=fail
       then
        Error("client not found in path list. You may want to set POLYMAKE_CLIENT_PATHS");
    elif not IsExecutableFile(clientfile)
      then
        Error("client file is not executable");
    fi;
    if not ForAll(objectlist,IsPolymakeObject)
       then
        Error("object list must contain PolymakeObjects");
    fi;
    outputobject:=CreatePolymakeObject();
    return PolymakeClientNC(clientname,outputobject,objectlist,options);
end);



#############################################################################
##
##
InstallMethod(PolymakeClient,[IsString,IsPolymakeObject,IsDenseList,IsString],
        function(clientname,outputobject,objectlist,options)
    local   clientfile;
    
    clientfile:=Filename(POLYMAKE_CLIENT_PATHS,clientname);
    if clientfile=fail
       then
        Error("client not found in path list. You may want to set POLYMAKE_CLIENT_PATHS");
    elif not IsExecutableFile(clientfile)
      then
        Error("client file is not executable");
    fi;
    if not ForAll(objectlist,IsPolymakeObject)
       then
        Error("object list must contain PolymakeObjects");
    fi;
    return PolymakeClientNC(clientname,outputobject,objectlist,options);
end);


#############################################################################
##
##
InstallMethod(PolymakeClientNC,[IsString,IsPolymakeObject,IsDenseList,IsString],
        function(clientname,outputobject,objectlist,options)
    local   clientfile,  returnedstring,  stdout,  stdin,  infiles,  
            optionlist,  exitstatus;
    
    clientfile:=Filename(POLYMAKE_CLIENT_PATHS,clientname);
    
    returnedstring:=[];
    stdout:=OutputTextString(returnedstring,false);;
    stdin:=InputTextNone();;
#    infiles:=JoinStringsWithSeparator(
#            List(objectlist,o->FullFilenameOfPolymakeObject(o)),
#            " "
    #            );
    infiles:=List(objectlist,o->FullFilenameOfPolymakeObject(o));
    optionlist:=Concatenation([FullFilenameOfPolymakeObject(outputobject)],
                        infiles);
    if options<>""
       then
        Append(optionlist,SplitString(options," "));
    fi;

    
    exitstatus:=Process(DirectoryOfPolymakeObject(outputobject), 
                        clientfile, 
                        stdin, stdout,
                        optionlist
                        );                        
    CloseStream(stdout);
    CloseStream(stdin);
    if exitstatus<>0
       then
        Error("client termintated with exit status ",exitstatus," ");
    fi;
    if returnedstring<>""
       then
        Info(InfoPolymaking,1,
             "Unexpected behaviour! client returned a string: ", returnedstring
             );
    fi;
    return outputobject;
end);
