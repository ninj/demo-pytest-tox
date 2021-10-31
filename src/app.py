"""An amazing sample package!"""

__version__ = '0.0.1'

import sys


def main():
    """main entry point"""
    print("Hello World!")


def init():
    """load logic for module"""
    if __name__ == "__main__":
        sys.exit(main())


init()
