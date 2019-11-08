#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`
DEVICETYPE=`jq --raw-output '.device_type' ${CURPWD}/${PROJNAME}-config.json`
DEVICENAME=`jq --raw-output '.friendly_name' ${CURPWD}/${PROJNAME}-config.json`

#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

if [  "$OCFSUBPATH" == "/iot-lite" ]; then
  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
  MY_COMMAND="cp ${CURPWD}/src/${PROJNAME}.c ${OCFPATH}/../../iotivity-lite/apps/server_devicebuilder.c"
  eval ${MY_COMMAND}
  MY_COMMAND="cp ${CURPWD}/src/${PROJNAME}-main.cpp ${OCFPATH}/../../iotivity-lite/apps/server_arduino.cpp"
  eval ${MY_COMMAND}

  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="./build_arduino.sh --arch sam --secure --upload"
  eval ${MY_COMMAND}
  #The executable will be uploaded and run on the Arduino as soon as it is compiled
else
  No OCFSUBPATH: $OCFSUBPATH
fi

cd $CURPWD
