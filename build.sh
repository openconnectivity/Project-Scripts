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

if [ "$PLATFORM" == "esp32" ];
then
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}.c ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/vscode-esp32-example.c"
  eval ${MY_COMMAND}
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}-main.c ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/main.c"
  eval ${MY_COMMAND}
  MY_COMMAND="cp ${CURPWD}/main/pki_certs.h ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/pki_certs.h"
  eval ${MY_COMMAND}

  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="idf.py build"
  eval ${MY_COMMAND}
elif [ "$PLATFORM" == "arduino" ];
then
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}.c ${OCFPATH}/../iotivity-lite/apps/server_devicebuilder.c"
  eval ${MY_COMMAND}
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}-main.cpp ${OCFPATH}/../iotivity-lite/apps/server_arduino.cpp"
  eval ${MY_COMMAND}

  MY_COMMAND="cd ${OCFPATH}/../iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="./build_arduino.sh --arch sam --secure"
  eval ${MY_COMMAND}
else
  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}.c ${OCFPATH}/iotivity-lite/apps/device_builder_server.c"
  eval ${MY_COMMAND}
  MY_COMMAND="cp ${CURPWD}/main/${PROJNAME}-main.c ${OCFPATH}/iotivity-lite/apps/device_builder_server-main.c"
  eval ${MY_COMMAND}

  MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
  eval ${MY_COMMAND}
  MY_COMMAND="make -f ${CURPWD}/devbuildmake DYNAMIC=1 IPV4=1 device_builder_server"
  eval ${MY_COMMAND}
  #make -f ${CURPWD}/devbuildmake DYNAMIC=1 device_builder_server
  #uncomment to make the debug version
  #make -f ${CURPWD}/devbuildmake DYNAMIC=1 DEBUG=1 device_builder_server

  #TODO remove this command once the above problem is fixed
  MY_COMMAND="cp ${OCFPATH}/iotivity-lite/port/${PLATFORM}/device_builder_server ${CURPWD}/bin/${PROJNAME}"
  eval ${MY_COMMAND}
fi
cd $CURPWD
