import argparse
import os
from typing import Literal, Self, TypeAlias, cast

import etc
from etc import defaults
from etc.message_level import MessageLevel

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

    def __init__(
        self,
        base_directory: str | None,
        command: Command | None,
        config_file: str | None,
        dry_run: bool,
        remote_repository_url: str | None,
        use_colors: bool,
        verbosity: MessageLevel,
    ):
        self.base_directory: str | None = base_directory
        self.command: Command | None = command
        self.config_file: str | None = config_file
        self.dry_run: bool = dry_run
        self.remote_repository_url: str | None = remote_repository_url
        self.use_colors: bool = use_colors
        self.verbosity: MessageLevel = verbosity

    @classmethod
    def parse(cls, args: argparse.Namespace) -> Self:
        command = cast(Command | None, args.command)

        colors = cast(bool | None, args.colors)
        if colors is None:
            # TODO: Use a better way to determine the default value.
            colors = True

        base_directory = (
            None
            if "base_directory" not in args
            else os.path.expandvars(
                os.path.expanduser(cast(str, args.base_directory))
            )
        )
        if base_directory is not None and not os.path.isabs(base_directory):
            base_directory = os.path.abspath(base_directory)

        config_file = (
            None
            if "config_file" not in args
            else os.path.expandvars(
                os.path.expanduser(cast(str, args.config_file))
            )
        )
        # All commands that use the config file should also specify the
        # base directory. This might be changed in the future, but for
        # now, they have at least the default values.
        if base_directory is None and config_file is not None:
            raise ValueError(
                "configuration file has a value while base directory does not"
            )
        if (
            base_directory is not None
            and config_file is not None
            and not os.path.isabs(config_file)
        ):
            config_file = os.path.normpath(
                os.path.join(base_directory, config_file)
            )

        dry_run = cast(bool, args.dry_run)

        remote_repo = (
            None
            if "remote_repository" not in args
            else cast(str, args.remote_repository)
        )

        verbosity = MessageLevel.INFO - MessageLevel(cast(int, args.verbose))

        return cls(
            base_directory=base_directory,
            command=command,
            config_file=config_file,
            dry_run=dry_run,
            remote_repository_url=remote_repo,
            use_colors=colors,
            verbosity=verbosity,
        )


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
                "home directory. Default: %(default)s"
            ),
        )
        _ = configured_parser.add_argument(
            "-c",
            "--config",
            action="store",
            default=defaults.DEFAULT_CONFIG,
            dest="config_file",
            type=str,
            help=(
                "Path to the configuration file. If the path is an absolute "
                "path, it is used as it is. Otherwise it is resolved relative "
                "to the base directory. Environment variables are expanded "
                'and initial "~" and "~user" are resolved to user\'s home '
                "directory. Default: %(default)s"
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
        dest="remote_repository",
        help=(
            "Git repository for the configuration. It will be cloned to the "
            "base directory. If the provided URL is an SSH URL for a Git "
            "repository in GitHub, it is converted into an HTTP URL for "
            "cloning and changed back to the SSH one after everything has "
            "been set up correctly. Default: %(default)s"
        ),
    )

    return parser
