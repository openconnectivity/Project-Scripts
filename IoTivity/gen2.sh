#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

cd ${OCFPATH}/DeviceBuilder
MY_COMMAND="sh ./DeviceBuilder_C++IotivityServer.sh ${CURPWD}/${PROJNAME}.json  ${CURPWD}/device_output \"oic.d.widget\""
eval ${MY_COMMAND}

# copying the introspection file to the executable folder
cp -f ${CURPWD}/device_output/code/server_introspection.dat ${CURPWD}/bin/

# quick fix: using the iotivity supplied oic_svr_db_server_justworks.dat file
cp -f ${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ${CURPWD}/bin/server_security.dat

if [ -e ${CURPWD}/src/${PROJNAME}.cpp ]
then
  echo "It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes."
else
  cp -i ${CURPWD}/device_output/code/server.cpp ${CURPWD}/src/${PROJNAME}.cpp
  cp -i ${CURPWD}/device_output/code/server.cpp ${CURPWD}/src/${PROJNAME}-gen.cpp
fi

cd ${CURPWD}
