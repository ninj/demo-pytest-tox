#!/usr/bin/env bash

set -ueo pipefail

declare -r SCRIPT_DIR="${0%/*}"
declare -r VENV_DIR="${VENV_DIR:-venv}" # relative to SCRIPT_DIR or full path
export PIP_REQUIRE_VIRTUALENV="${PIP_REQUIRE_VIRTUALENV:-true}"

print_help() {
  cat <<__HELP__
SUMMARY
  builds project

USAGE
  $SCRIPT_NAME [-?|-h|--help]

NOTES
  calls bootstrap.sh before
__HELP__
}

is_virtualenv() {
  [[ -n "${VIRTUAL_ENV:-}" ]]
}

main() {
  case "${1:-}" in
  -\?|-h|--help)
    print_help
    return 0
    ;;
  esac
  if ! is_virtualenv; then
    export PATH="$VENV_DIR/bin:$PATH"
  fi
  cd "$SCRIPT_DIR"
  ./bootstrap.sh
  inv build
}

main "$@"
