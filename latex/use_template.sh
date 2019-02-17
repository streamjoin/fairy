#!/usr/bin/env bash
#
# Compile LaTeX project.

set -o pipefail

# Name of the main .tex file
export TEX_NAME="main"

# Name of the output .pdf file
export PDF_NAME="The-Little-Fairy"

# Name of the .bib file used as the input to trimbib
export SRC_BIB_NAME="references"

# Name of the .bib file used as the parameter to \bibliography{}
export TGT_BIB_NAME="${SRC_BIB_NAME}-trim"

# Path of the Fairy project cloned from https://github.com/streamjoin/fairy
export FAIRY_HOME="/path/to/fairy"

# Command for compiling .tex
# Options: latex, pdflatex, xelatex
export CMD_LATEX="latex"

# Command for compiling .bib
# Options: bibtex, biber, <none>
export CMD_BIBTEX="bibtex"

# Path of the trimbib project cloned from https://github.com/streamjoin/trimbib
export TRIMBIB_HOME="/path/to/trimbib"

# Configuration of trimbib
export TRIMBIB_ARGS="--pages --booktitle --max-authors 6"

# Log file of trimbib
export TRIMBIB_LOG="trimbib_log.txt"

# Folders
export WORK_DIR="$(cd "$(dirname -- "$0")"; pwd -P)"
export BUILD_DIR="${WORK_DIR}/pdfbuild"

# Run build_latex.sh with the above settings
source "${FAIRY_HOME}/latex/build_latex.sh"
