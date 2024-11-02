ETC_DIR="${HOME}/etc"

os_name="$(uname)"
if [ "${os_name}" = "Darwin" ]; then
  ETC_DIR="${HOME}/Preferences"
fi
export ETC_DIR
