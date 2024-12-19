from enum import Enum
from typing import Literal, Self


Color = Literal["magenta", "cyan", "light_cyan"]
HIGHLIGHTS: dict[Color, int] = {"magenta": 35, "cyan": 36, "light_cyan": 96}
RESET = "\033[0m"


class Level(Enum):
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
            if value > Level.ERROR.value:
                value = Level.ERROR.value
            elif value < Level.TRACE.value:
                value = Level.TRACE.value
            return Level(value)
        return NotImplemented

    def __sub__(self, other: Self):
        if self.__class__ is other.__class__:
            value = self.value - other.value
            if value > Level.ERROR.value:
                value = Level.ERROR.value
            elif value < Level.TRACE.value:
                value = Level.TRACE.value
            return Level(value)
        return NotImplemented


class Terminal:
    """
    Terminal is a utility class for interacting with the terminal.

    The functions in this class that are used for debugging are separated into
    two categories: functions based on logging level and functions based on use
    case. The functions based on use case have default colors and are printed as
    INFO level messages by default. The functions based on the logging level can
    be considered to be lower level and take a color as an argument.
    """

    def __init__(self, colors: bool, level: Level):
        self.__level = level
        self.__use_colors = colors

    def out(self, msg: str):
        """
        Prints a message to stdout.
        """
        self.__print(msg, level=Level.INFO, color=None)

    def debug(self, msg: str):
        self.__print(msg, level=Level.DEBUG, color=None)

    def start_task(self, msg: str):
        self.__print(msg, level=Level.INFO, color="magenta")

    def __print(self, msg: str, level: Level, color: Color | None):
        if self.__level > level:
            return
        if color is not None:
            msg = f"\033[{HIGHLIGHTS[color]}m{msg}{RESET}"
        print(msg)
