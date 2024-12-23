import os
from typing import cast

import tomllib

from etc.config import Config
from etc.options import Options
from etc.runners.packages import PackagesRunner
from etc.shell import Shell
from etc.step_runner import StepRunner
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

    config: Config | None = None
    try:
        with open(opts.config_file, "rb") as f:
            try:
                config = cast(Config, cast(object, tomllib.load(f)))
            except tomllib.TOMLDecodeError as e:
                ui.error(
                    msg=(
                        "Failed to parse the configuration from file at "
                        f'"{opts.config_file}": {e}'
                    )
                )
                return 1  # TODO: Or something.
    except OSError as e:
        ui.error(
            msg=(
                "Failed to read the configuration file at "
                f'"{opts.config_file}": {e}'
            )
        )
        return cast(int, e.errno)
    print(config)

    ui.complete_step("Configuration file parsed")
    ui.start_phase("Starting to run the install steps")

    if "install" not in config:
        ui.warning(
            msg=(
                'No "install" key was provided in the configuration file, '
                "thus there are no steps to run"
            )
        )
    if "install" in config and "steps" not in config["install"]:
        ui.warning(
            msg=(
                'No "install.steps" key was provided in the configuration '
                "file, thus there are no steps to run"
            )
        )

    runners: list[StepRunner] = [PackagesRunner(opts, shell, ui)]

    if "install" in config and "steps" in config["install"]:
        for step in config["install"]["steps"]:
            for runner in filter(
                lambda s: s.can_handle(step["directive"]), runners
            ):
                print(runner)

    ui.complete_phase("Install steps run")
    ui.complete_phase("Install suite complete")

    return 0
