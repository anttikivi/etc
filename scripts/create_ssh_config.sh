#!/bin/sh

set -e

if [ ! -d ./ssh ]; then
  mkdir ssh
fi
chmod 0700 ./ssh
if [ -f ./ssh/config ]; then
  rm ./ssh/coonfig
fi
touch ./ssh/config
chmod 0600 ./ssh_config
ansible-vault view ./templates/ssh_config >./ssh/config
