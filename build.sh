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
# VERSION MANAGEMENT OF TOOLS FOR LOCAL DEVELOPMENT
#   - build.sh itself only relies on toxw
#   => tox version is managed in .tox/.wrapper/toxw.config
#   - bootstrap goal uses tox to create developer virtualenv
#   => tool versions that are installed into developer virtual environment are managed in tox.ini
#
# EXAMPLES
#
# build project:
#   ./build.sh
#   or
#   ./build.sh assemble
#
# bootstrap tooling for local development:
#   ./build.sh bootstrap
#
# export vars to run project-local tools, e.g. tox:
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
  [[ -n "${VIRTUAL_ENV:-}" ]]
}

goal_bootstrap() {
  ./toxw --version >/dev/null
  if [[ -d venv ]]; then
    echo "venv directory already present, assuming virtualenv already created."
  else
    echo "venv directory not found, creating virtualenv via tox..."
    ./toxw --devenv venv -e tool
  fi
}

goal_doctor() {
  cat <<__DOCTOR__
pipx: $(which pipx || echo "no pipx, install docs: https://pypa.github.io/pipx/installation/")
virtualenv: $(is_virtualenv && echo "$VIRTUAL_ENV" || echo "no virtualenv detected. Use './build.sh bootstrap' to create and 'source venv/bin/activate' to activate")
python: $(which python)
python version: $(python --version)
__DOCTOR__
}

goal_assemble() {
  ./toxw
}

goal_pip_compile() {
  ./toxw -e pip-compile
}

goal_pip_sync() {
  pip-sync dev-requirements.txt
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
    echo "$SCRIPT_NAME :: $g ==> executing"
    if "goal_${g//-/_}"; then
      echo "$SCRIPT_NAME :: $g <== done"
    else
      local exit_code=$?
      echo "$SCRIPT_NAME :: $g <== failed with exit code: $exit_code"
      return $exit_code
    fi
  done
}

main "$@"
