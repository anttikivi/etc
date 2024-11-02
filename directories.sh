ETC_DIR="${HOME}/etc"
if [ "$(uname)" = "Darwin" ]; then
  ETC_DIR="${HOME}/Preferences"
fi
export ETC_DIR
