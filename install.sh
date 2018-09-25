#!/bin/bash

#############################
#
# copyright 2018 Open Connectivity Foundation, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################

ARCH=`uname -m`

echo "using architecture: $ARCH"

code_path=OCFDeviceBuilder

CURPWD=`pwd`

if [[ ! -v OCFPATH ]]; then
    export OCFSUBPATH=/iot
    echo "export OCFSUBPATH=${OCFSUBPATH}" >> ~/.bashrc

    export OCFPATH=${HOME}${OCFSUBPATH}
    echo "export OCFPATH=${OCFPATH}" >> ~/.bashrc

    export PATH=${OCFPATH}:${PATH}
    echo "export PATH=${OCFPATH}":'$PATH' >> ~/.bashrc
fi

git clone https://github.com/openconnectivity/Project-Scripts.git

# create the build2 script with the correct OS stuff for IoTivity
cd ${CURPWD}/Project-Scripts/IoTivity
echo "#!/bin/bash" > build2.sh
echo "CURPWD=\`pwd\`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "cd \${OCFPATH}/iotivity/" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "cp \${CURPWD}/src/*.cpp \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "cp \${CURPWD}/src/*.h \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "mv -f \${OCFPATH}/iotivity/examples/${code_path}/\${PROJNAME}.cpp \${OCFPATH}/iotivity/examples/${code_path}/server.cpp" >> build2.sh
echo "" >> build2.sh
echo "# copying the SConscript file to the source folder" >> build2.sh
echo "cp \${CURPWD}/SConscript \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "" >> build2.sh
echo "scons examples/${code_path}" >> build2.sh
echo "" >> build2.sh
echo "#TODO remove this command once the above problem is fixed" >> build2.sh
echo "cp \${OCFPATH}/iotivity/out/linux/${ARCH}/release/examples/${code_path}/server /\${CURPWD}/bin/\${PROJNAME}" >> build2.sh
echo "" >> build2.sh
echo "cd \$CURPWD" >> build2.sh

cp ${CURPWD}/Project-Scripts/IoTivity/* ${OCFPATH}/../iot/
cd ${CURPWD}

# create the build2 script with the correct OS stuff for IoTivity-lite
cd ${CURPWD}/Project-Scripts/IoTivity-lite
echo "#!/bin/bash" > build2.sh
echo "CURPWD=\`pwd\`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "cd \${OCFPATH}/iotivity-constrained/port/linux" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "cp \${CURPWD}/src/\${PROJNAME}.c \${OCFPATH}/iotivity-constrained/apps/" >> build2.sh
echo "" >> build2.sh
echo "# Copying the Makefile file to the executable folder" >> build2.sh
echo "cp \${CURPWD}/Makefile \${OCFPATH}/iotivity-constrained/port/linux/" >> build2.sh
echo "#comment out one of the next lines to build another port"
for d in ${OCFPATH}/iotivity-constrained/port/*/ ; do
  echo "#cd $d" >> build2.sh
done
echo "" >> build2.sh
echo "#make with switches" >> build2.sh
echo "make DYNAMIC=1 IPV4=1 \${PROJNAME}" >> build2.sh
echo "#make DYNAMIC=1 \${PROJNAME}" >> build2.sh
echo "#uncomment to make the debug version" >> build2.sh
echo "#make DYNAMIC=1 DEBUG=1 \${PROJNAME}" >> build2.sh
echo "" >> build2.sh
echo "#TODO remove this command once the above problem is fixed" >> build2.sh
echo "rm -rf \${OCFPATH}/iotivity-constrained/port/linux/\${PROJNAME}_creds" >> build2.sh
echo "rm \${OCFPATH}/iotivity-constrained/apps/\${PROJNAME}.c" >> build2.sh
echo "mv ./\${PROJNAME} /\${CURPWD}/bin/" >> build2.sh
echo "" >> build2.sh
echo "cd \${CURPWD}" >> build2.sh

cp ${CURPWD}/Project-Scripts/IoTivity-lite/* ${OCFPATH}/../iot-lite/
cd ${CURPWD}
