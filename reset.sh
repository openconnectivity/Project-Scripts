#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`

# TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.jsonbash -x `
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"

if [ "$OCFSUBPATH" == "/iot" ]; then
  rm -f ./bin/server_security.dat
  cp ${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat ./bin/server_security.dat
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  rm -rf ./bin/device_builder_server_creds
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi