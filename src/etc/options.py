import argparse
import os
from typing import Literal, TypeAlias

import etc
from etc import defaults

Command: TypeAlias = Literal["bootstrap", "install"]

# For Python 3.12 and up:
# type Command = Literal["bootstrap", "install"]


PARSERS_WITH_CONFIG: dict[Command, str] = {
    "bootstrap": (
        "Bootstrap the workstation configuration and environment and run the "
        "installation afterwards."
    ),
    "install": "Install the workstation configuration and environment.",
}


class Options:
    """
    Options represents the options given for a single run of the
    program. To preserve locality, the context takes most of its input
    values as they are instead of resolving them. The values should thus
    be resolved correctly values before they are passed to the context.
    """

    def __init__(self, base_directory: str, config: str):
        self.__base_directory = base_directory
        self.__config = config

    @property
    def base_directory(self) -> str:
        return self.__base_directory


def create_parser():
    parser = argparse.ArgumentParser(
        prog="etc",
        description=(
            "Tool for managing workstation configuration and environment"
        ),
    )
    _ = parser.add_argument(
        "--colors",
        action=argparse.BooleanOptionalAction,
        help=(
            "Explicitly enable or disable colors in the program's output. "
            "The default value is determined automatically."
        ),
    )
    _ = parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help=(
            "Show what would have been done instead of executing the commands."
        ),
    )
    _ = parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help=(
            "Print more verbose output, can be passed twice to increase the "
            "verbosity."
        ),
    )
    _ = parser.add_argument(
        "--version", action="version", version=f"%(prog)s {etc.__version__}"
    )

    subparsers = parser.add_subparsers(required=True, dest="command")

    def __create_parser_with_config(
        name: Command,
        help: str,
    ):
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
            help=(
                "Path to the configuration directory. If the path is an "
                "absolute path, it is used as it is. Otherwise it is resolved "
                "relative to the base directory. Environment variables are "
                'expanded and initial "~" and "~user" are resolved to user\'s '
                "home directory. Default: "
                f"{os.path.expanduser(defaults.get_default_base_directory())}"
            ),
        )
        _ = configured_parser.add_argument(
            "-c",
            "--config",
            action="store",
            default=defaults.DEFAULT_CONFIG,
            type=str,
            help=(
                "Path to the configuration file. If the path is an absolute "
                "path, it is used as it is. Otherwise it is resolved relative "
                "to the base directory. Environment variables are expanded "
                'and initial "~" and "~user" are resolved to user\'s home '
                f"directory. Default: {defaults.DEFAULT_CONFIG}"
            ),
        )
        return configured_parser

    parsers_with_config: dict[Command, argparse.ArgumentParser] = {
        name: __create_parser_with_config(name=name, help=help)
        for name, help in PARSERS_WITH_CONFIG.items()
    }
    _ = parsers_with_config["bootstrap"].add_argument(
        "-r",
        "--remote",
        action="store",
        default=defaults.DEFAULT_REMOTE,
        help=(
            "Git repository for the configuration. It will be cloned to the "
            "base directory. Default: %(default)s"
        ),
    )

    return parser
