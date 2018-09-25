#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

cd ${OCFPATH}/iotivity

#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
cp -f ${CURPWD}/src/*.cpp ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/
cp -f ${CURPWD}/src/*.h ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/
mv -f ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/${PROJNAME}.cpp ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/server.cpp
touch ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/server.cpp

# copying the SConscript file to the source folder
cp -f ${CURPWD}/SConscript ${OCFPATH}/iotivity/examples/OCFDeviceBuilder/

#scons resource/examples
scons examples/OCFDeviceBuilder

#TODO remove this command once the above problem is fixed
cp -f ${OCFPATH}/iotivity/out/linux/x86_64/release/examples/OCFDeviceBuilder/server /$CURPWD/bin/${PROJNAME}

cd $CURPWD
