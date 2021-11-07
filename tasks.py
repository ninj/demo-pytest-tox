# pylint: disable=invalid-name, unused-argument
"""
pyinvoke tasks definition
"""
from os import path

from invoke import call, task


@task
def ensure_editable_requirements(c):
    """
    generate editable-requirements.txt, if missing.
    """
    if not path.exists("editable-requirements.txt"):
        c.run(
            "pip-compile --output-file editable-requirements.txt "
            "editable-requirements.in"
        )


@task(help={"args": "extra args for pip-compile"}, pre=[ensure_editable_requirements])
def update_requirements(c, args="--upgrade"):
    """
    generate requirements.txt and dev-requirements.txt
    """
    c.run(f"pip-compile {args} requirements.in")
    c.run(f"pip-compile {args} dev-requirements.in")


@task(
    help={
        "args": "extra args for pip-sync",
        "dry-run": "pass --dry-run to pip-sync to only show actions",
    },
    pre=[ensure_editable_requirements],
)
def install_requirements(c, dry_run=False, args=""):
    """
    install requirements for virtual env
    """
    if dry_run:
        args = f"--dry-run {args}"
    c.run(f"pip-sync {args} editable-requirements.txt dev-requirements.txt ")


@task(help={"args": "extra args for isort", "check": "enable check only"})
def isort(c, check=False, args=""):
    """
    sort imports in python code
    """
    if check:
        args = f"--check {args}"
    c.run(f"isort . {args}")


@task(help={"args": "extra args for black", "check": "enable check only"})
def black(c, check=False, args=""):
    """
    reformat code to PEP-8
    see: https://learn.adafruit.com/improve-your-code-with-pylint/black
    remember: '# fmt: off' and '# fmt: on' to control formatting zones.
    """
    if check:
        args = f"--check {args}"
    c.run(f"black {args} .")


@task(help={"args": "extra args for pylint"})
def lint(c, args=""):
    """
    lint code
    """
    c.run(f"pylint src tests tasks.py {args}")


@task(pre=[call(isort), call(black), lint])
def code_format(c):
    """
    run code formatters and call linter to check results
    :return:
    """


@task(pre=[call(isort, check=True), call(black, check=True), lint])
def code_check(c):
    """
    run code checks
    """


@task(
    help={"args": "extra args for tox", "recreate": "pass -r to tox to recreate venvs"}
)
def test(c, recreate=False, args=""):
    """
    run tests via tox
    """
    if recreate:
        args = f"-r {args}"
    c.run(f"tox {args} -e clean")
    c.run(f"tox {args}")


@task(
    pre=[code_check, test],
    help={"args": "extra args for tox", "recreate": "pass -r to tox to recreate venvs"},
)
def assemble(c, recreate=False, args=""):
    """
    assemble project
    """
    if recreate:
        args = f"-r {args}"
    test(c, recreate=recreate, args=args)
    c.run(f"tox {args} -e package")
