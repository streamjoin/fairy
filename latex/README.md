# Compiling LaTeX Project #

Here is a minimum example: 

    #!/bin/sh
    
    # Name of the main .tex file
    export TEX_NAME="main"
    
    # Name of the .bib file
    export SRC_BIB_NAME="references"
    
    # Path of the fairy project
    export FAIRY_HOME="/path/to/fairy"
    
    # Run build_latex.sh with the above settings
    source "${FAIRY_HOME}/latex/build_latex.sh"

Save the above snippet as `build.sh` and put it in your LaTeX project, where the main TeX file `main.tex` and the bibliography file `references.bib` are both placed in the same level of directory. 
