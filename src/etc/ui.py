import sys
from abc import ABC, abstractmethod
from typing import Literal

from etc.message_level import MessageLevel
from etc.shell import Shell

if sys.version_info >= (3, 12):
    from typing import override
else:
    from typing import Any, Callable

    _Func = Callable[..., Any]

    # Fallback for Python 3.11 and earlier.
    def override(method: _Func, /) -> _Func:  # pyright: ignore[reportUnreachable]
        return method


Color = Literal[
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "light_green",
    "light_cyan",
]
HIGHLIGHTS: dict[Color, int] = {
    "red": 31,
    "green": 32,
    "yellow": 33,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "light_green": 92,
    "light_cyan": 96,
}
RESET = "\033[0m"
BOLD = "\033[1m"
UNDERLINE = "\033[4m"


class UserInterface(ABC):
    def __init__(self, level: MessageLevel):
        self._level: MessageLevel = level

    @abstractmethod
    def print(self, msg: str):
        pass

    @abstractmethod
    def trace(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        pass

    @abstractmethod
    def debug(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        pass

    @abstractmethod
    def warning(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        pass

    @abstractmethod
    def error(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        pass

    @abstractmethod
    def start_phase(self, msg: str):
        pass

    @abstractmethod
    def complete_phase(self, msg: str):
        pass

    @abstractmethod
    def start_step(self, msg: str):
        pass

    @abstractmethod
    def complete_step(self, msg: str):
        pass


class Terminal(UserInterface):
    """
    Terminal is a utility class for interacting with the terminal.

    The functions in this class that are used for debugging are
    separated into two categories: functions based on logging level and
    functions based on use case. The functions based on use case have
    default colors and are printed as INFO level messages by default.
    The functions based on the logging level can be considered to be
    lower level and take a color as an argument.
    """

    def __init__(self, level: MessageLevel, shell: Shell, use_colors: bool):
        super().__init__(level=level)
        self._shell: Shell = shell
        self._use_colors: bool = use_colors

    @override
    def print(self, msg: str):
        """
        Prints a message to stdout.
        """
        self._print(msg, level=MessageLevel.INFO)

    @override
    def trace(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        self._print(
            msg,
            level=MessageLevel.TRACE,
            bold=bold,
            underline=underline,
        )

    @override
    def debug(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        self._print(
            msg,
            level=MessageLevel.DEBUG,
            bold=bold,
            underline=underline,
        )

    @override
    def warning(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        self._print(
            msg,
            level=MessageLevel.ERROR,
            color="yellow",
            bold=bold,
            underline=underline,
        )

    @override
    def error(
        self, msg: str, bold: bool | None = None, underline: bool | None = None
    ):
        self._print(
            msg,
            level=MessageLevel.ERROR,
            color="red",
            bold=bold,
            underline=underline,
        )

    @override
    def start_phase(self, msg: str):
        self._print(msg, level=MessageLevel.INFO, color="magenta")

    @override
    def complete_phase(self, msg: str):
        self._print(msg, level=MessageLevel.INFO, color="green")

    @override
    def start_step(self, msg: str):
        self._print(
            msg,
            level=MessageLevel.INFO,
            color="blue" if self._level <= MessageLevel.DEBUG else None,
        )

    @override
    def complete_step(self, msg: str):
        self._print(
            msg,
            level=MessageLevel.INFO,
            color="cyan" if self._level <= MessageLevel.DEBUG else None,
        )

    def _print(
        self,
        msg: str,
        level: MessageLevel,
        color: Color | None = None,
        bold: bool | None = None,
        underline: bool | None = None,
    ):
        if self._level > level:
            return
        reset: bool = False
        if color is not None and self._use_colors:
            msg = f"\033[{HIGHLIGHTS[color]}m{msg}"
            reset = True
        if bold and self._use_colors:
            msg = f"{BOLD}{msg}"
            reset = True
        if underline and self._use_colors:
            msg = f"{UNDERLINE}{msg}"
            reset = True
        if reset:
            msg = f"{msg}{RESET}"
        if level >= MessageLevel.WARNING:
            self._shell.echo(msg, file=sys.stderr)
        else:
            self._shell.echo(msg)
