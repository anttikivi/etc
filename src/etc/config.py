from typing import Literal, Required, TypedDict


_DarwinPackages = TypedDict(
    "_DarwinPackages", {"formulae": list[str], "casks": list[str]}
)

_PackagesStep = TypedDict(
    "_PackagesStep",
    {"type": Required[Literal["packages"]], "darwin": _DarwinPackages},
)


_InstallConfig = TypedDict(
    "_InstallConfig", {"steps": list[_PackagesStep]}, total=False
)


class Config(TypedDict, total=False):
    install: _InstallConfig
