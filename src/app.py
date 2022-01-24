"""An amazing sample package!"""

__version__ = "0.0.1"

import sys


def main() -> object:
    """main entry point"""
    return print("Hello World!")


def init() -> None:
    """load logic for module"""
    if __name__ == "__main__":
        sys.exit(main())


init()
