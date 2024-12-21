import shlex
import subprocess
import sys
from typing import TextIO, cast

from etc.message_level import MessageLevel


class _Echo:
    """
    Utility that handles the echoing for the shell type.

    The classes are separated so that the shell type focuses on the
    command execution and the echo type handles the information related
    to what gets printed and how.
    """

    def __init__(
        self,
        dry_run: bool,
        verbosity: MessageLevel,
        print_commands: bool,
        prompt: str = "+ ",
    ):
        self.verobosity: MessageLevel = verbosity
        self.print_commands: bool = print_commands
        self._dry_run: bool = dry_run
        self._prompt: str = prompt

    def __call__(self, s: str, file: TextIO | None = None):
        if self.print_commands:
            cmd = ["echo", "-n", s]
            if file is not None and file == sys.stderr:
                cmd.append(">&2")
            self.command(cmd)
        if file is not None:
            print(s, file=file)
        else:
            print(s)

    def command(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
    ) -> None:
        """
        Echoes a command to command line.
        """
        file = sys.stderr
        if self._dry_run:
            file = sys.stdout
        print(
            f"{self._prompt}{self.quote_command(command=command, env=env)}",
            file=file,
        )
        _ = file.flush()

    def command_output(self, s: str):
        print(s, file=sys.stderr)

    def quote_command(
        self, command: list[str], env: dict[str, str] | None = None
    ) -> str:
        output: list[str] = []
        if env is not None:
            output.extend(
                [
                    self.__quote_argument(f"{name}={value}")
                    for name, value in sorted(env.items())
                ]
            )
        output.extend([self.__quote_argument(s) for s in command])
        return " ".join(output)

    def test_e(self, file: str):
        if self.print_commands:
            self.command(["[", "-e", file, "]"])

    def __quote_argument(self, s: str) -> str:
        """
        Gives a shell-escaped version of the argument.
        """
        if "\n" in s or "\033" in s:
            return repr(s)
        if s == ">&2":
            return s
        return shlex.quote(s)


class Shell:
    """
    Shell executes the commands run by this script. Because it also
    prints the commands that would be run, all actions should be handled
    through an instance of this class.
    """

    def __init__(
        self,
        dry_run: bool,
        verbosity: MessageLevel,
    ):
        self._echo: _Echo = _Echo(
            dry_run=dry_run,
            verbosity=verbosity,
            print_commands=verbosity <= MessageLevel.TRACE or dry_run,
            prompt="+ ",
        )
        self._dry_run: bool = dry_run
        self._print_outputs: bool = verbosity <= MessageLevel.TRACE

    def __call__(self, command: list[str], allow_output: bool | None = None):
        if self._echo.print_commands:
            self._echo.command(command)
        if self._dry_run:
            return
        disable_output = not self._print_outputs
        if allow_output is not None:
            disable_output = not allow_output
        try:
            _ = subprocess.run(
                command, check=True, capture_output=disable_output
            )
            return None
        except subprocess.CalledProcessError as e:
            print(
                (
                    f'Command "{self._echo.quote_command(command)}" exited '
                    f"with code {e.returncode}"
                ),
                file=sys.stderr,
            )
            print("\nstdout:\n")
            print(cast(str, e.stdout))
            print("\nstderr:\n")
            print(cast(str, e.stderr))
            sys.exit(e.returncode)
        except OSError as e:
            print(
                (
                    "Could not run command "
                    f'"{self._echo.quote_command(command)}": {e.strerror}'
                ),
                file=sys.stderr,
            )
            sys.exit(1)

    def output(self, command: list[str]) -> str:
        if self._echo.print_commands:
            self._echo.command(command)
        if self._dry_run:
            return ""
        try:
            result = subprocess.run(
                command,
                capture_output=True,
                check=True,
                text=True,
            )

            if self._print_outputs and result.stderr.strip() != "":
                self._echo.command_output(result.stderr)
            if self._print_outputs and result.stdout.strip() != "":
                self._echo.command_output(result.stdout)

            return result.stdout
        except subprocess.CalledProcessError as e:
            print(
                (
                    f'Command "{self._echo.quote_command(command)}" exited with '
                    f"code {e.returncode}\nThe following output was captured:"
                ),
                file=sys.stderr,
            )
            print("\nstdout:\n")
            print(cast(str, e.stdout))
            print("\nstderr:\n")
            print(cast(str, e.stderr))
            sys.exit(e.returncode)
        except OSError as e:
            print(
                (
                    "Could not run command "
                    f'"{self._echo.quote_command(command)}": {e.strerror}'
                ),
                file=sys.stderr,
            )
            sys.exit(1)

    @property
    def echo(self) -> _Echo:
        return self._echo
