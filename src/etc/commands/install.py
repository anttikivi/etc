from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_phase("Starting the installation suite")
    return 0
