# demo-pytest-tox

- Based on https://joecmarshall.com/posts/python-app-seed/
- For pip-tools: https://github.com/jazzband/pip-tools
- For using pyenv with tox to supply python versions: https://operatingops.com/2020/10/24/tox-testing-multiple-python-versions-with-pyenv/
- For maintaining pyenv with brew python versions: https://stackoverflow.com/questions/30499795/how-can-i-make-homebrews-python-and-pyenv-live-together

## directory structure

- `./` - created by IntelliJ New Project
- `src/`
- `test/`
- `venv/` - created by IntelliJ, it won't create a python virtual env at top-level because directory not empty.

## construction

- created venv with intellij for python3.7 and activated it.
- I eventually want to use tox for testing with multiple python versions, so starting with tox from https://operatingops.com/2020/10/24/tox-testing-multiple-python-versions-with-pyenv/
- hmm, already have venv directly from brew without pyenv.
- installing tox into venv: `pip install tox`
- forgot to update pip, so: `pip install --upgrade pip`
- trying echo tox.ini without setup.py
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
