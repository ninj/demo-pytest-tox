#!/usr/bin/env bash

set -ueo pipefail

declare -r SCRIPT_NAME="${0##*/}"

help() {
  cat <<__HELP__
SUMMARY
  builds project

USAGE
  $SCRIPT_NAME [-?|-h|--help] [goal...]

EXAMPLES

build project:
  $SCRIPT_NAME
  or
  $SCRIPT_NAME assemble
__HELP__
}


is_virtualenv() {
  [[ -n "${VIRTUAL_ENV:-}" ]]
}

goal_bootstrap() {
  ./bootstrap.sh
}

goal_doctor() {
  cat <<__DOCTOR__
virtualenv: $(is_virtualenv && echo "$VIRTUAL_ENV" || echo "no virtualenv detected. Use './bootstrap.sh' to create and 'source venv/bin/activate' to activate")
python: $(which python)
python version: $(python --version)
__DOCTOR__
}

goal_assemble() {
  goal_bootstrap
  invoke assemble
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
  esac
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
