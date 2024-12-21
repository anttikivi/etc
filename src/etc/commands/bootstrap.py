import os

from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_task("Starting to bootstrap to configuration")

    assert (
        opts.base_directory is not None
    ), "the base directory passed to bootstrapping is None"

    shell.echo_test_e(opts.base_directory)
    if os.path.exists(opts.base_directory):
        ui.error(
            f"The configuration directory at {opts.base_directory} exists"
        )
        ui.error("Bootstrapping must be done using a clean installation")
        return 1

    assert (
        opts.remote_repository_url is not None
    ), "the remote repository URL passed to bootstrapping is None"

    # Check if the given remote URL is an SSH URL. If so, it needs to be
    # converted to HTTPS URL for the initial clone. It will be changed
    # back later.
    remote_url = opts.remote_repository_url
    if remote_url.startswith("git@github.com:"):
        _, repo_name = remote_url.split(":")
        remote_url = f"https://github.com/{repo_name}"

    return 0
