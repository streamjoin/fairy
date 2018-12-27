#!/bin/sh
#
# Execution of compiling LaTeX project. 

set -o pipefail

# Include libraries
readonly SCRIPT_HOME="$(cd "$(dirname "$0")"; pwd -P)"
source "${FAIRY_HOME:-${SCRIPT_HOME}/..}/_common_lib/output_utils.sh"
source "${FAIRY_HOME:-${SCRIPT_HOME}/..}/_common_lib/filesystem.sh"

# Check environment variables
[[ -n "${TEX_NAME}" ]]
check_err "'TEX_NAME' undefined: name of the main .tex file"

[[ -n "${PDF_NAME}" ]] || readonly PDF_NAME="${TEX_NAME}"

[[ -n "${CMD_LATEX}" ]] || readonly CMD_LATEX="latex"

[[ -n "${CMD_BIBTEX}" ]] || readonly CMD_BIBTEX="bibtex"

[[ -n "${TGT_BIB_NAME}" ]] || 
readonly TGT_BIB_NAME="${SRC_BIB_NAME:+${SRC_BIB_NAME}-trim}"

[[ -n "${TRIMBIB_LOG}" ]] || readonly TRIMBIB_LOG="trimbib_log.txt"

[[ -n "${WORK_DIR}" ]] || readonly WORK_DIR="$(cd "$(dirname "$0")"; pwd -P)"

[[ -n "${BUILD_DIR}" ]] || readonly BUILD_DIR="${WORK_DIR}/pdfbuild"

# Set variables
readonly JAR_TRIMBIB="${TRIMBIB_HOME:+${TRIMBIB_HOME}/release/trimbib.jar}"

# Functions
compile_tex() {
  cd "${WORK_DIR}"
  if [[ "${CMD_LATEX}" = "latex" ]]; then
    ${CMD_LATEX} -output-directory="${BUILD_DIR}" \
    -aux-directory="${BUILD_DIR}" "${TEX_NAME}.tex"

  elif [[ "${CMD_LATEX}" = "pdflatex" ]]; then
    pdflatex -output-directory "${BUILD_DIR}" "${TEX_NAME}.tex"

  else
    check_err "unknown latex command '${CMD_LATEX}'"
  fi
  check_err "failed to compile '${TEX_NAME}.tex'"
}

compile_bib() {
  cd "${BUILD_DIR}"
  ${CMD_BIBTEX} "${TEX_NAME}.aux"
  check_err "failed to compile '\\\\bibliography{${TGT_BIB%.*}}'"
}

# Prepare
delete_file "${PDF_NAME}.pdf"
delete_file "${PDF_NAME}.md5"
delete_file "${TEX_NAME}.aux"

delete_dir "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}" 

if [[ -n "${CMD_BIBTEX}" ]]; then
	delete_file "${TEX_NAME}.bbl"

  readonly SRC_BIB="${SRC_BIB_NAME}.bib"

  if [[ -n "${JAR_TRIMBIB}" ]] && [[ -f "${WORK_DIR}/${SRC_BIB}" ]]; then
    [[ -f "${JAR_TRIMBIB}" ]]
    check_err "failed to find trimbib.jar in the path '${JAR_TRIMBIB}'"

    readonly TGT_BIB="${TGT_BIB_NAME}.bib"

    printf "Formatting ${WORK_DIR}/${SRC_BIB} ... "

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
if [[ -n "${CMD_BIBTEX}" ]]; then
  compile_bib
  compile_tex
  compile_tex
fi

if [[ "${CMD_LATEX}" = "latex" ]]; then
  cd "${BUILD_DIR}"
  readonly PS_FILE="${TEX_NAME}.ps"

  find_and_link_subdirs "${WORK_DIR}" "${BUILD_DIR}"

  find_and_link_files_by_ext "eps" "${WORK_DIR}" "${BUILD_DIR}"

  dvips -P pdf -t letter -o "${PS_FILE}" "${TEX_NAME}.dvi"

  ps2pdf -dPDFSETTINGS#/prepress -dCompatibilityLevel#1.4 -dSubsetFonts#true \
  -dEmbedAllFonts#true "${PS_FILE}" "${TEX_NAME}.pdf"
fi

mv "${BUILD_DIR}/${TEX_NAME}.pdf" "${WORK_DIR}/${PDF_NAME}.pdf"
mv "${BUILD_DIR}/${TEX_NAME}.aux" "${WORK_DIR}/${TEX_NAME}.aux"

[[ -n "${CMD_BIBTEX}" ]] && 
mv "${BUILD_DIR}/${TEX_NAME}.bbl" "${WORK_DIR}/${TEX_NAME}.bbl"

cd "${WORK_DIR}" 
md5sum "${PDF_NAME}.pdf" > "${PDF_NAME}.md5"
delete_dir "${BUILD_DIR}"

readonly PDF_BYTES="$(file_size_bytes "${WORK_DIR}/${PDF_NAME}.pdf")"
info "Output: ${WORK_DIR}/${PDF_NAME}.pdf (${PDF_BYTES} bytes)"

exit 0
