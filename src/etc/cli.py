import argparse
import os
from typing import cast

import etc
from etc.commands import install
from etc.context import Context
from etc.terminal import Level, Terminal


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="etc",
        description="Tool for managing workstation configuration and environment",
    )
    _ = parser.add_argument(
        "--colors",
        action=argparse.BooleanOptionalAction,
        help="explicitly enable or disable colors in the program's output (default is determined automatically)",
    )
    _ = parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="print more verbose output, can be passed twice to increase the verbosity",
    )
    _ = parser.add_argument(
        "--version", action="version", version=f"%(prog)s {etc.__version__}"
    )

    subparsers = parser.add_subparsers(required=True, dest="command")
    install_parser = subparsers.add_parser(
        "install", help="install the workstation configuration and environment"
    )
    _ = install_parser.add_argument(
        "-d",
        "--base-directory",
        action="store",
        default="~/etc",
        type=str,
        help="path to the configuration directory",
    )

    args = parser.parse_args()

    print(args)
    command: str | None = cast(str | None, args.command)
    colors: bool | None = cast(bool | None, args.colors)
    if colors is None:
        # TODO: Use a better way to determine the default value.
        colors = True
    verbosity: Level = Level.INFO - Level(cast(int, args.verbose))
    base_directory: str | None = cast(str | None, args.base_directory)
    if base_directory is None:
        base_directory = os.getenv("ETC_DIR")

    terminal = Terminal(colors=colors, level=verbosity)
    ctx = Context(terminal=terminal, base_directory=cast(str, base_directory))

    exit_code: int = 0

    # I can use pattern matching as this program is targeted for Python >= 3.11.
    match command:
        case "install":
            exit_code = install.run(terminal=ctx.terminal, ctx=ctx)
        case _:
            return 1

    return exit_code
