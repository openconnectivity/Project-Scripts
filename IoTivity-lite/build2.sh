#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

cd ${OCFPATH}/iotivity-constrained/port/linux

#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over.
cp ${CURPWD}/src/${PROJNAME}.c ${OCFPATH}/iotivity-constrained/apps/

# Copying the Makefile file to the executable folder
cp ${CURPWD}/Makefile ${OCFPATH}/iotivity-constrained/port/linux/

#make with switches
make DYNAMIC=1 IPV4=1 ${PROJNAME}
#make DYNAMIC=1 ${PROJNAME}

#TODO remove this command once the above problem is fixed
rm -rf ${OCFPATH}/iotivity-constrained/port/linux/${PROJNAME}_creds
rm ${OCFPATH}/iotivity-constrained/apps/${PROJNAME}.c
mv ./${PROJNAME} /${CURPWD}/bin/

cd ${CURPWD}
