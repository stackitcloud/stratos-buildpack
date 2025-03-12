#!/bin/bash
set -euo pipefail

GO_VERSION="1.24.1"
ARC="linux-amd64"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/go${GO_VERSION}.tar.gz

export GoInstallDir="/tmp/go$GO_VERSION"
mkdir -p $GoInstallDir

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached go downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/go*.tar.gz
  URL=https://dl.google.com/go/go${GO_VERSION}.${ARC}.tar.gz
  echo "-----> Download go ${GO_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}
fi

if [ ! -f $GoInstallDir/go/bin/go ]; then
  tar xzf ${DOWNLOAD_FILE} -C $GoInstallDir
fi

if [ ! -f $GoInstallDir/go/bin/go ]; then
  echo "       **ERROR** Could not download go"
  exit 1
fi


