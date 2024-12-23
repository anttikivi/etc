import sys
from abc import ABC, abstractmethod

from etc.config import StepDirective
from etc.options import Options
from etc.shell import Shell
from etc.ui import UserInterface

if sys.version_info >= (3, 12):
    from typing import override
else:
    from typing import Any, Callable

    _Func = Callable[..., Any]

    # Fallback for Python 3.11 and earlier.
    def override(method: _Func, /) -> _Func:  # pyright: ignore[reportUnreachable]
        return method


class StepRunner(ABC):
    """
    StepRunner is the abstract base class for the install steps runners
    that can be defined in the configuration using the `install.steps`
    key. One step runner corresponds to one directive specified as
    `install.steps.directive`.
    """

    def __init__(
        self,
        directive: StepDirective,
        opts: Options,
        shell: Shell,
        ui: UserInterface,
    ) -> None:
        self.directive: StepDirective = directive

        self._opts: Options = opts
        self._shell: Shell = shell
        self._ui: UserInterface = ui

    @override
    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} '{self.directive}'>"

    def can_handle(self, directive: str) -> bool:
        return directive == self.directive

    @abstractmethod
    def run(self) -> int:
        pass
