#!/bin/bash
PROJNAME=${PWD##*/}
OCFSUBPATH=`jq '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

if [ "$OCFSUBPATH" == "/iot" ]; then
  nano ./src/${PROJNAME}.cpp
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  nano ./src/${PROJNAME}.c
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi