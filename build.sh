#!/usr/bin/env bash

# SUMMARY
#   Stores project build conventions
#
# USAGE
#   build.sh [-?|-h|--help] [goal...]
#
# PRE-REQUISITES
#   - pipx installed outside of venv for project-local installations of tools (pip install --user pipx)
#   - venv active, using target python version 3.7 (python3 -m venv venv && source venv/bin/activate)
#   - other python versions available for tox to use (see .python-version file for pyenv)
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
#   eval "$(./build.sh init)"
#   tox ...
#
# generate requirements files using pip-compile:
#   ./build.sh pip-compile
#
set -ueo pipefail

declare -r SCRIPT_ORIG="$0"
declare -r SCRIPT_NAME="${0##*/}"
declare -r PROJECT_DIR="${0%/*}"
declare -r TARGET_PYTHON_VERSION=3.7
declare -r PIP_VERSION=21.3.1
declare -r PIP_TOOLS_VERSION=6.4.0

init() {
  cat <<__INIT__
$(TOXW_INIT=1 ./toxw)
__INIT__
}

goal_init() {
  cat <<__OUTPUT__
# run with: eval "\$($SCRIPT_ORIG init)"
$(init)
__OUTPUT__
}

is_virtualenv() {
  [[ -n "${VIRTUAL_ENV}" ]]
}

goal_bootstrap() {
  ./toxw --version >/dev/null
  if is_virtualenv; then
    pip install pip==$PIP_VERSION
    pip install pip-tools==$PIP_TOOLS_VERSION
  else
    echo "No virtualenv detected, please activate virtualenv first."
    return 1
  fi
}

goal_doctor() {
  cat <<__DOCTOR__
pipx: $(which pipx || echo "no pipx, install docs: https://pypa.github.io/pipx/installation/")
virtualenv: $(is_virtualenv && echo "$VIRTUAL_ENV" || echo "no virtualenv detected, try: python3 -m venv venv && source venv/bin/activate")
python: $(v=$(python --version); [[ "${v#* }" == "$TARGET_PYTHON_VERSION".* ]] && echo "$v" || echo "$v does not match target version $TARGET_PYTHON_VERSION")
__DOCTOR__
}

goal_assemble() {
  ./toxw
}

goal_pip_compile() {
  ./toxw -e pip-compile
}

help() {
  in_block=
  while IFS= read -r line; do
    if [[ "$line" == "#!"* ]]; then
      continue
    elif [[ "$line" == "#"* ]]; then
      in_block=1
    elif [[ -n "$in_block" ]]; then
      return 0
    fi
    [[ -n "$in_block" ]] && printf "%s\n" "$line"
  done < "$SCRIPT_ORIG"
}

goal_help() {
  help
}

main() {
  case "${1:-}" in
  -\?|-h|--help)
    help
    exit
    ;;
  init)
    goal_init
    return $?
    ;;
  esac
  eval "$(init)"
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
