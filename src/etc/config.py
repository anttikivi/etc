from typing import Literal, Required, TypedDict


Platform = Literal["darwin"]

StepDirective = Literal["system-packages", "packages"]

# Packages can be declared either as a list of package names or as
# key-value pairs where the key is the name of the package and the value
# is the wanted version. If only a list of strings is given, the latest
# versions will be used. Latest version will also be used if the given
# version string is empty.
PackagesDeclaration = list[str] | dict[str, str]

PlatformPackagesConfig = PackagesDeclaration

DarwinPackagesConfig = TypedDict(
    "DarwinPackagesConfig",
    {"formulae": PackagesDeclaration, "casks": PackagesDeclaration},
    total=False,
)

_SystemPackagesPlatformsConfig = TypedDict(
    "_SystemPackagesPlatformsConfig",
    {
        "all": PlatformPackagesConfig,
        "darwin": PlatformPackagesConfig | DarwinPackagesConfig,
    },
    total=False,
)


class StepConfig(TypedDict, total=False):
    directive: Required[StepDirective]


class SystemPackagesStepConfig(StepConfig):
    directive: Required[StepDirective]
    packages: PackagesDeclaration
    platforms: _SystemPackagesPlatformsConfig


_InstallConfig = TypedDict(
    "_InstallConfig", {"steps": list[SystemPackagesStepConfig]}, total=False
)


class Config(TypedDict, total=False):
    install: _InstallConfig
