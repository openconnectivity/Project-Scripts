#!/bin/bash
PROJNAME=$1

OCFBASEPATH=`jq '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

# TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

mkdir -p ./${PROJNAME}
mkdir -p ./${PROJNAME}/src
mkdir -p ./${PROJNAME}/bin
cp ${OCFPATH}/default.json ./$PROJNAME/$PROJNAME.json

if [ "$OCFSUBPATH" == "/iot" ]; then
  cp ${OCFPATH}/default.SConscript ./${PROJNAME}/SConscript
elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  cp ${OCFPATH}/default.Makefile ./$PROJNAME/Makefile
else
  echo "No OCFSUBPATH: $OCFSUBPATH"
fi

cd ${PROJNAME}
