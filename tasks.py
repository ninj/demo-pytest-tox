from os import path

from invoke import task
from invoke.context import Context


@task
def pip_compile(c, args=""):
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
def lint(c, args=""):
    """
    lint code

    :param c: Context
    :param str args: extra args for pylint
    :return:
    """
    c.run("pylint src tests " + args)


@task
def test(c, args=""):
    """run tests"""
    c.run("tox " + args)
