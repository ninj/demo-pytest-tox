#!/usr/bin/env bash

set -ueo pipefail

declare -r SCRIPT_DIR="${0%/*}"
declare -r VENV_DIR="${VENV_DIR:-venv}" # relative to SCRIPT_DIR or full path

print_help() {
  cat <<__HELP__
SUMMARY
  Sets up environment for build / development.
  Intended to be idempotent, so can be run multiple times to update
  development virtual environment.

USAGE
  bootstrap.sh

DESCRIPTION
  - if virtualenv not active:
    - if not found, creates venv directory
    - activates venv
  - updates pip packages in virtualenv
__HELP__
}

log() {
  echo "$@"
}

ensure_venv() {
  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    log "active virtualenv detected: $VIRTUAL_ENV"
  else
    log "no active virtualenv detected"
    if [[ ! -d "$VENV_DIR" ]]; then
      log "creating virtualenv at: $VENV_DIR"
      python3 -m venv "$VENV_DIR"
    fi
    log "attempting to activate $VENV_DIR"
    # shellcheck disable=SC1090
    source "$VENV_DIR/bin/activate"
  fi
}

ensure_editable_requirements() {
  if [[ -f editable-requirements.txt ]]; then
    log "editable-requirements.txt already present"
  else
    log "editable-requirements.txt not found, generating"
    pip-compile --output-file editable-requirements.txt editable-requirements.in
  fi
}

main() {
  case "${1:-}" in
  -\?|-h|--help)
    print_help
    return 0
    ;;
  esac
  cd "$SCRIPT_DIR"
  ensure_venv
  ensure_editable_requirements
  if which pip-sync >/dev/null 2>&1; then
    log "syncing venv dependencies"
    pip-sync editable-requirements.txt dev-requirements.txt
  else
    log "installing venv dependencies"
    pip install -r editable-requirements.txt -r dev-requirements.txt
  fi
}

main "$@"
