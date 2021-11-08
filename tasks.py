# pylint: disable=invalid-name, unused-argument
"""
pyinvoke tasks definition
"""

import os

from invoke import call, task


@task(help={"args": "extra args for pip-compile"})
def requirements_compile(c, args="--upgrade"):
    """
    generate requirements.txt and dev-requirements.txt
    """
    c.run(f"pip-compile {args} requirements.in")
    c.run(f"pip-compile {args} dev-requirements.in")


@task(
    help={
        "args": "extra args for pip-sync",
        "dry-run": "pass --dry-run to pip-sync to only show actions",
    }
)
def requirements_install(c, dry_run=False, args=""):
    """
    install requirements for virtual env
    """
    if dry_run:
        args = f"--dry-run {args}"
    c.run(f"pip-sync {args} dev-requirements.txt ")


@task(
    help={
        "compile_args": "extra args for pip-compile",
        "install_args": "extra args for pip-sync",
    }
)
def requirements_update(c, compile_args="--upgrade", install_args=""):
    """
    generate requirements and install them
    """
    requirements_compile(c, args=compile_args)
    requirements_install(c, args=install_args)


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


@task(pre=[call(isort), call(black)])
def code_format(c):
    """
    run code formatters only
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


os.environ.setdefault("PIP_REQUIRE_VIRTUALENV", "true")
