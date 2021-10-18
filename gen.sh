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
  MY_COMMAND="cp -f ~/Project-Scripts/settings-esp32.json ${CURPWD}/.vscode/settings.json"
  eval ${MY_COMMAND}
elif [ "$PLATFORM" == "arduino" ];
then
  MY_COMMAND="cp -f ~/Project-Scripts/settings-arduino.json ${CURPWD}/.vscode/settings.json"
  eval ${MY_COMMAND}
else
