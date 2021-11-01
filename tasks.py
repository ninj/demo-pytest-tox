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
def pip_sync(c, args=""):
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
def test(c, args=None):
    """run tests"""
    c.run("tox " + args)
