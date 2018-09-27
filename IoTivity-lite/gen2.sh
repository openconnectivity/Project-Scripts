#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OLD_PROJECT_NAME=device_builder_server

cd ${OCFPATH}/DeviceBuilder
MY_COMMAND="sh ./DeviceBuilder_IotivityLiteServer.sh ${CURPWD}/${PROJNAME}.json  ${CURPWD}/device_output \"oic.d.light\""
eval ${MY_COMMAND}

# copying the introspection file to the include folder
cp ${CURPWD}/device_output/code/server_introspection.dat.h ${OCFPATH}/iotivity-constrained/include/

mkdir ${CURPWD}/bin/${PROJNAME}_creds

# modify the Makefile to make this project
MY_COMMAND="sed -i.bak -e \"s,${OLD_PROJECT_NAME},${PROJNAME},g\" ${CURPWD}/Makefile"
eval ${MY_COMMAND}

if [ -e ${CURPWD}/src/${PROJNAME}.c ]
then
  echo "It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes."
else
  cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/src/${PROJNAME}.c
  cp ${CURPWD}/device_output/code/simpleserver.c ${CURPWD}/src/${PROJNAME}-gen.c"
fi

cd ${CURPWD}
