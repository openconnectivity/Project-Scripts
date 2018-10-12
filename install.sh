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

sudo apt-get install jq

# create the build3 script with the new config file
cd ${CURPWD}/Project-Scripts/IoTivity
echo "#!/bin/bash" > gen3.sh
echo "CURPWD=\`pwd\`" >> gen3.sh
echo "PROJNAME=\${PWD##*/}" >> gen3.sh
echo "OLD_PROJECT_NAME=device_builder_server" >> gen3.sh
echo "OCFBASEPATH=\`jq '.ocf_base_path' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> gen3.sh
echo "DEVICETYPE=\`jq '.device_type' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> gen3.sh
echo "DEVICENAME=\`jq '.friendly_name' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> gen3.sh
echo "" >> gen3.sh
echo "\#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)" >> gen3.sh
echo "OCFSUBPATH=\`jq '.implementation_paths[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> gen3.sh
echo "OCFPATH=\"\${OCFBASEPATH}\${OCFSUBPATH}\"" >> gen3.sh
echo "PLATFORM=\`jq '.platforms[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> gen3.sh
echo "" >> gen3.sh
echo "\# extract device description and create input file from config file" >> gen3.sh
echo "jq '.device_description' \${CURPWD}/\${PROJNAME}-config.json > \${CURPWD}/\${PROJNAME}.json" >> gen3.sh
echo "" >> gen3.sh
echo "\# The lines above parse the config file and set everything up for the normal gen2.sh stuff below" >> gen3.sh
echo "MY_COMMAND=\"cd \${OCFPATH}/DeviceBuilder\"" >> gen3.sh
echo "eval \${MY_COMMAND}" >> gen3.sh
echo "pwd" >> gen3.sh
echo "" >> gen3.sh
echo "if [ \"\$OCFSUBPATH\" == \"/iot\" ]; then" >> gen3.sh
echo "  MY_COMMAND=\"sh ./DeviceBuilder_C++IotivityServer.sh \${CURPWD}/\${PROJNAME}.json  \${CURPWD}/device_output \\\"\${DEVICETYPE}\\\"" >> gen3.sh
echo "  eval \${MY_COMMAND}" >> gen3.sh
echo "" >> gen3.sh
echo "  \# copying the introspection file to the executable folder" >> gen3.sh
echo "  cp -f \${CURPWD}/device_output/code/server_introspection.dat \${CURPWD}/bin/" >> gen3.sh
echo "" >> gen3.sh
echo "  \# quick fix: using the iotivity supplied oic_svr_db_server_justworks.dat file" >> gen3.sh
echo "  MY_COMMAND=\"cp -f \${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat \${CURPWD}/bin/server_security.dat\"" >> gen3.sh
echo "  eval \${MY_COMMAND}" >> gen3.sh
echo "" >> gen3.sh
echo "  if [ -e \${CURPWD}/src/\${PROJNAME}.cpp ];" >> gen3.sh
echo "  then" >> gen3.sh
echo "    echo \"It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes.\"" >> gen3.sh
echo "  else" >> gen3.sh
echo "    cp -i \${CURPWD}/device_output/code/server.cpp \${CURPWD}/src/\${PROJNAME}.cpp" >> gen3.sh
echo "    cp -i \${CURPWD}/device_output/code/server.cpp \${CURPWD}/src/\${PROJNAME}-gen.cpp" >> gen3.sh
echo "  fi" >> gen3.sh
echo "elif [ \"\$OCFSUBPATH\" == \"/iot-lite\" ]; then" >> gen3.sh
echo "  MY_COMMAND=\"sh ./DeviceBuilder_IotivityLiteServer.sh \${CURPWD}/\${PROJNAME}.json \${CURPWD}/device_output \\\"\${DEVICETYPE}\\\"" >> gen3.sh
echo "  eval \${MY_COMMAND}" >> gen3.sh
echo "" >> gen3.sh
echo "  \#temp" >> gen3.sh
echo "  cp \${OCFPATH}/device_output/code/server_introspection.dat.h \${CURPWD}/device_output/code/" >> gen3.sh
echo "" >> gen3.sh
echo "  \# copying the introspection file to the include folder" >> gen3.sh
echo "  cp \${CURPWD}/device_output/code/server_introspection.dat.h \${OCFPATH}/iotivity-constrained/include/" >> gen3.sh
echo "" >> gen3.sh
echo "  mkdir \${CURPWD}/bin/\${PROJNAME}_creds" >> gen3.sh
echo "" >> gen3.sh
echo "  \# modify the Makefile to make this project" >> gen3.sh
echo "  MY_COMMAND=\"sed -i.bak -e \\\"s,\${OLD_PROJECT_NAME},\${PROJNAME},g\\\" \${CURPWD}/Makefile\"" >> gen3.sh
echo "  eval \${MY_COMMAND}" >> gen3.sh
echo "" >> gen3.sh
echo "  if [ -e \${CURPWD}/src/\${PROJNAME}.c ];" >> gen3.sh
echo "  then" >> gen3.sh
echo "    echo \"It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes.\"" >> gen3.sh
echo "  else" >> gen3.sh
echo "    cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/src/\${PROJNAME}.c" >> gen3.sh
echo "    cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/src/\${PROJNAME}-gen.c" >> gen3.sh
echo "  fi" >> gen3.sh
echo "else" >> gen3.sh
echo "  echo \"No OCFSUBPATH: \$OCFSUBPATH\"" >> gen3.sh
echo "fi" >> gen3.sh

# copy to IoTivity-lite
cp ${CURPWD}/Project-Scripts/IoTivity/gen3.sh ${CURPWD}/Project-Scripts/IoTivity-lite/

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

