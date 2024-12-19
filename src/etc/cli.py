import argparse
import sys
import os
from typing import cast

import etc
from etc.commands import install
from etc.context import Context
from etc.exceptions import UnsupportedPlatformError
from etc.terminal import Level, Terminal


DEFAULT_LINUX_BASE_DIRECTORY = "~/etc"
DEFAULT_DARWIN_BASE_DIRECTORY = "~/Preferences"
DEFAULT_CONFIG = "etc.toml"


def get_default_base_directory() -> str:
    if sys.platform == "darwin":
        return DEFAULT_DARWIN_BASE_DIRECTORY

    if sys.platform == "linux":
        return DEFAULT_LINUX_BASE_DIRECTORY

    raise UnsupportedPlatformError


def main() -> int:
    parser = argparse.ArgumentParser(
        prog="etc",
        description="Tool for managing workstation configuration and environment",
    )
    _ = parser.add_argument(
        "--colors",
        action=argparse.BooleanOptionalAction,
        help="Explicitly enable or disable colors in the program's output. The default value is determined automatically.",
    )
    _ = parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Print more verbose output, can be passed twice to increase the verbosity.",
    )
    _ = parser.add_argument(
        "--version", action="version", version=f"%(prog)s {etc.__version__}"
    )

    subparsers = parser.add_subparsers(required=True, dest="command")
    install_parser = subparsers.add_parser(
        "install", help="Install the workstation configuration and environment."
    )
    _ = install_parser.add_argument(
        "-d",
        "--base-directory",
        action="store",
        default=get_default_base_directory(),
        type=str,
        help=f'Path to the configuration directory. If the path is an absolute path, it is used as it is. Otherwise it is resolved relative to the base directory. Environment variables are expanded and initial "~" and "~user" are resolved to user\'s home directory. Default: {os.path.expanduser(get_default_base_directory())}',
    )
    _ = install_parser.add_argument(
        "-c",
        "--config",
        action="store",
        default=DEFAULT_CONFIG,
        type=str,
        help=f'Path to the configuration file. If the path is an absolute path, it is used as it is. Otherwise it is resolved relative to the base directory. Environment variables are expanded and initial "~" and "~user" are resolved to user\'s home directory. Default: {DEFAULT_CONFIG}',
    )

    args = parser.parse_args()

    print(args)
    command: str | None = cast(str | None, args.command)
    colors: bool | None = cast(bool | None, args.colors)
    if colors is None:
        # TODO: Use a better way to determine the default value.
        colors = True
    verbosity: Level = Level.INFO - Level(cast(int, args.verbose))
    base_directory: str = os.path.expandvars(
        os.path.expanduser(cast(str, args.base_directory))
    )
    if not os.path.isabs(base_directory):
        base_directory = os.path.abspath(base_directory)
    config: str = os.path.expandvars(os.path.expanduser(cast(str, args.config)))
    if not os.path.isabs(config):
        config = os.path.normpath(os.path.join(base_directory, config))

    terminal = Terminal(colors=colors, level=verbosity)

    terminal.debug(f"Resolved {base_directory} as the base directory")
    terminal.debug(f"Resolved {config} as the configuration file")

    ctx = Context(terminal=terminal, base_directory=base_directory, config=config)

    exit_code: int = 0

    # I can use pattern matching as this program is targeted for Python >= 3.11.
    match command:
        case "install":
            exit_code = install.run(terminal=ctx.terminal, ctx=ctx)
        case _:
            return 1

    return exit_code
