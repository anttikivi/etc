from etc.context import Context
from etc.ui import UserInterface


def run(ctx: Context, ui: UserInterface) -> int:
    ui.start_task("Starting the installation suite")
    return 0
