import os
import tomllib
from typing import cast
from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_phase("Starting the install suite")

    # TODO: Maybe check the prerequisites again?

    ui.start_step("Starting to parse the configuration file")
    assert (
        opts.config_file is not None
    ), "the configuration file passed to the install suite is None"

    shell.echo_test_not_f(opts.config_file)
    if not os.path.isfile(opts.config_file):
        ui.error(
            f'The configuration file et "{opts.config_file}" does not exist'
        )
        return 4  # TODO: Or something.

    config = None
    try:
        with open(opts.config_file, "rb") as f:
            try:
                config = tomllib.load(f)
            except tomllib.TOMLDecodeError as e:
                ui.error(
                    f'Failed to parse the configuration from file at "{opts.config_file}": {e}'
                )
                return 1  # TODO: Or something.
    except OSError as e:
        ui.error(
            f'Failed to read the configuration file at "{opts.config_file}": {e}'
        )
        return cast(int, e.errno)
    print(config)

    ui.complete_step("Configuration file parsed")
    return 0
