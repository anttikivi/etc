from etc.terminal import Terminal


class Context:
    """
    Context represents the context for a single run of the program. To preserve
    locality, the context takes most of its input values as they are instead of
    resolving them. The values should thus be resolved correctly values before
    they are passed to the context.
    """

    def __init__(self, terminal: Terminal, base_directory: str, config: str):
        self.__terminal = terminal
        self.__base_directory = base_directory
        self.__config = config

    @property
    def base_directory(self) -> str:
        return self.__base_directory

    @property
    def terminal(self) -> Terminal:
        return self.__terminal
