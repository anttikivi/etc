import tomllib
from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_phase("Starting the install suite")

    # TODO: Maybe check the prerequisites again?

    assert (
        opts.config_file is not None
    ), "the configuration file passed to the install suite is None"
    cfg = None
    with open(opts.config_file, "rb") as f:
        cfg = tomllib.load(f)
    print(cfg)
    return 0
