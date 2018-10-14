#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`

if [ "$OCFSUBPATH" == "/iot" ]; then
  nano ./src/${PROJNAME}.cpp
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  nano ./src/${PROJNAME}.c
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi
