# demo-pytest-tox

- Based on https://joecmarshall.com/posts/python-app-seed/
    - this demo will concentrate on building and producing a dist for a python **app**
- For pip-tools: https://github.com/jazzband/pip-tools
- For using pyenv with tox to supply python
  versions: https://operatingops.com/2020/10/24/tox-testing-multiple-python-versions-with-pyenv/
- For maintaining pyenv with brew python
  versions: https://stackoverflow.com/questions/30499795/how-can-i-make-homebrews-python-and-pyenv-live-together

## directory structure

- `./` - created by IntelliJ New Project
- `src/`
- `test/`
- `venv/` - created by IntelliJ, it won't create a python virtual env at top-level because directory not empty.

## construction

### get tox going inside venv

- created venv with intellij for python3.7 and activated it.
- I eventually want to use tox for testing with multiple python versions, so starting with tox
  from https://operatingops.com/2020/10/24/tox-testing-multiple-python-versions-with-pyenv/
- hmm, already have venv directly from brew without pyenv.
- installing tox into venv: `pip install tox`
- forgot to update pip, so: `pip install --upgrade pip`
- trying echo tox.ini without setup.py

```text
[tox]
envlist = py37, py38

[testenv]
allowlist_externals = echo
commands = echo "success"
```

- running tox

```text
(venv) ghost:demo-pytest-tox ninj$ tox
ERROR: No pyproject.toml or setup.py file found. The expected locations are:
  /Users/ninj/src/demo-pytest-tox/pyproject.toml or /Users/ninj/src/demo-pytest-tox/setup.py
You can
  1. Create one:
     https://tox.readthedocs.io/en/latest/example/package.html
  2. Configure tox to avoid running sdist:
     https://tox.readthedocs.io/en/latest/example/general.html
  3. Configure tox to use an isolated_build
```

- ok, switch to original python-app-seed tutorial because it has setup.py for an empty project.

```text
(venv) ghost:demo-pytest-tox ninj$ tox
GLOB sdist-make: /Users/ninj/src/demo-pytest-tox/setup.py
ERROR: invocation failed (exit code 1), logfile: /Users/ninj/src/demo-pytest-tox/.tox/log/GLOB-0.log
======================================================================================= log start ========================================================================================
running sdist
running check
warning: check: missing required meta-data: url

warning: check: missing meta-data: either (author and author_email) or (maintainer and maintainer_email) must be supplied

warning: sdist: manifest template 'MANIFEST.in' does not exist (using default file list)

warning: sdist: standard file not found: should have one of README, README.txt, README.rst

error: package directory 'src' does not exist

======================================================================================== log end =========================================================================================
ERROR: FAIL could not package project - v = InvocationError('/Users/ninj/src/demo-pytest-tox/venv/bin/python setup.py sdist --formats=zip --dist-dir /Users/ninj/src/demo-pytest-tox/.tox/dist', 1)
```

- ok, let's make src directory: `mkdir src`
- tox appears to run this time, but doesn't like not finding python3.8

```text
(venv) ghost:demo-pytest-tox ninj$ tox
GLOB sdist-make: /Users/ninj/src/demo-pytest-tox/setup.py
py37 create: /Users/ninj/src/demo-pytest-tox/.tox/py37
py37 inst: /Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
ERROR: invocation failed (exit code 1), logfile: /Users/ninj/src/demo-pytest-tox/.tox/py37/log/py37-1.log
======================================================================================= log start ========================================================================================
Processing ./.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'error'
  ERROR: Command errored out with exit status 1:
   command: /Users/ninj/src/demo-pytest-tox/.tox/py37/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-bihji3rf/setup.py'"'"'; __file__='"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-bihji3rf/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s
       cwd: /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-bihji3rf/
  Complete output (7 lines):
  running egg_info
  creating /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s/demo_pytest_tox.egg-info
  writing /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s/demo_pytest_tox.egg-info/PKG-INFO
  writing dependency_links to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s/demo_pytest_tox.egg-info/dependency_links.txt
  writing top-level names to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s/demo_pytest_tox.egg-info/top_level.txt
  writing manifest file '/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-czio3i4s/demo_pytest_tox.egg-info/SOURCES.txt'
  error: package directory 'src' does not exist
  ----------------------------------------
WARNING: Discarding file:///Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip. Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.

======================================================================================== log end =========================================================================================
py38 create: /Users/ninj/src/demo-pytest-tox/.tox/py38
ERROR: InterpreterNotFound: python3.8
________________________________________________________________________________________ summary _________________________________________________________________________________________
ERROR:   py37: InvocationError for command /Users/ninj/src/demo-pytest-tox/.tox/py37/bin/python -m pip install --exists-action w .tox/.tmp/package/1/demo-pytest-tox-0.1.zip (exited with code 1)
ERROR:  py38: InterpreterNotFound: python3.8
```

