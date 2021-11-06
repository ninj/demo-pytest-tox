# pylint: disable=invalid-name, unused-import, unused-argument
"""
pyinvoke tasks definition
"""
from os import path

from invoke import call, task
from invoke.context import Context


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


@task(help={'args': 'extra args for pip-compile'},
      pre=[ensure_editable_requirements])
def update_requirements(c, args=""):
    """
    generate requirements.txt and dev-requirements.txt
    """
    c.run("pip-compile requirements.in " + args)
    c.run("pip-compile dev-requirements.in " + args)


@task(help={'args': 'extra args for pip-sync',
            'dry-run': 'pass --dry-run to pip-sync to only show actions'},
      pre=[ensure_editable_requirements])
def install_requirements(c, dry_run=False, args=""):
    """
    install requirements for virtual env
    """
    if dry_run:
        args = "--dry-run " + args
    c.run("pip-sync editable-requirements.txt dev-requirements.txt " + args)


@task(help={'args': 'extra args for isort'})
def isort(c, args=""):
    """
    sort imports in python code
    """
    c.run("isort src tests tasks.py " + args)


@task(help={'args': 'extra args for black'})
def black(c, args=""):
    """
    reformat code to PEP-8
    see: https://learn.adafruit.com/improve-your-code-with-pylint/black
    remember: '# fmt: off' and '# fmt: on' to control formatting zones.
    """
    c.run("black src tests tasks.py " + args)


@task(help={'args': 'extra args for pylint'})
def lint(c, args=""):
    """
    lint code
    """
    c.run("pylint src tests tasks.py " + args)


@task(pre=[call(isort), call(black), lint])
def code_format(c):
    """
    run code formatters and call linter to check results
    :return:
    """


@task(pre=[call(isort, args="--check"), call(black, args="--check"), lint])
def code_checks(c):
    """
    run code checks
    """


@task(help={'args': 'extra args for tox'})
def test(c, args=""):
    """
    run tests
    """
    c.run("tox " + args)


@task(pre=[install_requirements, code_checks, test])
def assemble(c):
    """
    assemble project

    :param Context c: task context
    :return:
    """
