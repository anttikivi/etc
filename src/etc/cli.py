import argparse
from typing import cast

import etc
from etc.terminal import Terminal


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="etc", description="Tool for managing workstation configuration"
    )
    _ = parser.add_argument(
        "--version", action="store_true", dest="print_version", help="print version"
    )

    args = parser.parse_args()
    terminal = Terminal()

    if cast(bool, args.print_version):
        terminal.out(f"etc {etc.__version__}")

    return 0
