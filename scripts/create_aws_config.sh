#!/bin/sh

set -e

if [ ! -d ./aws ]; then
  mkdir aws
fi
chmod 0700 ./aws
if [ -f ./aws/config ]; then
  rm ./aws/config
fi
touch ./aws/config
chmod 0600 ./aws/config
ansible-vault view ./aws_config >./aws/config
