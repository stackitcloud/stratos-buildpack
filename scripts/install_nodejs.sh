#!/bin/bash
set -euo pipefail

NODE_VERSION="22.14.0"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/node${NODE_VERSION}.tar.gz

export NodeInstallDir="/tmp/node$NODE_VERSION"

mkdir -p $NodeInstallDir

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached node downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/node*.tar.gz

  NODE_SHA256="9d942932535988091034dc94cc5f42b6dc8784d6366df3a36c4c9ccb3996f0c2"
  URL=https://nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz
  echo "-----> Download Nodejs ${NODE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}

  DOWNLOAD_SHA256=$(shasum -a 256 ${DOWNLOAD_FILE} | cut -d ' ' -f 1)  

  if [[ $DOWNLOAD_SHA256 != $NODE_SHA256 ]]; then
    echo "       **ERROR** SHA256 mismatch: got $DOWNLOAD_SHA256 expected $NODE_SHA256"
    exit 1
  fi
else
  echo "-----> Nodejs install package available in cache"
fi

echo "Downloaded NodeJS package OK"

if [ ! -f $NodeInstallDir/bin/node ]; then
  tar xzf ${DOWNLOAD_FILE} -C $NodeInstallDir
fi

echo "Unpacked NodeJS package OK"

ls -al $NodeInstallDir
ls -al $NodeInstallDir/bin

if [ ! -f $NodeInstallDir/bin/node ]; then
  echo "       **ERROR** Could not download nodejs"
  exit 1
fi

export NODE_HOME=$NodeInstallDir
