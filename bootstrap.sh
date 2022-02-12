#!/usr/bin/env bash

set -ueo pipefail

declare -r PIP_VERSION=21.3.1

declare -r SCRIPT_DIR="${0%/*}"
declare -r VENV_DIR="${VENV_DIR:-venv}" # relative to SCRIPT_DIR or full path

print_help() {
  cat <<__HELP__
SUMMARY
  Sets up environment for build / development.
  Intended to be idempotent, so can be run multiple times to update
  development virtual environment.

USAGE
  bootstrap.sh [-?|-h|--help]

DESCRIPTION
  - if virtualenv not active:
    - if not found, creates venv
  - installs dev-requirements
  - updates pip packages in virtualenv
__HELP__
}

log() {
  echo ">>" "$@"
}

ensure_venv() {
  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    log "virtualenv: already active: $VIRTUAL_ENV"
  else
    log "virtualenv: not active"
    if [[ -d "$VENV_DIR" ]]; then
      log "virtualenv: existing at: $VENV_DIR"
    else
      log "virtualenv: creating at: $VENV_DIR"
      python3 -m venv "$VENV_DIR"
    fi
    export PATH="$VENV_DIR/bin:$PATH"
  fi
}

ensure_venv_pip() {
  log "pip: want $PIP_VERSION"
  pip install --upgrade pip=="$PIP_VERSION"
}

bootstrap_dev_requirements() {
  if which inv >/dev/null 2>&1; then
    log "dev-requirements: already present"
  else
    log "dev-requirements: bootstrapping..."
    pip install -r dev-requirements.txt
  fi
}

install_requirements() {
  log "requirements: installing..."
  invoke requirements-install
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
  ensure_venv_pip
  bootstrap_dev_requirements
  install_requirements
}

main "$@"
