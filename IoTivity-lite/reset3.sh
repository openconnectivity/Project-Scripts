#!/bin/bash
OCFBASEPATH=`jq '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

# TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"

if [ "$OCFSUBPATH" == "/iot" ]; then
  rm -f ./bin/server_security.dat
  cp ${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ./bin/server_security.dat
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  rm -rf ./bin/device_builder_server_creds
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi
