#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}
OCFBASEPATH=`jq '.ocf_base_path' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
DEVICETYPE=`jq '.device_type' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
DEVICENAME=`jq '.friendly_name' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)
OCFSUBPATH=`jq '.implementation_paths[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`
OCFPATH="${OCFBASEPATH}${OCFSUBPATH}"
PLATFORM=`jq '.platforms[0]' ${CURPWD}/${PROJNAME}-config.json | tr -d \"`

if [ "$OCFSUBPATH" == "/iot" ]; then
  cd ${OCFPATH}/iotivity/

  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
  cp ${CURPWD}/src/*.cpp ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/
  cp ${CURPWD}/src/*.h ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/
  mv -f ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/${PROJNAME}.cpp ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/server.cpp

  # copying the SConscript file to the source folder
  cp ${CURPWD}/SConscript ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/

  scons examples/OCFDeviceBuilder

  #TODO remove this command once the above problem is fixed
  cp ${OCFPATH}/iotivity/out/linux/armv7l/release/examples/OCFDeviceBuilder/server /${CURPWD}/bin/${PROJNAME}

elif [  "$OCFSUBPATH" == "/iot-lite" ]; then
  # copying the Makefile to the source folder
  cp ${OCFPATH}/default.Makefile ./${PROJNAME}/Makefile

  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
  cp ${CURPWD}/src/${PROJNAME}.c ${OCFPATH}/iotivity-constrained/apps/

  # Copying the Makefile file to the executable folder
  cp ${CURPWD}/Makefile ${OCFPATH}/iotivity-constrained/port/linux/
  cd ${OCFPATH}/iotivity-constrained/port/linux/
  #comment out one of the next lines to build another port
#cd /home/pi/iot-lite/iotivity-constrained/port/android/
#cd /home/pi/iot-lite/iotivity-constrained/port/contiki/
#cd /home/pi/iot-lite/iotivity-constrained/port/freertos/
#cd /home/pi/iot-lite/iotivity-constrained/port/linux/
#cd /home/pi/iot-lite/iotivity-constrained/port/openthread/
#cd /home/pi/iot-lite/iotivity-constrained/port/riot/
#cd /home/pi/iot-lite/iotivity-constrained/port/tizenrt/
#cd /home/pi/iot-lite/iotivity-constrained/port/unittest/
#cd /home/pi/iot-lite/iotivity-constrained/port/windows/
#cd /home/pi/iot-lite/iotivity-constrained/port/zephyr/

  #make with switches
  make DYNAMIC=1 IPV4=1 ${PROJNAME}
  #make DYNAMIC=1 ${PROJNAME}
  #uncomment to make the debug version
  #make DYNAMIC=1 DEBUG=1 ${PROJNAME}

  #TODO remove this command once the above problem is fixed
  rm -rf ${OCFPATH}/iotivity-constrained/port/linux/${PROJNAME}_creds
  rm ${OCFPATH}/iotivity-constrained/apps/${PROJNAME}.c
  mv ./${PROJNAME} /${CURPWD}/bin/
else
  No OCFSUBPATH: $OCFSUBPATH
fi

cd $CURPWD
