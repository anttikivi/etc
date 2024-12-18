class Terminal:
    """
    Terminal is a utility class for interacting with the terminal.
    """

    def __init__(self):
        pass

    def out(self, msg: str):
        """
        Prints a message to stdout.
        """
        self.__print(msg)

    def __print(self, msg: str):
        # TODO: Implement colors, levels, and output destinations properly.
        print(msg)
