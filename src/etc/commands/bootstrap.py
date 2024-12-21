import os

from etc.commands import install
from etc.message_level import MessageLevel
from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface


def run(opts: Options, shell: Shell, ui: UserInterface) -> int:
    ui.start_phase("Starting to bootstrap to configuration")

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

    ui.start_step("Cloning the remote directory")
    ui.debug(f'Cloning from "{remote_url}" to "{opts.base_directory}"')
    _ = shell(["git", "clone", remote_url, opts.base_directory])
    ui.complete_step("Repository cloned")

    install_exit_code = install.run(opts=opts, shell=shell, ui=ui)
    if install_exit_code != 0:
        ui.error(f"The installation failed with the code {install_exit_code}")
        return install_exit_code

    ui.start_step("Changing the remote URL for the local repository")
    ui.trace("Checking the current remote URL for origin")
    result = shell.output(
        ["git", "-C", opts.base_directory, "remote", "get-url", "origin"]
    )
    current_remote = result.strip()
    ui.trace(f"Got {current_remote} as the current remote URL")
    if current_remote != opts.remote_repository_url:
        shell(
            [
                "git",
                "-C",
                opts.base_directory,
                "remote",
                "set-url",
                "origin",
                opts.remote_repository_url,
            ]
        )
    ui.debug(
        "The remote URLs of the local repository are now set to:", bold=True
    )
    shell(
        ["git", "-C", opts.base_directory, "remote", "-v"],
        allow_output=opts.verbosity <= MessageLevel.DEBUG,
    )
    ui.debug("Fetching the remote")
    shell(["git", "-C", opts.base_directory, "fetch"])

    ui.debug("The status of the repository now is:", bold=True)
    shell(
        ["git", "-C", opts.base_directory, "status"],
        allow_output=opts.verbosity <= MessageLevel.DEBUG,
    )

    return 0
