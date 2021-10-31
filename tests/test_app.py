import mock
import pytest

def test_exit():
    """
    based on: https://medium.com/python-pandemonium/testing-sys-exit-with-pytest-10c6e5f7726f
    """
    import app
    with mock.patch.object(app, "main", return_value=42):
        with mock.patch.object(app, "__name__", "__main__"):
            with pytest.raises(SystemExit) as pytest_wrapped_e:
                app.init()
    assert pytest_wrapped_e.type == SystemExit
    assert pytest_wrapped_e.value.code == 42

# def test_init():
#     import app
#     """
#     based on: https://medium.com/opsops/how-to-test-if-name-main-1928367290cb
#     """
#     with mock.patch.object(app, "main", return_value=42):
#         with mock.patch.object(app, "__name__", "__main__"):
#             with mock.patch.object(app.sys, 'exit') as mock_exit:
#                 app.init()
#                 assert mock_exit.call_args[0][0] == 42
