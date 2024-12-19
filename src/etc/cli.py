import os
from typing import cast

from etc.commands import bootstrap, install
from etc.context import Context
from etc.parser import Command, create_parser
from etc.terminal import Level, Terminal


def main() -> int:
    args = create_parser().parse_args()

    print(args)
    command = cast(Command | None, args.command)
    colors = cast(bool | None, args.colors)
    if colors is None:
        # TODO: Use a better way to determine the default value.
        colors = True
    verbosity = Level.INFO - Level(cast(int, args.verbose))
    base_directory = os.path.expandvars(
        os.path.expanduser(cast(str, args.base_directory))
    )
    if not os.path.isabs(base_directory):
        base_directory = os.path.abspath(base_directory)
    config = os.path.expandvars(os.path.expanduser(cast(str, args.config)))
    if not os.path.isabs(config):
        config = os.path.normpath(os.path.join(base_directory, config))

    terminal = Terminal(colors=colors, level=verbosity)

    terminal.debug(f"Resolved {base_directory} as the base directory")
    terminal.debug(f"Resolved {config} as the configuration file")

    ctx = Context(terminal=terminal, base_directory=base_directory, config=config)

    exit_code: int = 0

    # I can use pattern matching as this program is targeted for Python >= 3.11.
    match command:
        case "bootstrap":
            exit_code = bootstrap.run(terminal=ctx.terminal)
        case "install":
            exit_code = install.run(terminal=ctx.terminal, ctx=ctx)
        case _:
            return 1

    return exit_code
