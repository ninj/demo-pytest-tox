# demo-pytest-tox

- Based on https://joecmarshall.com/posts/python-app-seed/
    - this demo will concentrate on building and producing a dist for a python **app**
- For pip-tools: https://github.com/jazzband/pip-tools
- For using pyenv with tox to supply python
  versions: https://operatingops.com/2020/10/24/tox-testing-multiple-python-versions-with-pyenv/
- For maintaining pyenv with brew python
  versions: https://stackoverflow.com/questions/30499795/how-can-i-make-homebrews-python-and-pyenv-live-together

## Goals

- only need to call `build.sh` to build project.
- developer only needs to call `bootstrap.sh` to set up local environment.
    - assumes required python versions already available in path.
- developer can import project into IntelliJ and run project.

## Structure

- `./` - created by IntelliJ New Project
- `src/` - main source
- `tests/` - tests for pytest
- `venv/` - created by `bootstrap.sh` if VIRTUAL_ENV not present.
- `.python-version` - pyenv config (should match what tox uses)
- `bootstrap.sh` - creates / updates `venv`
- `build.sh` - runs build.
- `dev-requirements.in` - input for `pip-compile`
- `dev-requirements.txt` - output from `pip-compile`
- `editable-requirements.in` - input for `pip-compile`
- `editable-requirements.txt` - output from `pip-compile` (ignored by git, automatically created by `bootstrap.sh`)
- `invoke.yaml` - pyinvoke configuration
- `pyproject.toml` - generated by `flit init`
- `requirements.in` - input for `pip-compile`
- `requirements.txt` - output from `pip-compile`
- `tasks.py` - task definitions for pyinvoke.
- `tox.ini` - `tox` configuration

## Features

- dependency resolution with `pip-compile`
- code formatting with `isort` and `black`
- linting with `pylint`
- tests with `pytest`

Note that Black uses a line length of 88 characters, so you might need to change your IDE settings to match.

For Intellij, `Editor > Code Style > Python` > set `Hard Wrap At` and `Visual Guides` to `88`.

## Usage

- to set up developer environment, run `./bootstrap.sh` to:
    - create `venv`
    - install dev-requirements
    - install current project as editable
    - can be run multiple times to update `venv`
- to build project, run `./build.sh`
    - also calls `bootstrap.sh`, so easily used in something like restabuild.
    - runs QA checks, so badly formatted code will fail build.
- other tasks can be run via `invoke` (which is installed along with dev requirements.)
- because project is installed as editable into virtual environment, IntelliJ/PyCharm should auto-detect src directory
  as a source root. This allows the IDE to recognise the app module, e.g. in tests.

### `invoke`

- list tasks with `inv -l`
- set up completion with `source <(inv print-completion-script bash)` (replace `bash` with `zsh` as appropriate)
- `inv requirements-update` will call `pip-compile` to:
    - generate `requirements.txt` from `requirements.in`
    - generate `dev-requirements.txt` from `dev-requirements.in`
- `inv requirements-install` will install requirements into `venv` (with `pip-sync`)
- `inv code-check` will run code checks
- `inv code-format` will reformat code
- `inv test` will run tests via `tox` for multiple python versions.

Notes:

- `pip` keeps re-installing editable modules - think that has to do with the way `pip` handles editable modules.
- pyinvoke isn't compatible with python 3.10 at the moment.

## Development Decisions

Why some things were chosen.

### tools in venv

- Although it is possible to call tools through a wrapper to provide an automatic venv, the convention appears to be
  that if a project needs a tool, then it should be installed into the venv for the project.
- Tried using tox through pipx, but this caused an issue when tox was attempting to manage the venv that was also
  currently in use. (Potentially this is a problem anyway, but tox was definitely very confused.)
- Also an issue using pipx for a tool if it also needs dependent packages - this means relocating the install that pipx
  creates into the project-specific directory so we can inject the other packages required. Potentially could use a hash
  of the extra packages (and versions), but generally speaking is a bit too complex compare to the benefits of being
  able to "just use" the tool.
- There is a general problem where if a tool in a tool-specific venv needs to also call another dependency/tool then that also needs to be installed so the first tool can find the second tool.

### tox to manage tools

- although it is tempting to use tox to run tools, there are complications around:
  - venv management: the extra config in tox.ini might be confusing
- extra output from tox when running tool (unless you use -q?)
- adding extra config to tox would distract from it's purpose for testing with multiple versions of python.

### src layout for project

- src/ layout prevents subtle problems during testing where extra .py files in project directory.
- tox runs tests by installing project, so can handles as installed module.

### installing project as editable module

- extra steps / artifacts required for using project as editable (`editable-requirements*`)
- but IntelliJ/PyCharm need project to be installed into venv so that src/ directory is automatically picked up.

### pip-tools to manage requirements

- pip-compile allows us to specify top-level inside `*requirements.in` files, and it calculates appropriate versions for both direct and transitive dependencies.
- otherwise hard to know which are the direct dependencies and transitive dependencies.
- pip-sync helps remove unwanted dependencies as well as install required dependencies.

### invoke for project tasks

- has no other dependencies.
- provides convenient help, arg parsing.
- also provides completion scripts.

### pylint exceptions

- tasks.py disables:
  - `invalid-name` as method parameter names dictate command line argument names.
  - `unused-argument` as pyinvoke requires a context argument for all @task methods.
- tests disable:
  - `missing-function-docstring` as test method definitions usually self-descriptive.
