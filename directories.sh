#!/bin/sh

BUILD_DIR="${HOME}/build"
if [ "$(uname)" = "Darwin" ]; then
  BUILD_DIR="${HOME}/Build"
fi
readonly BUILD_DIR
export BUILD_DIR

ETC_DIR="${HOME}/etc"
if [ "$(uname)" = "Darwin" ]; then
  ETC_DIR="${HOME}/Preferences"
fi
readonly ETC_DIR
export ETC_DIR

LOCAL_DIR="${HOME}/.local"
readonly LOCAL_DIR
export LOCAL_DIR

LOCAL_BIN_DIR="${LOCAL_DIR}/bin"
readonly LOCAL_BIN_DIR
export LOCAL_BIN_DIR

LOCAL_OPT_DIR="${LOCAL_DIR}/opt"
readonly LOCAL_OPT_DIR
export LOCAL_OPT_DIR

PROJECT_DIR="${HOME}/projects"
if [ "$(uname)" = "Darwin" ]; then
  PROJECT_DIR="${HOME}/Projects"
fi
readonly PROJECT_DIR
export PROJECT_DIR

TMP_DIR="${HOME}/tmp"
readonly TMP_DIR
export TMP_DIR

UNIVERSITY_PROJECT_DIR="${PROJECT_DIR}/university"
if [ "$(uname)" = "Darwin" ]; then
  UNIVERSITY_PROJECT_DIR="${PROJECT_DIR}/University"
fi
readonly UNIVERSITY_PROJECT_DIR
export UNIVERSITY_PROJECT_DIR

VISIOSTO_PROJECT_DIR="${PROJECT_DIR}/visiosto"
if [ "$(uname)" = "Darwin" ]; then
  VISIOSTO_PROJECT_DIR="${PROJECT_DIR}/Visiosto"
fi
readonly VISIOSTO_PROJECT_DIR
export VISIOSTO_PROJECT_DIR
