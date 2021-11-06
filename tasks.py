from os import path

from invoke import task, call
from invoke.context import Context


@task
def ensure_editable_requirements(c):
    """
    generate editable-requirements.txt, if missing.

    :param Context c:
    :return:
    """
    if not path.exists("editable-requirements.txt"):
        c.run("pip-compile --output-file editable-requirements.txt "
              "editable-requirements.in")


@task(pre=[ensure_editable_requirements])
def generate_requirements(c, args=""):
    """
    generate requirements.txt and dev-requirements.txt

    :param Context c:
        task context
    :param str args:
        extra args for pip-compile
    :return:
    """
    c.run("pip-compile requirements.in " + args)
    c.run("pip-compile dev-requirements.in " + args)


@task(pre=[ensure_editable_requirements])
def update_requirements(c, args=""):
    """
    update virtual env from requirements files

    :param Context c:
        task context
    :param str args:
        extra args for pip-sync
    :return:
    """
    c.run("pip-sync editable-requirements.txt dev-requirements.txt " + args)


@task
def isort(c, args=""):
    """
    sort imports in python code

    :param Context c:
    :param args: extra args to pass to isort
    :return:
    """
    c.run("isort --src src tests " + args)


@task
def black(c, args=""):
    """
    reformat code to PEP-8
    see: https://learn.adafruit.com/improve-your-code-with-pylint/black
    remember: '# fmt: off' and '# fmt: on' to control formatting zones.

    :param Context c: task context
    :param str args: extra args to pass to black
    :return:
    """
    c.run("black src tests " + args)


@task
def lint(c, args=""):
    """
    lint code

    :param Context c:
    :param str args: extra args for pylint
    :return:
    """
    c.run("pylint src tests " + args)


@task(pre=[call(isort), call(black), lint])
def code_format(c):
    """
    run code formatters and call linter to check results

    :param Context c: task context
    :return:
    """
    pass


@task(pre=[call(isort, args='--check'), call(black, args='--check'), lint])
def code_checks(c):
    """
    run code checks

    :param Context c: task context
    :return:
    """
    pass


@task
def test(c, args=""):
    """
    run tests

    :param Context c:
    :param str args: extra args for tox
    """
    c.run("tox " + args)


@task(pre=[generate_requirements, update_requirements, code_checks, test])
def assemble(c):
    """
    assemble project

    :param Context c: task context
    :return:
    """
    pass
