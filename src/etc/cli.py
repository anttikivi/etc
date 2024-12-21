from etc.commands import bootstrap, install
from etc.options import Options, create_parser
from etc.shell import Shell
from etc.ui import MessageLevel, Terminal


def main() -> int:
    args = create_parser().parse_args()

    print(args)

    opts = Options.parse(args)

    shell = Shell(
        dry_run=opts.dry_run,
        print_commands=opts.verbosity <= MessageLevel.DEBUG,
    )
    terminal = Terminal(
        level=opts.verbosity, shell=shell, use_colors=opts.use_colors
    )

    terminal.debug(f"Resolved {opts.base_directory} as the base directory")
    terminal.debug(f"Resolved {opts.config_file} as the configuration file")

    exit_code: int = 0

    # I can use pattern matching as this program is targeted for
    # Python >= 3.11.
    match opts.command:
        case "bootstrap":
            exit_code = bootstrap.run(ui=terminal)
        case "install":
            exit_code = install.run(opts=opts, shell=shell, ui=terminal)
        case _:
            return 1

    return exit_code
