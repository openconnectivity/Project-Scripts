#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

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

cd $CURPWD
