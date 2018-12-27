# Compiling LaTeX Project #

## Configuration ##

To use `build_latex.sh` to compile LaTeX project, the following environment variables are compulsory to configure in the driver script. 

- `TEX_NAME`: Name of the main .tex file for compilation. 
- `TGT_BIB_NAME`: Name of the .bib file used as the parameter to `\bibliography{}` stated in the the .tex file. 
- `FAIRY_HOME`: Path of the root of the fairy project. This must be set in order to properly resolved dependencies required in `build_latex.sh`. 

Moreover, the following line must be placed at the end of the driver script. 

    source "${FAIRY_HOME}/latex/build_latex.sh"

Here is a minimum example: 

    #!/bin/sh
    
    # Name of the main .tex file
    export TEX_NAME="main"
    
    # Name of the .bib file used as the parameter to \bibliography{}
    export TGT_BIB_NAME="references"
    
    # Path of the fairy project
    export FAIRY_HOME="/path/to/fairy"
    
    # Run build_latex.sh with the above settings
    source "${FAIRY_HOME}/latex/build_latex.sh"

Save the above snippet as `build.sh` and put it in your LaTeX project, where the main TeX file `main.tex` and the bibliography file `references.bib` are both placed in the same level of directory. 

## Customization ##

The following environment variables can be optionally configured for purposed customization. 

- `PDF_NAME`: Name of the output .pdf file.
- `SRC_BIB_NAME`: 
- `CMD_LATEX`:
- `CMD_BIBTEX`:
- `TRIMBIB_HOME`:
- `TRIMBIB_ARGS`:
- `TRIMBIB_LOG`:
- `WORK_DIR`:
- `BUILD_DIR`:
