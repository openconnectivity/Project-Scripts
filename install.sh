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

SCRIPTPATH=${CURPWD}/Project-Scripts

if [[ ! (${PATH} == *${SCRIPTPATH}*) ]]; then
  # update the PATH environment variable: NEED TO RUN THIS SCRIPT WITH "source set_path.sh"
  export PATH=${SCRIPTPATH}:${PATH}

  # modify the ~/.bashrc file so things are set correctly on boot
  echo "export PATH=${SCRIPTPATH}":'$PATH' >> ~/.bashrc
fi

git clone https://github.com/openconnectivity/Project-Scripts.git

sudo apt-get install jq

# create the gen script for the config file
cd ${CURPWD}/Project-Scripts/
echo "#!/bin/bash" > gen.sh
echo "CURPWD=\`pwd\`" >> gen.sh
echo "PROJNAME=\${PWD##*/}" >> gen.sh
echo "OLD_PROJECT_NAME=device_builder_server" >> gen.sh
echo "OCFBASEPATH=\`jq --raw-output '.ocf_base_path' \${CURPWD}/\${PROJNAME}-config.json\`" >> gen.sh
echo "DEVICETYPE=\`jq --raw-output '.device_type' \${CURPWD}/\${PROJNAME}-config.json\`" >> gen.sh
echo "DEVICENAME=\`jq --raw-output '.friendly_name' \${CURPWD}/\${PROJNAME}-config.json\`" >> gen.sh
echo "" >> gen.sh
echo "#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)" >> gen.sh
echo "OCFSUBPATH=\`jq --raw-output '.implementation_paths[0]' \${CURPWD}/\${PROJNAME}-config.json\`" >> gen.sh
echo "OCFPATH=\"\${OCFBASEPATH}\${OCFSUBPATH}\"" >> gen.sh
echo "PLATFORM=\`jq --raw-output '.platforms[0]' \${CURPWD}/\${PROJNAME}-config.json\`" >> gen.sh
echo "" >> gen.sh
echo "# extract device description and create input file from config file" >> gen.sh
echo "jq --raw-output '.device_description' \${CURPWD}/\${PROJNAME}-config.json > \${CURPWD}/\${PROJNAME}.json" >> gen.sh
echo "" >> gen.sh
echo "# The lines above parse the config file and set everything up for the normal gen2.sh stuff below" >> gen.sh
echo "MY_COMMAND=\"cd \${OCFPATH}/DeviceBuilder\"" >> gen.sh
echo "eval \${MY_COMMAND}" >> gen.sh
echo "pwd" >> gen.sh
echo "" >> gen.sh
echo "if [ \"\$OCFSUBPATH\" == \"/iot\" ]; then" >> gen.sh
echo "  if [ ! -e \${CURPWD}/SConscript ]; then" >> gen.sh
echo "    MY_COMMAND=\"cp \${OCFPATH}/../Project-Scripts/IoTivity/default.SConscript \${CURPWD}/SConscript\"" >> gen.sh
echo "    eval \${MY_COMMAND}" >> gen.sh
echo "  fi" >> gen.sh
echo "  MY_COMMAND=\"sh ./DeviceBuilder_C++IotivityServer.sh \${CURPWD}/\${PROJNAME}.json  \${CURPWD}/device_output \\\"\${DEVICETYPE}\\\" \\\"\${DEVICENAME}\\\"\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "  # copying the introspection file to the executable folder" >> gen.sh
echo "  cp -f \${CURPWD}/device_output/code/server_introspection.dat \${CURPWD}/bin/" >> gen.sh
echo "" >> gen.sh
echo "  # quick fix: using the iotivity supplied oic_svr_db_server_justworks.dat file" >> gen.sh
echo "  MY_COMMAND=\"cp -f \${OCFPATH}/iotivity/resource/csdk/security/provisioning/sample/oic_svr_db_server_justworks.dat \${CURPWD}/bin/server_security.dat\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "  if [ -e \${CURPWD}/src/\${PROJNAME}.cpp ];" >> gen.sh
echo "  then" >> gen.sh
echo "    echo \"It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes.\"" >> gen.sh
echo "  else" >> gen.sh
echo "    cp -i \${CURPWD}/device_output/code/server.cpp \${CURPWD}/src/\${PROJNAME}.cpp" >> gen.sh
echo "    cp -i \${CURPWD}/device_output/code/server.cpp \${CURPWD}/src/\${PROJNAME}-gen.cpp" >> gen.sh
echo "  fi" >> gen.sh
echo "elif [ \"\$OCFSUBPATH\" == \"/iot-lite\" ]; then" >> gen.sh
echo "  if [ ! -e \${CURPWD}/devbuildmake ]; then" >> gen.sh
echo "    MY_COMMAND=\"cp \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/devbuildmake \${CURPWD}/\"" >> gen.sh
echo "    eval \${MY_COMMAND}" >> gen.sh
echo "  fi" >> gen.sh
echo "  MY_COMMAND=\"sh ./DeviceBuilder_IotivityLiteServer.sh \${CURPWD}/\${PROJNAME}.json \${CURPWD}/device_output \\\"\${DEVICETYPE}\\\" \\\"\${DEVICENAME}\\\"\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "  # copying the introspection file to the include folder" >> gen.sh
echo "  MY_COMMAND=\"cp -f \${CURPWD}/device_output/code/server_introspection.dat.h \${OCFPATH}/iotivity-lite/include/\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "  if [ -e \${CURPWD}/src/\${PROJNAME}.c ];" >> gen.sh
echo "  then" >> gen.sh
echo "    echo \"It appears that you have modified the automatically generated source file. Use a tool like diff3 if you want to merge in any changes.\"" >> gen.sh
echo "  else" >> gen.sh
echo "    cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/src/\${PROJNAME}.c" >> gen.sh
echo "    cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/src/\${PROJNAME}-gen.c" >> gen.sh
echo "  fi" >> gen.sh
echo "else" >> gen.sh
echo "  echo \"No OCFSUBPATH: \$OCFSUBPATH\"" >> gen.sh
echo "fi" >> gen.sh

