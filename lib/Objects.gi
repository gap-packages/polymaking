#############################################################################
##
#W Objects.gi            polymaking Package      Marc Roeder
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
PolymakeObjectFamily:=NewFamily("PolymakeObjectFamily",IsPolymakeObject);
PolymakeObject:=NewType(PolymakeObjectFamily,IsPolymakeObjectRep);


######################################################################
# The following methods are the only ones which manipulate the contents
# of a PolymakeObject. 
# There are no other functions containing things like <poly!.knownProperties>
#

######################################################################
# Printing Polymake Objects nicely:
#
InstallMethod(ViewObj,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
    local compnames;
    compnames:=NamesOfComponents(poly);
    if "knownProperties" in compnames 
      and "DESCRIPTION" in NamesKnownPropertiesOfPolymakeObject(poly)
      then
        Print("<",PropertyOfPolymakeObject(poly,"DESCRIPTION"));
    else
        Print("<polymake object");
    fi;
    if not "knownProperties" in compnames
       then
        Print(". No properties known");
    fi;
    Print(">");
end);

InstallMethod(PrintObj,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
    local compnames;
    compnames:=NamesOfComponents(poly);
    if "knownProperties" in compnames 
      and "DESCRIPTION" in NamesKnownPropertiesOfPolymakeObject(poly)
      then
        Print("<",PropertyOfPolymakeObject(poly,"DESCRIPTION"));
    else
        Print("<polymake object");
    fi;
    if not "knownProperties" in compnames
       then
        Print(". No properties known");
    else
        Print(". Properties known: ",NamesKnownPropertiesOfPolymakeObject(poly));
    fi;
    Print(">\n");
end);


######################################################################
#
# Extracting data from objects:
#


# the DIRECTORY:
InstallMethod(DirectoryOfPolymakeObject,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
        return poly!.dir;
end);

# the FILENAME:
InstallMethod(FilenameOfPolymakeObject,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
    return poly!.filename;
end);

#the FILENAME with full path:
InstallMethod(FullFilenameOfPolymakeObject,
        [IsPolymakeObject],
        function(poly)
    return Filename(DirectoryOfPolymakeObject(poly),FilenameOfPolymakeObject(poly));
end);

# the KNOWN PROPERTIES:
InstallMethod(KnownPropertiesOfPolymakeObject,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
    if not "knownProperties" in NamesOfComponents(poly)
       then
        return fail;
    elif Size(RecNames(poly!.knownProperties))=0
      then
        return fail;
    else
        return poly!.knownProperties;
    fi;
end);

# just the names of the KNOWN PROPERTIES:
InstallMethod(NamesKnownPropertiesOfPolymakeObject,
        "for PolymakeObject",
        [IsPolymakeObject],
        function(poly)
    if not "knownProperties" in NamesOfComponents(poly)
       then
        return fail;
    elif Size(RecNames(poly!.knownProperties))=0
      then 
        return fail;
    else             
        return RecNames(poly!.knownProperties);
    fi;
end);

# individual properties from KNOWN PROPERTIES:
InstallMethod(PropertyOfPolymakeObject,
        [IsPolymakeObject,IsString],
        function(poly,name)
    local known;
    known:=NamesKnownPropertiesOfPolymakeObject(poly);
    if known=fail or not name in known
       then 
        return fail;
    else
        return poly!.knownProperties.(name);
    fi;
end);



######################################################################
# Changing the things we know about a object:
#


# Deleting files and clearing known data
#
InstallMethod(ClearPolymakeObject,
        [IsPolymakeObject],
        function(poly)
    CreateEmptyFile(FullFilenameOfPolymakeObject(poly));
    Unbind(poly!.knownProperties);
end);

# clear known data. Clear file and then set application, version,type 
# information
InstallMethod(ClearPolymakeObject,
        [IsPolymakeObject,IsDenseList],
        function(poly,appvertyp)
    local   appendstring;
    if not CheckAppVerTypList(appvertyp)
       then
        Error("application, version, type not well-formed");
    fi;
    CreateEmptyFile(FullFilenameOfPolymakeObject(poly));
    Unbind(poly!.knownProperties);
    appendstring:=Concatenation(["_application ",appvertyp[1],"\n",
                          "_version ",appvertyp[2],"\n",
                          "_type ",appvertyp[3],"\n"]
                          );
    AppendToPolymakeObject(poly,appendstring);
end);

# Deleting a something known:
#
InstallMethod(UnbindKnownPropertyOfPolymakeObject,
        [IsPolymakeObject,IsString],
        function(poly,name)
    local knownProperties;
    knownProperties:=KnownPropertiesOfPolymakeObject(poly);
    if knownProperties=fail or not name in knownProperties
       then
        return fail;
    else
        Unbind(poly!.knownProperties.(name));
    fi;
end);


# Write a property:
#
InstallMethod(WriteKnownPropertyToPolymakeObject,
        [IsPolymakeObject,IsString,IsObject],
        function(poly,name,data)
    if not "knownProperties" in NamesOfComponents(poly)
       then
        poly!.knownProperties:=rec();
    fi;
    poly!.knownProperties.(name):=data;
end);
    