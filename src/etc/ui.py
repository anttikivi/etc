from abc import ABC, abstractmethod
import sys
from enum import Enum
from typing import Literal, Self

from etc.shell import Shell


Color = Literal["red", "magenta", "cyan", "light_cyan"]
HIGHLIGHTS: dict[Color, int] = {"red": 31, "magenta": 35, "cyan": 36, "light_cyan": 96}
RESET = "\033[0m"


class MessageLevel(Enum):
    """
    The so-called logging level for messages that are shown to the user using
    a user interface.
    """

    TRACE = 0
    DEBUG = 1
    INFO = 2
    WARNING = 3
    ERROR = 4

    def __ge__(self, other: Self):
        if self.__class__ is other.__class__:
            return self.value >= other.value
        return NotImplemented

    def __gt__(self, other: Self):
        if self.__class__ is other.__class__:
            return self.value > other.value
        return NotImplemented

    def __le__(self, other: Self):
        if self.__class__ is other.__class__:
            return self.value <= other.value
        return NotImplemented

    def __lt__(self, other: Self):
        if self.__class__ is other.__class__:
            return self.value < other.value
        return NotImplemented

    def __add__(self, other: Self):
        if self.__class__ is other.__class__:
            value = self.value + other.value
            if value > MessageLevel.ERROR.value:
                value = MessageLevel.ERROR.value
            elif value < MessageLevel.TRACE.value:
                value = MessageLevel.TRACE.value
            return MessageLevel(value)
        return NotImplemented

    def __sub__(self, other: Self):
        if self.__class__ is other.__class__:
            value = self.value - other.value
            if value > MessageLevel.ERROR.value:
                value = MessageLevel.ERROR.value
            elif value < MessageLevel.TRACE.value:
                value = MessageLevel.TRACE.value
            return MessageLevel(value)
        return NotImplemented


class UserInterface(ABC):
    def __init__(self, colors: bool, level: MessageLevel):
        self._level: MessageLevel = level
        self._use_colors: bool = colors

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
    def start_task(self, msg: str):
        pass


class Terminal(UserInterface):
    """
    Terminal is a utility class for interacting with the terminal.

    The functions in this class that are used for debugging are separated into
    two categories: functions based on logging level and functions based on use
    case. The functions based on use case have default colors and are printed as
    INFO level messages by default. The functions based on the logging level can
    be considered to be lower level and take a color as an argument.
    """

    def __init__(self, colors: bool, level: MessageLevel, shell: Shell):
        super().__init__(colors=colors, level=level)
        self.__shell: Shell = shell

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
    def start_task(self, msg: str):  # pyright: ignore [reportImplicitOverride]
        self.__print(msg, level=MessageLevel.INFO, color="magenta")

    def __print(self, msg: str, level: MessageLevel, color: Color | None):
        if self._level > level:
            return
        if color is not None:
            msg = f"\033[{HIGHLIGHTS[color]}m{msg}{RESET}"
        if level >= MessageLevel.WARNING:
            print(msg, file=sys.stderr)
        else:
            self.__shell.echo(msg)
