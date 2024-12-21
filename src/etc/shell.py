import shlex
import subprocess
import sys
from typing import TextIO, cast

from etc.message_level import MessageLevel


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
        prompt: str = "+ ",
    ):
        self.__dry_run = dry_run
        self.__verobosity = verbosity
        self.__print_commands = (
            cast(bool, self.__verobosity <= MessageLevel.DEBUG) or dry_run
        )
        self.__print_outputs = cast(
            bool, self.__verobosity <= MessageLevel.TRACE
        )
        self.__prompt = prompt

    def __call__(self, command: list[str]):
        if self.__print_commands:
            self.__echo_command(command)
        if self.__dry_run:
            return
        try:
            _ = subprocess.run(
                command, check=True, capture_output=not self.__print_outputs
            )
            return None
        except subprocess.CalledProcessError as e:
            print(
                (
                    f'Command "{self.__quote_command(command)}" exited '
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
                    f'"{self.__quote_command(command)}": {e.strerror}'
                ),
                file=sys.stderr,
            )
            sys.exit(1)

    def output(self, command: list[str]) -> str:
        if self.__print_commands:
            self.__echo_command(command)
        if self.__dry_run:
            return ""
        try:
            result = subprocess.run(
                command,
                capture_output=True,
                check=True,
                text=True,
            )

            if self.__print_outputs and result.stderr.strip() != "":
                self.__echo_output(result.stderr)
            if self.__print_outputs and result.stdout.strip() != "":
                self.__echo_output(result.stdout)

            return result.stdout
        except subprocess.CalledProcessError as e:
            print(
                (
                    f'Command "{self.__quote_command(command)}" exited with '
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
                    f'"{self.__quote_command(command)}": {e.strerror}'
                ),
                file=sys.stderr,
            )
            sys.exit(1)

    def echo(self, s: str, file: TextIO | None = None):
        if self.__print_commands:
            cmd = ["echo", "-n", s]
            if file is not None and file == sys.stderr:
                cmd.append(">&2")
            self.__echo_command(cmd)
        if file is not None:
            print(s, file=file)
        else:
            print(s)

    def echo_test_e(self, file: str):
        if self.__print_commands:
            self.__echo_command(["[", "-e", file, "]"])

    def __echo_command(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
    ) -> None:
        """
        Echoes a command to command line.
        """
        file = sys.stderr
        if self.__dry_run:
            file = sys.stdout
        print(
            f"{self.__prompt}{self.__quote_command(command=command, env=env)}",
            file=file,
        )
        _ = file.flush()

    def __echo_output(self, s: str):
        print(s, file=sys.stderr)

    def __quote_argument(self, s: str) -> str:
        """
        Gives a shell-escaped version of the argument.
        """
        if "\n" in s or "\033" in s:
            return repr(s)
        if s == ">&2":
            return s
        return shlex.quote(s)

    def __quote_command(
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
