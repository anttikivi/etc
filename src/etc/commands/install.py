from etc.context import Context
from etc.terminal import Terminal


def run(ctx: Context, terminal: Terminal) -> int:
    terminal.out(f"Installing from the directory: {ctx.base_directory}")
    terminal.start_task("Starting the installation suite")
    return 0
