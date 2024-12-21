import sys
from abc import ABC, abstractmethod
from typing import Literal

from etc.message_level import MessageLevel
from etc.shell import Shell

Color = Literal[
    "red", "green", "blue", "magenta", "cyan", "light_green", "light_cyan"
]
HIGHLIGHTS: dict[Color, int] = {
    "red": 31,
    "green": 32,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "light_green": 92,
    "light_cyan": 96,
}
RESET = "\033[0m"


class UserInterface(ABC):
    def __init__(self, level: MessageLevel):
        self._level: MessageLevel = level

    @abstractmethod
    def print(self, msg: str):
        pass

    @abstractmethod
    def debug(self, msg: str):
        pass

    @abstractmethod
    def error(self, msg: str):
        pass

    @abstractmethod
    def start_phase(self, msg: str):
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
        self.__shell: Shell = shell
        self.__use_colors = use_colors

    # TODO: Add @override in Python 3.12.
    def print(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        """
        Prints a message to stdout.
        """
        self.__print(msg, level=MessageLevel.INFO, color=None)

    # TODO: Add @override in Python 3.12.
    def debug(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(msg, level=MessageLevel.DEBUG, color=None)

    # TODO: Add @override in Python 3.12.
    def error(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(msg, level=MessageLevel.ERROR, color="red")

    # TODO: Add @override in Python 3.12.
    def start_phase(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(msg, level=MessageLevel.INFO, color="magenta")

    # TODO: Add @override in Python 3.12.
    def start_step(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(
            msg,
            level=MessageLevel.INFO,
            color="blue" if self._level <= MessageLevel.DEBUG else None,
        )

    # TODO: Add @override in Python 3.12.
    def complete_step(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(
            msg,
            level=MessageLevel.INFO,
            color="cyan" if self._level <= MessageLevel.DEBUG else None,
        )

    def __print(self, msg: str, level: MessageLevel, color: Color | None):
        if self._level > level:
            return
        if color is not None and self.__use_colors:
            msg = f"\033[0;{HIGHLIGHTS[color]}m{msg}{RESET}"
        if level >= MessageLevel.WARNING:
            self.__shell.echo(msg, file=sys.stderr)
        else:
            self.__shell.echo(msg)