# create the build script for the config file
echo "#!/bin/bash" > build.sh
echo "CURPWD=\`pwd\`" >> build.sh
echo "PROJNAME=\${PWD##*/}" >> build.sh
echo "OCFBASEPATH=\`jq --raw-output '.ocf_base_path' \${CURPWD}/\${PROJNAME}-config.json\`" >> build.sh
echo "DEVICETYPE=\`jq --raw-output '.device_type' \${CURPWD}/\${PROJNAME}-config.json\`" >> build.sh
echo "DEVICENAME=\`jq --raw-output '.friendly_name' \${CURPWD}/\${PROJNAME}-config.json\`" >> build.sh
echo "" >> build.sh
echo "#TODO Go through DeviceBuilder for each of the implementations and platforms (just doing the first array element for this example)" >> build.sh
echo "OCFSUBPATH=\`jq --raw-output '.implementation_paths[0]' \${CURPWD}/\${PROJNAME}-config.json\`" >> build.sh
echo "OCFPATH=\"\${OCFBASEPATH}\${OCFSUBPATH}\"" >> build.sh
echo "PLATFORM=\`jq --raw-output '.platforms[0]' \${CURPWD}/\${PROJNAME}-config.json\`" >> build.sh
echo "" >> build.sh
echo "if [ \"\$OCFSUBPATH\" == \"/iot\" ]; then" >> build.sh
echo "  MY_COMMAND=\"cd \${OCFPATH}/iotivity/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/src/*.cpp \${OCFPATH}/iotivity/examples/${code_path}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/src/*.h \${OCFPATH}/iotivity/examples/${code_path}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"mv -f \${OCFPATH}/iotivity/examples/${code_path}/\${PROJNAME}.cpp \${OCFPATH}/iotivity/examples/${code_path}/server.cpp\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  # copying the SConscript file to the source folder" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/SConscript \${OCFPATH}/iotivity/examples/OCFDeviceBuilder/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  scons examples/${code_path}" >> build.sh
echo "" >> build.sh
echo "  #TODO remove this command once the above problem is fixed" >> build.sh
echo "  MY_COMMAND=\"cp \${OCFPATH}/iotivity/out/linux/${ARCH}/release/examples/${code_path}/server /\${CURPWD}/bin/\${PROJNAME}\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "elif [  \"\$OCFSUBPATH\" == \"/iot-lite\" ]; then" >> build.sh
echo "  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/src/\${PROJNAME}.c \${OCFPATH}/iotivity-lite/apps/device_builder_server\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  MY_COMMAND=\"cd \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  make -f \${CURPWD}\devbuildmake DYNAMIC=1 IPV4=1 device_builder_server" >> build.sh
echo "  #make -f \${CURPWD}\devbuildmake DYNAMIC=1 device_builder_server" >> build.sh
echo "  #uncomment to make the debug version" >> build.sh
echo "  #make -f \${CURPWD}\devbuildmake DYNAMIC=1 DEBUG=1 device_builder_server" >> build.sh
echo "" >> build.sh
echo "  #TODO remove this command once the above problem is fixed" >> build.sh
echo "  MY_COMMAND=\"cp \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/device_builder_server \${CURPWD}/BIN/\${PROJNAME}\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"rm \${OCFPATH}/iotivity-lite/apps/\${PROJNAME}.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "else" >> build.sh
echo "  No OCFSUBPATH: \$OCFSUBPATH" >> build.sh
echo "fi" >> build.sh
echo "" >> build.sh
echo "cd \$CURPWD" >> build.sh

# create the build2 script with the correct OS stuff for IoTivity
cd ${CURPWD}/Project-Scripts/IoTivity
echo "#!/bin/bash" > build2.sh
echo "CURPWD=\`pwd\`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "MY_COMMAND=\"cd \${OCFPATH}/iotivity/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "MY_COMMAND=\"cp \${CURPWD}/src/*.cpp \${OCFPATH}/iotivity/examples/${code_path}/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "MY_COMMAND=\"cp \${CURPWD}/src/*.h \${OCFPATH}/iotivity/examples/${code_path}/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "MY_COMMAND=\"mv -f \${OCFPATH}/iotivity/examples/${code_path}/\${PROJNAME}.cpp \${OCFPATH}/iotivity/examples/${code_path}/server.cpp" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "" >> build2.sh
echo "# copying the SConscript file to the source folder" >> build2.sh
echo "MY_COMMAND=\"cp \${CURPWD}/SConscript \${OCFPATH}/iotivity/examples/${code_path}/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "" >> build2.sh
echo "scons examples/${code_path}" >> build2.sh
echo "" >> build2.sh
echo "#TODO remove this command once the above problem is fixed" >> build2.sh
echo "MY_COMMAND=\"cp \${OCFPATH}/iotivity/out/linux/${ARCH}/release/examples/${code_path}/server /\${CURPWD}/bin/\${PROJNAME}\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "" >> build2.sh
echo "cd \$CURPWD" >> build2.sh

# create the build2 script with the correct OS stuff for IoTivity-lite
cd ${CURPWD}/Project-Scripts/IoTivity-lite
echo "#!/bin/bash" > build2.sh
echo "CURPWD=\`pwd\`" >> build2.sh
echo "PROJNAME=\${PWD##*/}" >> build2.sh
echo "" >> build2.sh
echo "#TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build2.sh
echo "MY_COMMAND=\"cp \${CURPWD}/src/\${PROJNAME}.c \${OCFPATH}/iotivity-lite/apps/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "" >> build2.sh
echo "# Copying the Makefile file to the executable folder" >> build2.sh
echo "MY_COMMAND=\"cp \${CURPWD}/Makefile \${OCFPATH}/iotivity-lite/port/linux/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "MY_COMMAND=\"cd \${OCFPATH}/iotivity-lite/port/linux/\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "#comment out one of the next lines to build another port" >> build2.sh
for d in ${OCFPATH}/iotivity-lite/port/*/ ; do
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
echo "MY_COMMAND=\"rm -rf \${OCFPATH}/iotivity-lite/port/linux/\${PROJNAME}_creds\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "MY_COMMAND=\"rm \${OCFPATH}/iotivity-lite/apps/\${PROJNAME}.c\"" >> build2.sh
echo "eval \${MY_COMMAND}" >> build2.sh
echo "mv ./\${PROJNAME} /\${CURPWD}/bin/" >> build2.sh
echo "" >> build2.sh
echo "cd \${CURPWD}" >> build2.sh

# make scripts executable
chmod +x ${CURPWD}/Project-Scripts/*.sh
chmod +x ${CURPWD}/Project-Scripts/IoTivity/*.sh
chmod +x ${CURPWD}/Project-Scripts/IoTivity-lite/*.sh

cd ${CURPWD}
