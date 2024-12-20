from etc.shell import Shell
from etc.ui import UserInterface


class Context:
    """
    Context represents the context for a single run of the program. To preserve
    locality, the context takes most of its input values as they are instead of
    resolving them. The values should thus be resolved correctly values before
    they are passed to the context.
    """

    def __init__(
        self, shell: Shell, ui: UserInterface, base_directory: str, config: str
    ):
        self.__shell = shell
        self.__ui = ui
        self.__base_directory = base_directory
        self.__config = config

    @property
    def base_directory(self) -> str:
        return self.__base_directory

    @property
    def shell(self) -> Shell:
        return self.__shell

    @property
    def ui(self) -> UserInterface:
        return self.__ui
