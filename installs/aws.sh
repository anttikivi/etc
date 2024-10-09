#!/bin/sh

set -e

not_supported() {
  echo "This system is not supported: $*" >&2
  exit 1
}

os_name="$(uname)"

if [ "${HAS_CONNECTION}" = "true" ]; then
  if [ "${os_name}" = "Darwin" ]; then
    if ! command -v aws >/dev/null 2>&1 || [ "${DO_UPDATES}" = "true" ]; then
      tmp_dir="${HOME}/tmp/awscli"
      pkg_file="${tmp_dir}/AWSCLIV2.pkg"
      curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "${pkg_file}"
      installer -pkg "${pkg_file}" -target CurrentUserHomeDirectory -applyChoiceChangesXML ../templates/aws_cli_choices.xml
      ln -s ~/.local/opt/aws-cli/aws ~/.local/bin/aws
      ln -s ~/.local/opt/aws-cli/aws_completer ~/.local/bin/aws_completer
      rm -rf "${tmp_dir}"
    fi
  elif [ "${os_name}" = "Linux" ]; then
    distro="$(cat /etc/*-release | grep ^ID | head -n1 | cut -d '=' -f2)"
    if [ "${distro}" = "debian" ]; then
      not_supported "${os_name}" "${distro}"
    elif [ "${distro}" = "ubuntu" ]; then
      not_supported "${os_name}" "${distro}"
    else
      not_supported "${os_name}" "${distro}"
    fi
  else
    not_supported "${os_name}"
  fi
fi
