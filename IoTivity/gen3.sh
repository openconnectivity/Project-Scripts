#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OLD_PROJECT_NAME=device_builder_server
OCFBASEPATH=`jq '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
DEVICETYPE=`jq '.device_type' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
DEVICENAME=`jq '.friendly_name' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

# extract device description and create input file from config file
jq '.device_description' ${CURPWD}/${PROJNAME}-config.json > ${CURPWD}/${PROJNAME}.json


# The lines above parse the config file and set everything up for the normal gen2.sh stuff below

MY_COMMAND="cd ${OCFPATH}/DeviceBuilder"
eval ${MY_COMMAND}
pwd

echo "OCFSUBPATH: ${OCFSUBPATH}"

if [ "$OCFSUBPATH" == "/iot" ]; then
  MY_COMMAND="sh ./DeviceBuilder_C++IotivityServer.sh ${CURPWD}/${PROJNAME}.json  ${CURPWD}/device_output \"${DEVICETYPE}\""
  eval ${MY_COMMAND}

  # copying the introspection file to the executable folder
  cp -f ${CURPWD}/device_output/code/server_introspection.dat ${CURPWD}/bin/

  # quick fix: using the iotivity supplied oic_svr_db_server_justworks.dat file
  MY_COMMAND="cp -f ${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ${CURPWD}/bin/server_security.dat"
  eval ${MY_COMMAND}

  if [ -e ${CURPWD}/src/${PROJNAME}.cpp ];
  then
    echo "It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes."
  else
    cp -i ${CURPWD}/device_output/code/server.cpp ${CURPWD}/src/${PROJNAME}.cpp
    cp -i ${CURPWD}/device_output/code/server.cpp ${CURPWD}/src/${PROJNAME}-gen.cpp
  fi
elif [ "$OCFSUBPATH" == "/iot-lite" ]; then
  MY_COMMAND="sh ./DeviceBuilder_IotivityLiteServer.sh ${CURPWD}/${PROJNAME}.json  ${CURPWD}/device_output \"${DEVICETYPE}\""
  eval ${MY_COMMAND}

  #temp
  cp ${OCFPATH}/device_output/code/server_introspection.dat.h ${CURPWD}/device_output/code/

  # copying the introspection file to the include folder
  cp ${CURPWD}/device_output/code/server_introspection.dat.h ${OCFPATH}/iotivity-constrained/include/

  mkdir ${CURPWD}/bin/${PROJNAME}_creds

  # modify the Makefile to make this project
  MY_COMMAND="sed -i.bak -e \"s,${OLD_PROJECT_NAME},${PROJNAME},g\" ${CURPWD}/Makefile"
  eval ${MY_COMMAND}

  if [ -e ${CURPWD}/src/${PROJNAME}.c ];
  then
    echo "It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes."
  else
    cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/src/${PROJNAME}.c
    cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/src/${PROJNAME}-gen.c
  fi
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi
