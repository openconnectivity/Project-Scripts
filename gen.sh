#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OLD_PROJECT_NAME=device_builder_server
OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`
DEVICETYPE=`jq --raw-output '.device_type' ${CURPWD}/${PROJNAME}-config.json`
DEVICENAME=`jq --raw-output '.friendly_name' ${CURPWD}/${PROJNAME}-config.json`

#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

# extract device description and create input file from config file
jq --raw-output '.device_description' ${CURPWD}/${PROJNAME}-config.json > ${CURPWD}/${PROJNAME}.json

# The lines above parse the config file and set everything up for the normal gen.sh stuff below
if [ "$PLATFORM" == "esp32" ];
then
  MY_COMMAND="cp ~/Project-Scripts/settings-esp32.json ${CURPWD}/settings.json"
  eval ${MY_COMMAND}
elif [ "$PLATFORM" == "arduino" ];
then
  MY_COMMAND="cp ~/Project-Scripts/settings-arduino.json ${CURPWD}/settings.json"
  eval ${MY_COMMAND}
else
  MY_COMMAND="cp ~/Project-Scripts/settings-linux.json ${CURPWD}/settings.json"
  eval ${MY_COMMAND}
fi
MY_COMMAND="cd ${OCFPATH}/DeviceBuilder"
eval ${MY_COMMAND}
pwd

if [ ! -e ${CURPWD}/devbuildmake ]; then
  MY_COMMAND="cp ${OCFPATH}/iotivity-lite/port/${PLATFORM}/devbuildmake ${CURPWD}/"
  eval ${MY_COMMAND}
fi
MY_COMMAND="sh ./DeviceBuilder_IotivityLiteServer.sh ${CURPWD}/${PROJNAME}.json ${CURPWD}/device_output \"${DEVICETYPE}\" \"${DEVICENAME}\""
eval ${MY_COMMAND}

# copying the introspection file to the include folder
MY_COMMAND="cp -f ${CURPWD}/device_output/code/server_introspection.dat.h ${OCFPATH}/iotivity-lite/include/"
eval ${MY_COMMAND}

if [ ! -f ../pki_certs.zip ]; then
  # only create when the file does not exist
  cd ..
  MY_COMMAND="sh ./pki.sh"
  eval ${MY_COMMAND}
fi

if [ -e ${CURPWD}/main/${PROJNAME}.c ];
then
  cp -f ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/main/${PROJNAME}-gen.c
  if cmp -s ${CURPWD}/main/${PROJNAME}-gen.c ${CURPWD}/main/${PROJNAME}-old.c ;
  then
    echo "It appears that you have modified the automatically generated source file. main/${PROJNAME}-gen.c is the file without any of your changes."
  else
    echo "The source file built by DeviceBuilder changed. You can use diff3 to merge your own modifications."
    echo "Example: diff3 -m main/${PROJNAME}-gen.c main/${PROJNAME}-old.c main/${PROJNAME}.c > main/${PROJNAME}-new.c"
    echo "Then: cp -f main/${PROJNAME}-gen.c main/${PROJNAME}-old.c"
    echo "And: mv -f main/${PROJNAME}-new.c main/${PROJNAME}.c"
  fi
else
  cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/main/${PROJNAME}.c
  cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/main/${PROJNAME}-gen.c
fi
