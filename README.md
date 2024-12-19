# Dotfiles

This is the Git reposiory for my workstation configuration and configuration
files. The goal of this configuration is to automate setting up and updating
programs and configurations on the workstations I use.

The configuration system is currently under a revamp. The configuration will be
installed using a Python script at [`src/etc`](src/etc) (the program is called
`etc`) that takes care of setting up and updating the environment and the
required software. The first run is done through the [`install`](install) script
that installs `pyenv`, Python, and `pipx`. `pipx` is used to install `etc` that
handles setting up the environment. After the first run, `etc` takes over and
can be used for subsequent runs.

## Bootstrapping

Run the following command:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/anttikivi/etc/main/install)"

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for
more information.
