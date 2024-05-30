# Dotfiles

This is the Git reposiory for my workstation configuration and configuration
files. The goal of this configuration is to automate setting up and updating
programs and configurations on the workstations I use.

The repository uses [Ansible](https://www.ansible.com) for automation.

## Getting started

### Prerequisites

The script and the Ansible playbook are structured to automatically detect and
run the set-up for correct operating system. However, only Darwin (macOS) is
currently supported.

Besides your computer, you only need to have a shell for running the `install`
script.

### Installing

The repository includes a shell script at [`bin/install`](bin/install) that
initializes the environment, install all of the requirements and runs the
Ansible playbook. The script should be
[POSIX-compliant](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html).

    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/anttikivi/dotfiles/main/bin/install)"

If you don’t have `curl` or you wish to download the script separately before
running it, that’s also possible.

    curl -OL https://raw.githubusercontent.com/anttikivi/dotfiles/main/bin/install
    chmod +x install
    ./install

> Don’t mind the `curl` command here, you can download the script however you
> like.

For subsequent runs, you can either run the `bin/install` script again or run
the Ansible playbook.

    cd ~/dotfiles
    ansible-playbook local.yml -K

Even though the script clones a temporary copy of this repository for the
duration of the script run, the Ansible playbook also clones this repository
using SSH to `~/dotfiles`. While the playbook mostly copies all of the
configuration to their correct locations on your machine, some of the files are
added as symbolic link that point to this repository at `~/dotfiles`, namely
[Neovim](https://neovim.io) configuration. This is done because Neovim
configuration files are usually actively developed and require debugging when
changes are made and using symbolic links makes this easier. This also lets me
to keep up-to-date version of the
[`lazy.nvim`](https://github.com/folke/lazy.nvim) lockfile within the
repository. The [Oh My Zsh](https://ohmyz.sh) customization directory
environment variable, `$ZSH_CUSTOM` in `.zshrc`, is also pointed to the
repository, namely to `$HOME/dotfiles/zsh`.

Below is a breakdown of the different steps the script takes for each supported
operating system.

#### Darwin

First of all, the script mostly assumes that you’re running on macOS if you’re
using a Darwin operating system.

The script does the following steps:

1. Install [Homebrew](https://brew.sh) if it’s not installed.
2. Install [Python](https://www.python.org) if it’s not installed.
3. Install [Ansible](https://www.ansible.com) if it’s not installed.
4. Clone a temporary copy of this repository for use during the playbook run.
   The temporary clone is removed by the script after a successful playbook run.
5. Install [Ansible Galaxy](https://galaxy.ansible.com/) dependencies.
6. Run the Ansible playbook.

## Development

The repository features a [`Makefile`](Makefile) for automating some common
tasks. Run `make fmt` to format the code and `make lint` to lint the code.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE)
file for more information.
