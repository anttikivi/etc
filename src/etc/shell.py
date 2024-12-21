import shlex
import sys
from typing import TextIO


class Shell:
    """
    Shell executes the commands run by this script. Because it also
    prints the commands that would be run, all actions should be handled
    through an instance of this class.
    """

    def __init__(self, dry_run: bool, print_commands: bool):
        self.__dry_run = dry_run
        self.__print_commands = print_commands

    # TODO: Add option for file.
    def echo(self, s: str, file: TextIO | None = None):
        if self.__dry_run or self.__print_commands:
            self._echo_command(["echo", "-n", s])
        if file is not None:
            print(s, file=file)
        else:
            print(s)

    def _echo_command(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
        prompt: str = "+ ",
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
        print(prompt + " ".join(output), file=file)
        _ = file.flush()

    def _quote(self, s: str) -> str:
        """
        Gives a shell-escaped version of the argument.
        """
        if "\033" in s:
            return repr(s)
        return shlex.quote(s)
