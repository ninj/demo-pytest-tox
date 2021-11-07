"""tests for app"""
import mock
import pytest

import app


def test_exit():
    """
    based on:
    https://medium.com/python-pandemonium/testing-sys-exit-with-pytest-10c6e5f7726f
    """
    with mock.patch.object(app, "main", return_value=42):
        with mock.patch.object(app, "__name__", "__main__"):
            with pytest.raises(SystemExit) as pytest_wrapped_e:
                app.init()
    assert pytest_wrapped_e.type == SystemExit
    assert pytest_wrapped_e.value.code == 42


def test_main(capsys):
    """
    main method

    :param capsys: capture io
    :return:
    """
    app.main()
    captured = capsys.readouterr()
    assert captured.out == "Hello World!\n"
