import argparse
import os
from typing import Literal

import etc
from etc import defaults

Command = Literal["bootstrap", "install"]


CONFIGURED_SUBPARSERS: dict[Command, str] = {
    "bootstrap": "Bootstrap the workstation configuration and environment and run the installation afterwards.",
    "install": "Install the workstation configuration and environment.",
}


def create_parser():
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

    for name, help in CONFIGURED_SUBPARSERS.items():
        configured_parser = subparsers.add_parser(
            name=name,
            help=help,
        )
        _ = configured_parser.add_argument(
            "-d",
            "--base-directory",
            action="store",
            default=defaults.get_default_base_directory(),
            type=str,
            help=f'Path to the configuration directory. If the path is an absolute path, it is used as it is. Otherwise it is resolved relative to the base directory. Environment variables are expanded and initial "~" and "~user" are resolved to user\'s home directory. Default: {os.path.expanduser(defaults.get_default_base_directory())}',
        )
        _ = configured_parser.add_argument(
            "-c",
            "--config",
            action="store",
            default=defaults.DEFAULT_CONFIG,
            type=str,
            help=f'Path to the configuration file. If the path is an absolute path, it is used as it is. Otherwise it is resolved relative to the base directory. Environment variables are expanded and initial "~" and "~user" are resolved to user\'s home directory. Default: {defaults.DEFAULT_CONFIG}',
        )

    return parser