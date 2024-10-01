#!/bin/sh

set -e

if [ ! -d ./ssh ]; then
  mkdir ssh
fi
chmod 0700 ./ssh
if [ -f ./ssh/config ]; then
  rm ./ssh/config
fi
touch ./ssh/config
chmod 0600 ./ssh/config
ansible-vault view ./ssh_config >./ssh/config
