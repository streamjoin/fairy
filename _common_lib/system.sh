#!/bin/bash
#
# Operating system related utilities.
#
# Dependencies: output_utils.sh

os_type() {
  local -r kern_name="$(uname -s)"

  case "${kern_name}" in
    Linux*) 
os_name="Linux" 
;;
Darwin*) 
os_name="Mac" 
;;
MINGW*) os_name="MinGW" 
;;
CYGWIN*) 
os_name="Cygwin" 
;;
*) 
os_name="UNKNOWN:${kern_name}" 
;;
esac

echo "${os_name}"
}