- think that hadn't restarted shell after fiddling with pyenv setup, so restart shell and run tox again:

```text
(venv) ghost:demo-pytest-tox ninj$ tox
GLOB sdist-make: /Users/ninj/src/demo-pytest-tox/setup.py
py37 inst-nodeps: /Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
ERROR: invocation failed (exit code 1), logfile: /Users/ninj/src/demo-pytest-tox/.tox/py37/log/py37-2.log
======================================================================================= log start ========================================================================================
Processing ./.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'error'
  ERROR: Command errored out with exit status 1:
   command: /Users/ninj/src/demo-pytest-tox/.tox/py37/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-ydhsxxrv/setup.py'"'"'; __file__='"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-ydhsxxrv/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv
       cwd: /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-ydhsxxrv/
  Complete output (7 lines):
  running egg_info
  creating /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv/demo_pytest_tox.egg-info
  writing /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv/demo_pytest_tox.egg-info/PKG-INFO
  writing dependency_links to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv/demo_pytest_tox.egg-info/dependency_links.txt
  writing top-level names to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv/demo_pytest_tox.egg-info/top_level.txt
  writing manifest file '/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-y3mnalpv/demo_pytest_tox.egg-info/SOURCES.txt'
  error: package directory 'src' does not exist
  ----------------------------------------
WARNING: Discarding file:///Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip. Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.

======================================================================================== log end =========================================================================================
py38 create: /Users/ninj/src/demo-pytest-tox/.tox/py38
py38 inst: /Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
ERROR: invocation failed (exit code 1), logfile: /Users/ninj/src/demo-pytest-tox/.tox/py38/log/py38-1.log
======================================================================================= log start ========================================================================================
Processing ./.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'error'
  ERROR: Command errored out with exit status 1:
   command: /Users/ninj/src/demo-pytest-tox/.tox/py38/bin/python -c 'import io, os, sys, setuptools, tokenize; sys.argv[0] = '"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-263y9p74/setup.py'"'"'; __file__='"'"'/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-263y9p74/setup.py'"'"';f = getattr(tokenize, '"'"'open'"'"', open)(__file__) if os.path.exists(__file__) else io.StringIO('"'"'from setuptools import setup; setup()'"'"');code = f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn
       cwd: /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-req-build-263y9p74/
  Complete output (7 lines):
  running egg_info
  creating /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn/demo_pytest_tox.egg-info
  writing /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn/demo_pytest_tox.egg-info/PKG-INFO
  writing dependency_links to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn/demo_pytest_tox.egg-info/dependency_links.txt
  writing top-level names to /private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn/demo_pytest_tox.egg-info/top_level.txt
  writing manifest file '/private/var/folders/jw/9vtpyw1x7wx1xh6l30_vhx540000gn/T/pip-pip-egg-info-bup63kgn/demo_pytest_tox.egg-info/SOURCES.txt'
  error: package directory 'src' does not exist
  ----------------------------------------
WARNING: Discarding file:///Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip. Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.

======================================================================================== log end =========================================================================================
________________________________________________________________________________________ summary _________________________________________________________________________________________
ERROR:   py37: InvocationError for command /Users/ninj/src/demo-pytest-tox/.tox/py37/bin/python -m pip install --no-deps -U .tox/.tmp/package/1/demo-pytest-tox-0.1.zip (exited with code 1)
ERROR:   py38: InvocationError for command /Users/ninj/src/demo-pytest-tox/.tox/py38/bin/python -m pip install --exists-action w .tox/.tmp/package/1/demo-pytest-tox-0.1.zip (exited with code 1)
```

