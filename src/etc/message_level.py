from enum import Enum
from typing import Self


class MessageLevel(Enum):
    """
    The so-called logging level for messages that are shown to the user
    using a user interface.
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
