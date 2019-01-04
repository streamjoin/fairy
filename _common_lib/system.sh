#!/bin/bash
#
# Operating system related utilities.
#
# Dependencies: output_utils.sh

check_cmd_exists() {
  [[ "$#" -gt 0 ]] && [[ "$#" -le 2 ]]
  check_err "wrong number of parameters to 'check_cmd_exists()'"
  
  [[ "$(command -v "$1")" ]]
  check_err "command ${1:+'$1'} not found${2:+: $2}"
}

check_cmd_args() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    err "Usage: $(basename "$0") $@"
    exit "${EXIT_CODE}"
  fi
}

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

arg_find_e() {
  case $(os_type) in
    "Mac") arg="-E" ;;
    *) arg="" ;;
  esac
  
  echo "${arg} "
}

cmd_md5sum() {
  case $(os_type) in
    "Mac") cmd="md5" ;;
    *) cmd="md5sum" ;;
  esac
  
  echo "${cmd}"
}

function timer()
{
  if [[ "$#" -eq 0 ]]; then
    echo "$(date '+%s')"
  else
    local stime=$1
    local -r etime="$(date '+%s')"
    
    if [[ -z "${stime}" ]]; then stime="${etime}"; fi
    local -r delta="$((etime - stime))"
    
    local -r sec="$((delta % 60))"
    if [[ "${delta}" -lt 60 ]]; then
      echo "${sec} sec"
    else
      local -r min="$(((delta / 60) % 60))"
      if [[ "${delta}" -lt 3600 ]]; then
        echo "${min} min ${sec} sec"
      else
        local -r hr="$((delta / 3600))"
        echo "${hr} hr ${min} min ${sec} sec"
      fi
    fi
  fi
}