echo "#!/bin/bash" > build3.sh
echo "CURPWD=\`pwd\`" >> build3.sh
echo "PROJNAME=\${PWD##*/}" >> build3.sh
echo "OCFBASEPATH=\`jq '.ocf_base_path' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "DEVICETYPE=\`jq '.device_type' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "DEVICENAME=\`jq '.friendly_name' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "" >> build3.sh
echo "\#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)" >> build3.sh
echo "OCFSUBPATH=\`jq '.implementation_paths[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "OCFPATH=\"\${OCFBASEPATH}\${OCFSUBPATH}\"" >> build3.sh
echo "PLATFORM=\`jq '.platforms[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "" >> build3.sh
echo "cd \${OCFPATH}/iotivity/" >> build3.sh
echo "" >> build3.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build3.sh
echo "cp \${CURPWD}/src/*.cpp \${OCFPATH}/iotivity/examples/${code_path}/" >> build3.sh
echo "cp \${CURPWD}/src/*.h \${OCFPATH}/iotivity/examples/${code_path}/" >> build3.sh
echo "mv -f \${OCFPATH}/iotivity/examples/${code_path}/\${PROJNAME}.cpp \${OCFPATH}/iotivity/examples/${code_path}/server.cpp" >> build3.sh
echo "" >> build3.sh
echo "# copying the SConscript file to the source folder" >> build3.sh
echo "cp \${CURPWD}/SConscript \${OCFPATH}/iotivity/examples/${code_path}/" >> build3.sh
echo "" >> build3.sh
echo "scons examples/${code_path}" >> build3.sh
echo "" >> build3.sh
echo "#TODO remove this command once the above problem is fixed" >> build3.sh
echo "cp \${OCFPATH}/iotivity/out/linux/${ARCH}/release/examples/${code_path}/server /\${CURPWD}/bin/\${PROJNAME}" >> build3.sh
echo "" >> build3.sh
echo "cd \$CURPWD" >> build3.sh

chmod +x ${CURPWD}/Project-Scripts/IoTivity/*.sh
cp ${CURPWD}/Project-Scripts/IoTivity/* ${OCFPATH}/../iot/

# create the build2 script with the correct OS stuff for IoTivity-lite
cd ${CURPWD}/Project-Scripts/IoTivity-lite
echo "#!/bin/bash" > build2.sh
echo "CURPWD=\`pwd\`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "cp \${CURPWD}/src/\${PROJNAME}.c \${OCFPATH}/iotivity-constrained/apps/" >> build2.sh
echo "" >> build2.sh
echo "# Copying the Makefile file to the executable folder" >> build2.sh
echo "cp \${CURPWD}/Makefile \${OCFPATH}/iotivity-constrained/port/linux/" >> build2.sh
echo "cd \${OCFPATH}/iotivity-constrained/port/linux/" >> build2.sh
echo "#comment out one of the next lines to build another port" >> build2.sh
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

echo "#!/bin/bash" > build3.sh
echo "CURPWD=\`pwd\`" >> build3.sh
echo "PROJNAME=\${PWD##*/}" >> build3.sh
echo "OCFBASEPATH=\`jq '.ocf_base_path' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "DEVICETYPE=\`jq '.device_type' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "DEVICENAME=\`jq '.friendly_name' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "" >> build3.sh
echo "\#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)" >> build3.sh
echo "OCFSUBPATH=\`jq '.implementation_paths[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "OCFPATH=\"\${OCFBASEPATH}\${OCFSUBPATH}\"" >> build3.sh
echo "PLATFORM=\`jq '.platforms[0]' \${CURPWD}/\${PROJNAME}-config.json | tr -d \\\"\`" >> build3.sh
echo "" >> build3.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build3.sh
echo "cp \${CURPWD}/src/\${PROJNAME}.c \${OCFPATH}/iotivity-constrained/apps/" >> build3.sh
echo "" >> build3.sh
echo "# Copying the Makefile file to the executable folder" >> build3.sh
echo "cp \${CURPWD}/Makefile \${OCFPATH}/iotivity-constrained/port/linux/" >> build3.sh
echo "cd \${OCFPATH}/iotivity-constrained/port/linux/" >> build3.sh
echo "#comment out one of the next lines to build another port" >> build3.sh
for d in ${OCFPATH}/iotivity-constrained/port/*/ ; do
    echo "#cd $d" >> build3.sh
done
echo "" >> build3.sh
echo "#make with switches" >> build3.sh
echo "make DYNAMIC=1 IPV4=1 \${PROJNAME}" >> build3.sh
echo "#make DYNAMIC=1 \${PROJNAME}" >> build3.sh
echo "#uncomment to make the debug version" >> build3.sh
echo "#make DYNAMIC=1 DEBUG=1 \${PROJNAME}" >> build3.sh
echo "" >> build3.sh
echo "#TODO remove this command once the above problem is fixed" >> build3.sh
echo "rm -rf \${OCFPATH}/iotivity-constrained/port/linux/\${PROJNAME}_creds" >> build3.sh
echo "rm \${OCFPATH}/iotivity-constrained/apps/\${PROJNAME}.c" >> build3.sh
echo "mv ./\${PROJNAME} /\${CURPWD}/bin/" >> build3.sh
echo "" >> build3.sh
echo "cd \${CURPWD}" >> build3.sh

chmod +x ${CURPWD}/Project-Scripts/IoTivity-lite/*.sh
cp ${CURPWD}/Project-Scripts/IoTivity-lite/* ${OCFPATH}/../iot-lite/

cd ${CURPWD}
