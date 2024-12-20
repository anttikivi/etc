import os
from typing import cast

from etc.args import Command, create_parser
from etc.commands import bootstrap, install
from etc.context import Context
from etc.shell import Shell
from etc.ui import MessageLevel, Terminal


def main() -> int:
    args = create_parser().parse_args()

    print(args)
    command = cast(Command | None, args.command)
    colors = cast(bool | None, args.colors)
    if colors is None:
        # TODO: Use a better way to determine the default value.
        colors = True
    verbosity = MessageLevel.INFO - MessageLevel(cast(int, args.verbose))
    base_directory = os.path.expandvars(
        os.path.expanduser(cast(str, args.base_directory))
    )
    if not os.path.isabs(base_directory):
        base_directory = os.path.abspath(base_directory)
    config = os.path.expandvars(os.path.expanduser(cast(str, args.config)))
    if not os.path.isabs(config):
        config = os.path.normpath(os.path.join(base_directory, config))

    shell = Shell(
        dry_run=cast(bool, args.dry_run),
        print_commands=cast(MessageLevel, verbosity) <= MessageLevel.DEBUG,
    )

    terminal = Terminal(colors=colors, level=verbosity, shell=shell)

    terminal.debug(f"Resolved {base_directory} as the base directory")
    terminal.debug(f"Resolved {config} as the configuration file")

    ctx = Context(
        shell=shell, ui=terminal, base_directory=base_directory, config=config
    )

    exit_code: int = 0

    # I can use pattern matching as this program is targeted for Python >= 3.11.
    match command:
        case "bootstrap":
            exit_code = bootstrap.run(ui=ctx.ui)
        case "install":
            exit_code = install.run(ui=ctx.ui, ctx=ctx)
        case _:
            return 1

    return exit_code
