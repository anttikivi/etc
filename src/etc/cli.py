import argparse
from typing import cast

import etc
from etc.commands import install
from etc.terminal import Terminal


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="etc",
        description="Tool for managing workstation configuration and environment",
    )
    _ = parser.add_argument(
        "--version", action="version", version=f"%(prog)s {etc.__version__}"
    )
    _ = parser.add_argument(
        "--colors",
        action=argparse.BooleanOptionalAction,
        help="explicitly enable or disable colors in the program's output (default is determined automatically)",
    )

    subparsers = parser.add_subparsers(required=True, dest="command")
    _ = subparsers.add_parser(
        "install", help="install the workstation configuration and environment"
    )

    args = parser.parse_args()

    command: str | None = cast(str | None, args.command)
    colors: bool | None = cast(bool | None, args.colors)
    if colors is None:
        # TODO: Use a better way to determine the default value.
        colors = True

    terminal = Terminal(colors=colors)

    exit_code = 0

    match command:
        case "install":
            exit_code = install.run(terminal=terminal)
        case _:
            return 1

    return exit_code
