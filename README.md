Base project for Ocaml project on Ford-Fulkerson. This project contains some simple configuration files to facilitate editing Ocaml in VSCode.

To use, you should install the *OCaml* extension in VSCode. Other extensions might work as well but make sure there is only one installed.
Then open VSCode in the root directory of this repository.

Features :
 - full compilation as VSCode build task (Ctrl+Shift+b)
 - highlights of compilation errors as you type
 - code completion
 - automatic indentation on file save

A makefile also provides basic automation :
 - `make` to compile. This creates an ftest.byte executable
 - `make format` to indent the entire project

#Ford Fulkerson Algorithm :
Usage : 
 - create a file with your nodes and edges formatting like this : 
n <coord-x> <coord-y>
e <id-source> <id-destination> <label>
 - use the following command to compile source files : make
 - use the following command to see the graph result : sh ffa.sh <your file>

#Money flow project :
Usage :
 - create a file with a name and an amount paid (one per line), ex :
Pierre 20
Alice 10
Quentin 10
 - use the following command to compile source files : make money
 - use the following command to see the graph result : sh money.sh <your file>