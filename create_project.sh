#!/bin/bash
PROJNAME=$1

OCFBASEPATH=`jq --raw-output '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json`

# TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq --raw-output '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq --raw-output '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json`

mkdir -p ./${PROJNAME}
mkdir -p ./${PROJNAME}/src
mkdir -p ./${PROJNAME}/bin
cp ${OCFPATH}/default.json ./$PROJNAME/$PROJNAME.json

cd ${PROJNAME}