- looks like it found python 3.8, but didn't like setup.py because no packaged code?
- oops, tutorial does say to create an app.py before creating setup.py.

```text
print("Hello World!")
```

- tox works this time.

```text
(venv) ghost:demo-pytest-tox ninj$ tox
GLOB sdist-make: /Users/ninj/src/demo-pytest-tox/setup.py
py37 inst-nodeps: /Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
py37 installed: demo-pytest-tox @ file:///Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
py37 run-test-pre: PYTHONHASHSEED='2540272216'
py37 run-test: commands[0] | echo success
success
py38 inst-nodeps: /Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
py38 installed: demo-pytest-tox @ file:///Users/ninj/src/demo-pytest-tox/.tox/.tmp/package/1/demo-pytest-tox-0.1.zip
py38 run-test-pre: PYTHONHASHSEED='2540272216'
py38 run-test: commands[0] | echo success
success
________________________________________________________________________________________ summary _________________________________________________________________________________________
  py37: commands succeeded
  py38: commands succeeded
  congratulations :)
```

- think it looks like tox uses python<tox env ver> binary from whatever is in path (which makes sense, as you would
  expect to just pick up the shell environment.)
- this means it is finding python3.7 from the venv (as that is what it was created with), and python3.8 from whatever
  the pyenv shim says is available.
- I guess this means we don't need pyenv, just need a PATH that can find the python binaries we require.
- **Don't think we need to worry about which venv tox initially installed in, as it creates the venvs used to run
  tests.**

### does tox understand setup.cfg instead of setup.py?

- setup.cfg is supposed to be more secure than setup.py (as py files require execution.)
- https://github.com/asottile/setup-py-upgrade
- https://setuptools.pypa.io/en/latest/userguide/declarative_config.html
- converted setup.py to setup.cfg:

```text
[metadata]
name=demo-pytest-tox
version=0.0.1

[options]
package_dir=src
packages=find:

[options.packages.find]
where=src
```

- but tox returns this error:

```text
(venv) ghost:demo-pytest-tox ninj$ tox
ERROR: No pyproject.toml or setup.py file found. The expected locations are:
  /Users/ninj/src/demo-pytest-tox/pyproject.toml or /Users/ninj/src/demo-pytest-tox/setup.py
You can
  1. Create one:
     https://tox.readthedocs.io/en/latest/example/package.html
  2. Configure tox to avoid running sdist:
     https://tox.readthedocs.io/en/latest/example/general.html
  3. Configure tox to use an isolated_build
```

- might be worthwhile using flit as it appears to use nice defaults for building things.
- looks like we want to use tox globally too, but we can wrap in a build script so we don't forget what to do.
- should call tox and flit via pipx to help fix versions.
- and have pyenv local to help make things discernable.
- pipx was broken, ~/.local/bin/pipx pointed to a miniconda no longer on machine.
- renamed ~/.local/bin/pipx to something else
- installed pipx via:

```shell
# pip is brew 3.10 version, as defined via pyenv global 
pip install --user pipx
# as per https://pypa.github.io/pipx/installation/
python3 -m pipx ensurepath
# that put python 3.10 into PATH, but in both .bashrc and .bash_profile.
# only need one, so removed the entry added into .bash_profile and left .bashrc
```

- this created ~/.local/bin/pipx pointing at currently installed python

### pipx for consistent, localised build tools

