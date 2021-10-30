#!/usr/bin/env bash

# SUMMARY
#   Stores project build conventions
#
# USAGE
#   build.sh [goal]
#
#
# EXAMPLES
#
# bootstrap tooling:
#   ./build.sh bootstrap
#
# build project:
#   ./build.sh
#   or
#   ./build.sh assemble
#
# export vars to run tools, e.g. tox:
#   eval "$(./build.sh pipx-init)"
#   tox ...
#
# generate requirements files using pip-compile:
#   ./build.sh pip-compile
#
set -ueo pipefail

declare -r SCRIPT_ORIG="$0"
declare -r SCRIPT_NAME="${0##*/}"
declare -r PROJECT_DIR="${0%/*}"
declare -r TOX_VERSION=3.24.4
declare -r FLIT_VERSION=3.4.0
declare -r PIP_TOOLS_VERSION=6.4.0

pipx_init() {
  cat <<__PIPX_INIT__
export PIPX_HOME="$PROJECT_DIR/build/.pipx"
export PIPX_BIN_DIR="$PROJECT_DIR/build/.pipx-bin"
export PATH="$PIPX_BIN_DIR:\$PATH"
__PIPX_INIT__
}

goal_pipx_init() {
  cat <<__OUTPUT__
# run with: eval "\$($SCRIPT_ORIG pipx-init)"
$(pipx_init)
__OUTPUT__
}

is_virtualenv() {
  [[ -n "${VIRTUAL_ENV}" ]]
}

goal_bootstrap() {
  pipx install tox==$TOX_VERSION
  pipx inject --include-apps tox flit==$FLIT_VERSION
  if is_virtualenv; then
    pip install pip-tools==$PIP_TOOLS_VERSION
  else
    echo "No virtualenv detected, please activate virtualenv first."
    return 1
  fi
}

goal_assemble() {
  tox
}

goal_pip_compile() {
  tox -e pip-compile
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
    echo "$SCRIPT_NAME :: goal: $g ==> executing"
    if "goal_${g//-/_}"; then
      echo "$SCRIPT_NAME :: goal: $g <== done"
    else
      local exit_code=$?
      echo "$SCRIPT_NAME :: goal: $g <== failed with exit code: $exit_code"
      return $exit_code
    fi
  done
}

main "$@"
