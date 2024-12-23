import sys
from typing import cast

from etc.config import (
    DarwinPackagesConfig,
    PackagesDeclaration,
    Platform,
    SystemPackagesStepConfig,
    StepConfig,
)
from etc.options import Options
from etc.shell import Shell
from etc.step_runner import StepRunner
from etc.ui import UserInterface


if sys.version_info >= (3, 12):
    from typing import override
else:
    from typing import Any, Callable

    _Func = Callable[..., Any]

    # Fallback for Python 3.11 and earlier.
    def override(method: _Func, /) -> _Func:  # pyright: ignore[reportUnreachable]
        return method


class SystemPackagesRunner(StepRunner):
    def __init__(self, opts: Options, shell: Shell, ui: UserInterface) -> None:
        super().__init__("system-packages", "packages", opts, shell, ui)

    @override
    def run(self, config: StepConfig) -> int:
        self._ui.start_step(
            (
                f'Invoking the "{self.directive}" runner for the '
                f'"{config["directive"]}" step'
            )
        )
        config = cast(SystemPackagesStepConfig, config)

        self._ui.trace("Created the configuration instance")
        self._ui.trace(f"Received the following configuration: {config}")

        # Populate the packages first from the `packages` list. If the
        # key does not exist, this the packages are set to an empty
        # dictionary by default and updated later with the packages from
        # `platforms.all`.
        all_packages: PackagesDeclaration = {}
        self._ui.trace("Created the `all_packages` instance")
        if "packages" in config:
            self._ui.debug(
                'Found the key "packages" in the system packages step'
            )
            all_packages = config["packages"]

        self._ui.trace(
            (
                "After populating from `packages`, `all_packages` is now "
                f"{all_packages}"
            )
        )

        # Convert the packages to a dict if they are given as a list.
        if type(all_packages) is list:
            self._ui.trace("`all_packages` is a list")
            all_packages = {pkg: "" for pkg in all_packages}
        self._ui.trace(
            (
                "`all_packages` is now converted to a dictionary and is "
                f"{all_packages}"
            )
        )

        # `all_packages` should always be a dictionary at this point.
        # The LSP understands the assert statement, so it is placed here
        # for convenience.
        assert (
            type(all_packages) is dict
        ), 'variable "all_packages" is not a dictionary'

        self._ui.trace(
            (
                "Assertion for `all_packages` complete, the type is "
                f"{type(all_packages)}"
            )
        )

        platforms_config = None
        self._ui.trace("Created the `platforms_config` configuration instance")
        if "platforms" in config:
            self._ui.debug(
                'Found the key "platforms" in the system packages step'
            )
            platforms_config = config["platforms"]

        self._ui.trace(
            (
                'After populating from "platforms", variable '
                f"`platforms_config` is now {platforms_config}"
            )
        )

        # Start by checking if there are packages to install on all
        # platforms and merge them with the
        if "all" in platforms_config:
            self._ui.debug(
                (
                    'Found the key "all" in the platforms configuration of the '
                    "system packages step"
                )
            )
            platform_all_pkgs = platforms_config["all"]
            if type(platform_all_pkgs) is list:
                platform_all_pkgs = {pkg: "" for pkg in platform_all_pkgs}
            self._ui.trace(
                (
                    'After populating from "platforms.all", variable '
                    f"`platform_all_pkgs` is now {platform_all_pkgs}"
                )
            )

            # `platform_all_pkgs` should always be a dictionary at this
            # point.
            assert type(platform_all_pkgs) is dict
            all_packages.update(platform_all_pkgs)

        self._ui.trace(
            (
                'After merging with packages from "platforms.all", variable '
                f"`all_packages` is now {all_packages}"
            )
        )

        # TODO: Handle Linux distros.
        self._shell.echo_uname_tr()
        # TODO: Set this at the start of the program run and receive
        # the value from the caller.
        current_platform: Platform = cast(Platform, sys.platform)

        self._ui.trace(f'Resolved "{current_platform}" as the platform')
        self._ui.debug(
            (
                "Checking if there are platform-specific packages for "
                f'"{current_platform}"'
            )
        )

        # Create the instance for casks as it is needed if we are
        # running Darwin.
        all_casks: PackagesDeclaration = {}

        if current_platform in platforms_config:
            self._ui.debug(
                (
                    f'Found the key "{current_platform}" in the platforms '
                    "configuration of the system packages step"
                )
            )
            current_platform_config = platforms_config[current_platform]
            if current_platform == "darwin" and (
                "formulae" in current_platform_config
                or "casks" in current_platform_config
            ):
                current_platform_config = cast(
                    DarwinPackagesConfig, current_platform_config
                )
                # NOTE: This is stupid, but I want to print the
                # granular debug messages.
                if (
                    "formulae" in current_platform_config
                    and "casks" in current_platform_config
                ):
                    self._ui.debug(
                        (
                            'Found the keys "formulae" and "casks" in the platforms configuration of the system packages step'
                        )
                    )
                elif "formulae" in current_platform_config:
                    self._ui.debug(
                        (
                            'Found the key "formulae" in the platforms configuration of the system packages step'
                        )
                    )
                elif "casks" in current_platform_config:
                    self._ui.debug(
                        (
                            'Found the key "casks" in the platforms configuration of the system packages step'
                        )
                    )

                # Populate the packages from `formulae`.
                if "formulae" in current_platform_config:
                    formulae = current_platform_config["formulae"]
                    if type(formulae) is list:
                        formulae = {formula: "" for formula in formulae}
                    self._ui.trace(
                        (
                            "After populating from "
                            '"platforms.darwin.formulae", variable '
                            f"`formulae` is now {formulae}"
                        )
                    )
                    # `formulae` should always be a dictionary at this
                    # point.
                    assert type(formulae) is dict
                    all_packages.update(formulae)

                # Populate the packages from `formulae`.
                if "casks" in current_platform_config:
                    casks = current_platform_config["casks"]
                    if type(casks) is list:
                        casks = {cask: "" for cask in casks}
                    self._ui.trace(
                        (
                            'After populating from "platforms.darwin.casks", '
                            f"variable `casks` is now {casks}"
                        )
                    )
                    # `casks` should always be a dictionary at this
                    # point.
                    assert type(casks) is dict
                    all_casks.update(casks)

            else:
                platform_pkgs: PackagesDeclaration = cast(
                    PackagesDeclaration, platforms_config[current_platform]
                )
                if type(platform_pkgs) is list:
                    platform_pkgs = {pkg: "" for pkg in platform_pkgs}
                self._ui.trace(
                    (
                        "After populating from "
                        f'"platforms.{current_platform}", variable '
                        f"`platform_pkgs` is now {platform_pkgs}"
                    )
                )
                # `platform_all_pkgs` should always be a dictionary at this
                # point.
                assert type(platform_pkgs) is dict
                all_packages.update(platform_pkgs)

        self._ui.trace(
            (
                "After merging with packages from "
                f'"platforms.{current_platform}", variable `all_packages` is '
                f"now {all_packages}"
            )
        )
        if current_platform == "darwin":
            self._ui.trace(
                (
                    "After merging with casks from "
                    f'"platforms.{current_platform}", variable `all_casks` is '
                    f"now {all_casks}"
                )
            )

        return 0
