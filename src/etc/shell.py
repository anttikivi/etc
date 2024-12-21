import os
import shlex
import sys
from typing import TextIO


class Shell:
    """
    Shell executes the commands run by this script. Because it also
    prints the commands that would be run, all actions should be handled
    through an instance of this class.
    """

    def __init__(
        self, dry_run: bool, print_commands: bool, prompt: str = "+ "
    ):
        self.__dry_run = dry_run
        self.__print_commands = print_commands or dry_run
        self.__prompt = prompt

    # TODO: Add option for file.
    def echo(self, s: str, file: TextIO | None = None):
        if self.__print_commands:
            cmd = ["echo", "-n", s]
            if file is not None and file == sys.stderr:
                cmd.append(">&2")
            self._echo_command(cmd)
        if file is not None:
            print(s, file=file)
        else:
            print(s)

    def test_e(self, file: str) -> bool:
        if self.__print_commands:
            self._echo_command(["[", "-e", file, "]"])
        return os.path.exists(file)

    def test_not_e(self, file: str) -> bool:
        if self.__print_commands:
            self._echo_command(["[", "!", "-e", file, "]"])
        return not os.path.exists(file)

    def _echo_command(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
    ) -> None:
        """
        Echoes a command to command line.
        """
        output: list[str] = []
        if env is not None:
            output.extend(
                [
                    self._quote(f"{name}={value}")
                    for name, value in sorted(env.items())
                ]
            )
        output.extend([self._quote(s) for s in command])
        file = sys.stderr
        if self.__dry_run:
            file = sys.stdout
        print(self.__prompt + " ".join(output), file=file)
        _ = file.flush()

    def _quote(self, s: str) -> str:
        """
        Gives a shell-escaped version of the argument.
        """
        if "\033" in s:
            return repr(s)
        if s == ">&2":
            return s
        return shlex.quote(s)
