from etc.terminal import Terminal


class Context:
    """
    Context represents the context for a single run of the program.
    """

    def __init__(self, terminal: Terminal, base_directory: str):
        self.__terminal = terminal
        self.__base_directory = base_directory

    @property
    def base_directory(self) -> str:
        return self.__base_directory

    @property
    def terminal(self) -> Terminal:
        return self.__terminal
