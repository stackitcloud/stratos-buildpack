#!/bin/bash
set -euo pipefail

NODE_VERSION="22.14.0"
ARC="linux-x64"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/node${NODE_VERSION}.tar.gz
NODE_EXTRACT_DIR="/tmp/node-v${NODE_VERSION}"
export NodeInstallDir="${NODE_EXTRACT_DIR}/node-v${NODE_VERSION}-${ARC}"

mkdir -p $NODE_EXTRACT_DIR

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached node downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/node*.tar.gz
  URL=https://nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-${ARC}.tar.gz
  echo "-----> Download Nodejs ${NODE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}
fi

echo "Downloaded NodeJS package OK"

if [ ! -f $NodeInstallDir/bin/node ]; then
  tar xzf ${DOWNLOAD_FILE} -C $NODE_EXTRACT_DIR
fi

echo "Unpacked NodeJS package OK"

ls -al $NodeInstallDir
ls -al $NodeInstallDir/bin

if [ ! -f $NodeInstallDir/bin/node ]; then
  echo "       **ERROR** Could not download nodejs"
  exit 1
fi

export NODE_HOME=$NodeInstallDir
