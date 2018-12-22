#!/bin/bash
#
# Utilities for file and directory mannipulation.
#
# Dependencies: output_utils.sh

delete_file() {
  rm -f "$1"
  [[ ! -f "$1" ]]
  check_err "failed to delete file '$1'"
}

delete_dir() {
  rm -rf "$1"
  [[ ! -d "$1" ]]
  check_err "failed to delete directory '$1'"
}
