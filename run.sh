#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`

#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

if [ "$PLATFORM" == "esp32" ]; then
  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="idf.py -p /dev/ttyUSB0 flash monitor"
  eval ${MY_COMMAND}
elif [ "$PLATFORM" == "arduino" ]; then
  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="./build_arduino.sh --arch sam --secure --upload"
  eval ${MY_COMMAND}
else
  cd ./bin
  ./${PROJNAME}
fi

cd ${CURPWD}
