#!/bin/bash
#
# Operating system related utilities.

os_type() {
  local -r kern_name="$(uname -s)"
  
  case "${kern_name}" in
    Darwin*)  os_name="Mac" ;;
    Linux*)   os_name="Linux" ;;
    MINGW*)   os_name="MinGW" ;;
    CYGWIN*)  os_name="Cygwin" ;;
    *)        os_name="UNKNOWN:${kern_name}" ;;
  esac
  
  echo "${os_name}"
}

cmd_md5sum() {
  case $(os_type) in
    "Mac") cmd="md5" ;;
    *) cmd="md5sum" ;;
  esac
  
  echo "${cmd}"
}
