#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

if [ "$PLATFORM" == "esp32" ]; then
  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="idf.py -p /dev/ttyUSB0 flash monitor"
  eval ${MY_COMMAND}
else
  cd ./bin
  ./${PROJNAME}
fi

cd ${CURPWD}
