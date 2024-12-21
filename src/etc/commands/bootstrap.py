from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_task("Starting to bootstrap to configuration")
    if opts.base_directory is None:
        raise ValueError
    if shell.test_e(opts.base_directory):
        ui.error(
            f"The configuration directory at {opts.base_directory} exists"
        )
        ui.error("Bootstrapping must be done using a clean installation")
    return 1
