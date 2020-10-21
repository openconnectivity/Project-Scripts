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

MY_COMMAND="cp ${CURPWD}/src/${PROJNAME}.c ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/esp32-example.c"
eval ${MY_COMMAND}
MY_COMMAND="cp ${CURPWD}/src/${PROJNAME}-main.c ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/main.c"
eval ${MY_COMMAND}
MY_COMMAND="cp ${CURPWD}/src/pki_certs.h ${OCFPATH}/iotivity-lite/port/${PLATFORM}/main/pki_certs.h"
eval ${MY_COMMAND}

MY_COMMAND="cd ${OCFPATH}/iotivity-lite/port/${PLATFORM}/"
eval ${MY_COMMAND}
MY_COMMAND="idf.py set-target esp32"
eval ${MY_COMMAND}
MY_COMMAND="idf.py menuconfig"
eval ${MY_COMMAND}
MY_COMMAND="idf.py build"
eval ${MY_COMMAND}

cd $CURPWD
