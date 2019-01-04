#!/bin/bash
#
# Execution of compiling LaTeX project.

set -o pipefail

# Include libraries
readonly SCRIPT_HOME="$(cd "$(dirname "$0")"; pwd -P)"
source "${FAIRY_HOME:-${SCRIPT_HOME}/..}/_common_lib/output_utils.sh"
source "${FAIRY_HOME:-${SCRIPT_HOME}/..}/_common_lib/system.sh"
source "${FAIRY_HOME:-${SCRIPT_HOME}/..}/_common_lib/filesystem.sh"

# Help
if [[ "$1" = "--help" ]] || [[ "$1" = "-?" ]]; then
  info_bold_blue "USAGE"
  info "  $(basename "$0") [OPTION]"
  info_bold_blue "OPTIONS"
  info "  -c, --clean    delete all generated files and exit"
  info "  -?, --help     display this help and exit"
  exit 0
fi

readonly START_TIME="$(timer)"

# Check environment variables
[[ -n "${WORK_DIR}" ]] || WORK_DIR="$(cd "$(dirname "$0")"; pwd -P)"
check_dir_exists "${WORK_DIR}"
readonly WORK_DIR="$(cd "${WORK_DIR}"; pwd -P)"  # canonical path

[[ -n "${BUILD_DIR}" ]] || BUILD_DIR="${WORK_DIR}/pdfbuild"
mkdir -p "${BUILD_DIR}"
readonly BUILD_DIR="$(cd "${BUILD_DIR}"; pwd -P)"  # canonical path

if [[ -z "${TEX_NAME}" ]]; then
  if [[ -f "${WORK_DIR}/main.tex" ]]; then
    readonly TEX_NAME="main"
  elif [[ -f "${WORK_DIR}/ms.tex" ]]; then
    readonly TEX_NAME="ms"
  fi
fi
check_err "'TEX_NAME' undefined: name of the main .tex file"

[[ -n "${PDF_NAME}" ]] || readonly PDF_NAME="${TEX_NAME}"

[[ -n "${TRIMBIB_LOG}" ]] || readonly TRIMBIB_LOG="trimbib_log.txt"

[[ -n "${CMD_LATEX}" ]] || readonly CMD_LATEX="latex"
check_cmd_exists "${CMD_LATEX}" "compile .tex"

CMD_BIBTEX="${CMD_BIBTEX-"bibtex"}"
[[ "${CMD_BIBTEX}" = "<none>" ]] && CMD_BIBTEX=""
readonly CMD_BIBTEX

if [[ -n "${CMD_BIBTEX}" ]]; then
  [[ "$(command -v "${CMD_BIBTEX}")" ]]
  check_err "command '${CMD_BIBTEX}' not found: compile .bib"
  
  [[ -n "${TGT_BIB_NAME}" ]] ||
  readonly TGT_BIB_NAME="${SRC_BIB_NAME:+${SRC_BIB_NAME}-trim}"
  [[ "${TGT_BIB_NAME}" != "${SRC_BIB_NAME}" ]]
  check_err "target .bib cannot be the source .bib itself"
fi

# Set variables
readonly JAR_TRIMBIB="${TRIMBIB_HOME:+${TRIMBIB_HOME}/release/trimbib.jar}"

# Functions
compile_tex() {
  cd "${WORK_DIR}"
  case "${CMD_LATEX}" in
    latex|xelatex)
      ${CMD_LATEX} -output-directory="${BUILD_DIR}" \
      -aux-directory="${BUILD_DIR}" "${TEX_NAME}.tex"
    ;;
    pdflatex)
      ${CMD_LATEX} -output-directory "${BUILD_DIR}" "${TEX_NAME}.tex"
    ;;
    *)
      err "unknown latex command '${CMD_LATEX}'"
      exit 127
    ;;
  esac
  check_err "failed to compile '${TEX_NAME}.tex'"
}

compile_bib() {
  cd "${BUILD_DIR}"
  ${CMD_BIBTEX} "${TEX_NAME}.aux"
  check_err "failed to compile '\\\\bibliography{${TGT_BIB%.*}}'"
}

# Command parameters (other than '--help')
if [[ "$#" > 0 ]]; then
  case "$1" in
    --clean|-c)
      delete_file "${WORK_DIR}/${PDF_NAME}.pdf"
      delete_file "${WORK_DIR}/${PDF_NAME}.md5"
      delete_file "${WORK_DIR}/${TEX_NAME}.aux"
      
      [[ -n "${CMD_BIBTEX}" ]] && delete_file "${WORK_DIR}/${TEX_NAME}.bbl"
      
      if [[ "${BUILD_DIR}" = "${WORK_DIR}" ]]; then
        warn "the build directory is set to the working directory itself"
        warn "Path: ${BUILD_DIR}/"
      else
        delete_dir "${BUILD_DIR}"
      fi
      
      exit 0
    ;;
    *)
      err "unknown command argument(s) '$@' (see '--help' for usage)"
      exit 126
    ;;
  esac
