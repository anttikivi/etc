from typing import Literal, Required, TypedDict


StepDirective = Literal["packages"]

_DarwinPackages = TypedDict(
    "_DarwinPackages", {"formulae": list[str], "casks": list[str]}
)

_PackagesStep = TypedDict(
    "_PackagesStep",
    {"directive": Required[StepDirective], "darwin": _DarwinPackages},
)


_InstallConfig = TypedDict(
    "_InstallConfig", {"steps": list[_PackagesStep]}, total=False
)


class Config(TypedDict, total=False):
    install: _InstallConfig
