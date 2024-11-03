BUILD_DIR="${HOME}/build"
if [ "$(uname)" = "Darwin" ]; then
  BUILD_DIR="${HOME}/Build"
fi
export BUILD_DIR

ETC_DIR="${HOME}/etc"
if [ "$(uname)" = "Darwin" ]; then
  ETC_DIR="${HOME}/Preferences"
fi
export ETC_DIR

LOCAL_DIR="${HOME}/.local"
export LOCAL_DIR

PROJECT_DIR="${HOME}/projects"
if [ "$(uname)" = "Darwin" ]; then
  PROJECT_DIR="${HOME}/Projects"
fi
export PROJECT_DIR

TMP_DIR="${HOME}/tmp"
export TMP_DIR

UNIVERSITY_PROJECT_DIR="${PROJECT_DIR}/university"
if [ "$(uname)" = "Darwin" ]; then
  UNIVERSITY_PROJECT_DIR="${PROJECT_DIR}/University"
fi
export UNIVERSITY_PROJECT_DIR

VISIOSTO_PROJECT_DIR="${PROJECT_DIR}/visiosto"
if [ "$(uname)" = "Darwin" ]; then
  VISIOSTO_PROJECT_DIR="${PROJECT_DIR}/Visiosto"
fi
export VISIOSTO_PROJECT_DIR
