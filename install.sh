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

# create the build2 script with the correct OS stuff
cd IoTivity
echo "#!/bin/bash" > build2.sh
echo "CURPWD=`pwd`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "cd \${OCFPATH}/iotivity/" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "cp \$CURPWD/src/*.cpp \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "cp \$CURPWD/src/*.h \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "mv -f \${OCFPATH}/iotivity/examples/${code_path}/\${PROJNAME}.cpp \${OCFPATH}/iotivity/examples/${code_path}/server.cpp" >> build2.sh
echo "" >> build2.sh
echo "# copying the SConscript file to the source folder" >> build2.sh
echo "cp \$CURPWD/SConscript \${OCFPATH}/iotivity/examples/${code_path}/" >> build2.sh
echo "" >> build2.sh
echo "scons examples/${code_path}" >> build2.sh
echo "" >> build2.sh
echo "#TODO remove this command once the above problem is fixed" >> build2.sh
echo "cp \${OCFPATH}/iotivity/out/linux/${ARCH}/release/examples/${code_path}/server /\${CURPWD}/bin/\${PROJNAME}" >> build2.sh
echo "" >> build2.sh
echo "cd \$CURPWD" >> build2.sh

cd ..

cp ./Project-Scripts/IoTivity/* ${OCFPATH}/../iot/

cp ./Project-Scripts/IoTivity-lite/* ${OCFPATH}/../iot-lite/

cd $CURPWD
