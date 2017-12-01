#!/usr/bin/env python2
import sys
import os

imported=[]
def importer( fname ):
    "This reads solidity source and substitutes instead of imports their bodies"
    global imported
    with open(fname,"r") as f: #opens file with name of "test.txt"
        for line_long in f:
            line=line_long.rstrip().lstrip()
#            if ( not line.startswith("pragma ") ):
            if ( line.startswith("import ") ):
                fname = line.replace('"', '\'').split("'")[1].lstrip("../").lstrip("./")
                print("// Importing file "+fname)
                found=0
                for p in ["","node_modules/","node_modules/zeppelin-solidity/contracts/token/","node_modules/zeppelin-solidity/contracts/"]:
                    if ( os.path.isfile(p+fname) ):
                        found=1
                        if ( not p+fname in imported ):
                            importer(p+fname)
                            imported.append(p+fname)
                if ( found == 0 ):
                    print("// file not found "+fname)
            else:
                print(line_long.rstrip())
        return

importer(sys.argv[1])

print("// imported "+str(imported))