- need to ensure that tox uses controlled version of flit.
    - https://pypa.github.io/pipx/docs/
        - PIPX_HOME for project-local pipx package files
        - PIPX_BIN_DIR for project-local bin
        - problem is that now we need to stop intellij picking up pipx files as src
        - default intellij excludes `Settings | Project: ... | Project Structure | Exclude files`
          via: https://stackoverflow.com/a/69472044/48229
            - *~ might work, but gets excluded from IDE. This might be annoying because you can't see if present
            - otherwise hide in .tox, or venv?
            - build/ gets ignored by default by IDE, though still indexed.
    - create a pipx venv-package to house both
    - call via build script
    - test to see whether tox and flit will be executed from same pipx venv
        - links point to same pipx venv
        - so if tox uses flit via module then should share same install
- Q: will this work while venv already active? A: seems to still work
- potentially could make pipx self-isolation an option via an env var
    - e.g. BUILD_PIPX_ISOLATED=1 ./build.sh ...
    - but hard to figure out sensible default for ci and developer build.
    - so split between build.sh and ci-build.sh?
- .tox dir is ignored but still indexed by intellij.

```shell
export PIPX_HOME="$PWD/build/.pipx"
export PIPX_BIN_DIR="$PWD/build/.pipx-bin"
export PATH="$PATH:$PIPX_BIN_DIR"
pipx install tox==3.24.4
pipx inject tox --include-apps flit==3.4.0
```

### flit for project init

- https://flit.readthedocs.io/en/latest/index.html
- init:

```text
$ flit init
Module name [app]: 
Author: 
Author email: 
Home page: 
Choose a license (see http://choosealicense.com/ for more info)
1. MIT - simple and permissive
2. Apache - explicitly grants patent rights
3. GPL - ensures that code based on this is shared with the same terms
4. Skip - choose a license later
Enter 1-4: 4

Written pyproject.toml; edit that file to add optional extra info.
```

- generated:

```text
[build-system]
requires = ["flit_core >=3.2,<4"]
build-backend = "flit_core.buildapi"

[project]
name = "app"
authors = []
readme = "README.md"
dynamic = ["version", "description"]
```

- tox error:

```text
$ tox
ERROR: pyproject.toml file found.
To use a PEP 517 build-backend you are required to configure tox to use an isolated_build:
https://tox.readthedocs.io/en/latest/example/package.html
```

- configure tox for isolated_build: https://tox.wiki/en/latest/example/package.html#flit

```text
# tox.ini
[tox]
isolated_build = True
```

- tox works again

### pip-tools to generate requirements files

- next need tox to generate pip-tools requirements file for each python version.
- but let's start with the tutorial and pylint to see what tox does with it.
- hmm, pip-tools as dev dependency?

```text
#
# This file is autogenerated by pip-compile with python 3.7
# To update, run:
#
#    pip-compile dev-requirements.in
#
...
pip-tools==6.4.0
    # via -r dev-requirements.in
...
# The following packages are considered to be unsafe in a requirements file:
# pip
# setuptools
```

- ok, don't think pip-tools as a requirement is a good idea, so install via build bootstrap into virtualenv instead.
- producing python-version specific requirements files to commit as part of source isn't necessary for an app.
    - as app intended to be run under a single python version.
    - app will be distributed by pyinstaller (uber archive)
    - or pipx or venv with sdist so also targeted at single python version.
    - testing with multiple versions just a measure of compatibility
    - can stick with single set of {dev-,}requirements.{in,txt} and use for different python versions, against advice
      in: https://pip-tools.readthedocs.io/en/latest/#cross-environment-usage-of-requirements-in-requirements-txt-and-pip-compile
    - if issue with other python version needing different dependency version to resolved version then this should
      appear as an error.
- so enough to use tox -e pip-compile to produce requirements files in a predictable environment:
```text
[testenv:pip-compile]
basepython = python3.7
commands =
    pip-compile requirements.in
    pip-compile dev-requirements.in
# deps inherited from base testenv
```

### security scan

- snyk?

## invoke.py

- just wrap invoke.py with build.sh?