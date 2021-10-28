#!/usr/bin/env bash

# Summary:
# Stores project build conventions
#
# Usage:
#   build.sh [goal]
#
#
# Examples:
#
# build project:
#   ./build.sh
#
# export vars to run tools, e.g. tox:
#   eval "$(./build.sh pipx-init)"
#   tox ...

set -ueo pipefail

declare -r SCRIPT_ORIG="$0"
declare -r SCRIPT_NAME="${0##*/}"
declare -r PROJECT_DIR="${0%/*}"
declare -r TOX_VERSION=3.24.4
declare -r FLIT_VERSION=3.4.0

pipx_init() {
  cat <<__PIPX_INIT__
export PIPX_HOME="$PROJECT_DIR/build/.pipx"
export PIPX_BIN_DIR="$PROJECT_DIR/build/.pipx-bin"
export PATH="\$PATH:$PIPX_BIN_DIR"
__PIPX_INIT__
}

goal_pipx_init() {
  cat <<__OUTPUT__
# run with: eval "\$($SCRIPT_ORIG pipx-init)"
$(pipx_init)
__OUTPUT__
}

goal_bootstrap() {
  pipx install tox==$TOX_VERSION
  pipx inject --include-apps tox flit==$FLIT_VERSION
}

goal_assemble() {
  tox
}

main() {
  eval "$(pipx_init)"
  case "${1:-}" in
  pipx-init)
    goal_pipx_init
    return $?
    ;;
  esac
  if (($# == 0)); then
    goals=(assemble)
  else
    goals=("$@")
  fi
  for g in "${goals[@]}"; do
    echo "$0 :: goal: $g ==> executing"
    if "goal_${g//-/_}"; then
      echo "$0 :: goal: $g <== done"
    else
      echo "$0 :: goal: $g <== failed with exit code: $?"
    fi
  done
}

main "$@"
