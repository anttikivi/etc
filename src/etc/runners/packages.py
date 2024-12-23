import sys

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


class PackagesRunner(StepRunner):
    def __init__(self, opts: Options, shell: Shell, ui: UserInterface) -> None:
        super().__init__("packages", opts, shell, ui)

    @override
    def run(self) -> int:
        self._ui.start_step(
            f'Invoking the runner for step with the "{self.directive}"'
        )
        return 0
