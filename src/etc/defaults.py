import sys

from etc.exceptions import UnsupportedPlatformError


DEFAULT_LINUX_BASE_DIRECTORY = "~/etc"
DEFAULT_DARWIN_BASE_DIRECTORY = "~/Preferences"
DEFAULT_CONFIG = "etc.toml"
DEFAULT_REMOTE = "git@github.com:anttikivi/etc.git"


def get_default_base_directory() -> str:
    if sys.platform == "darwin":
        return DEFAULT_DARWIN_BASE_DIRECTORY

    if sys.platform == "linux":
        return DEFAULT_LINUX_BASE_DIRECTORY

    raise UnsupportedPlatformError