fi
info "This is Fairy LaTeX Compilation (under the MIT License)"

# Prepare
delete_file "${WORK_DIR}/${PDF_NAME}.pdf"
delete_file "${WORK_DIR}/${PDF_NAME}.md5"
delete_file "${WORK_DIR}/${TEX_NAME}.aux"

[[ "${BUILD_DIR}" != "${WORK_DIR}" ]]
check_err "the build directory cannot be the working directory itself"
delete_dir "${BUILD_DIR}" && mkdir -p "${BUILD_DIR}"

if [[ -n "${CMD_BIBTEX}" ]]; then
  delete_file "${WORK_DIR}/${TEX_NAME}.bbl"
  
  readonly SRC_BIB="${SRC_BIB_NAME}.bib"
  
  if [[ -n "${JAR_TRIMBIB}" ]] && [[ -f "${WORK_DIR}/${SRC_BIB}" ]]; then
    [[ -f "${JAR_TRIMBIB}" ]]
    check_err "failed to find trimbib.jar in the path '${JAR_TRIMBIB}'"
    
    readonly TGT_BIB="${TGT_BIB_NAME}.bib"
    
    printf "Formatting ${WORK_DIR}/${SRC_BIB} ... "
    
    check_cmd_exists "java"
    java -jar "${JAR_TRIMBIB}" -i "${WORK_DIR}/${SRC_BIB}" -d "${WORK_DIR}" \
    -o "${TGT_BIB}" --overwrite "${TRIMBIB_ARGS}" \
    > "${WORK_DIR}/${TRIMBIB_LOG}" 2>&1
    check_err "failed to format '${WORK_DIR}/${SRC_BIB}'"
    
    echo "done"
    echo "Formatted bib: ${WORK_DIR}/${TGT_BIB}"
    echo "Log of bib formatting: ${WORK_DIR}/${TRIMBIB_LOG}"
    
  else  # no bib formatting to perform
    if [[ -f "${WORK_DIR}/${TGT_BIB_NAME}.bib" ]]; then
      readonly TGT_BIB="${TGT_BIB_NAME}.bib"
    elif [[ -f "${WORK_DIR}/${SRC_BIB}" ]]; then
      readonly TGT_BIB="${SRC_BIB}"
    else
      check_err "failed to find .bib file"
    fi
  fi
  
  ln -s "${WORK_DIR}/${TGT_BIB}" "${BUILD_DIR}/${TGT_BIB}"
  
  find_and_link_files_by_ext "bst" "${WORK_DIR}" "${BUILD_DIR}"
fi

# Compile
compile_tex
[[ -n "${CMD_BIBTEX}" ]] && compile_bib && compile_tex && compile_tex

if [[ "${CMD_LATEX}" = "latex" ]]; then
  find_and_link_subdirs "${WORK_DIR}" "${BUILD_DIR}"
  
  find_and_link_files_by_regex ".*\.(eps|ps|pdf|jpg|jpeg|png|bmp)$" \
  "${WORK_DIR}" "${BUILD_DIR}"
  
  cd "${BUILD_DIR}"
  dvips -P pdf -t letter -o "${TEX_NAME}.ps" "${TEX_NAME}.dvi"
  ps2pdf -dPDFSETTINGS#/prepress -dCompatibilityLevel#1.4 -dSubsetFonts#true \
  -dEmbedAllFonts#true "${TEX_NAME}.ps" "${TEX_NAME}.pdf"
fi

# Post-processing
cd "${WORK_DIR}"

mv "${BUILD_DIR}/${TEX_NAME}.pdf" "${PDF_NAME}.pdf"
mv "${BUILD_DIR}/${TEX_NAME}.aux" "${TEX_NAME}.aux"

[[ -n "${CMD_BIBTEX}" ]] &&
mv "${BUILD_DIR}/${TEX_NAME}.bbl" "${TEX_NAME}.bbl"

delete_dir "${BUILD_DIR}"

readonly CMD_MD5SUM="$(cmd_md5sum)"
[[ "$(command -v "${CMD_MD5SUM}")" ]] &&
${CMD_MD5SUM} "${PDF_NAME}.pdf" > "${PDF_NAME}.md5"

# End of script
readonly PDF_BYTES="$(file_size_bytes "${PDF_NAME}.pdf")"

info "------------------------------------------------------------------------"
info_bold_green "BUILD SUCCESSFUL"
info "------------------------------------------------------------------------"
info "Output: ${WORK_DIR}/${PDF_NAME}.pdf (${PDF_BYTES} bytes)"
info "Finished at: $(date +"%T %Z, %-d %B %Y")"
info "Total time: $(timer "${START_TIME}")"
info "------------------------------------------------------------------------"

exit 0
