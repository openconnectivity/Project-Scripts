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
# for debugging
# echo "#!/bin/bash -x" > gen.sh
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
echo "# The lines above parse the config file and set everything up for the normal gen.sh stuff below" >> gen.sh
echo "MY_COMMAND=\"cd \${OCFPATH}/DeviceBuilder\"" >> gen.sh
echo "eval \${MY_COMMAND}" >> gen.sh
echo "pwd" >> gen.sh
echo "" >> gen.sh
echo "if [ ! -e \${CURPWD}/devbuildmake ]; then" >> gen.sh
echo "  MY_COMMAND=\"cp \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/devbuildmake \${CURPWD}/\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "fi" >> gen.sh
echo "MY_COMMAND=\"sh ./DeviceBuilder_IotivityLiteServer.sh \${CURPWD}/\${PROJNAME}.json \${CURPWD}/device_output \\\"\${DEVICETYPE}\\\" \\\"\${DEVICENAME}\\\"\"" >> gen.sh
echo "eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "# copying the introspection file to the include folder" >> gen.sh
echo "MY_COMMAND=\"cp -f \${CURPWD}/device_output/code/server_introspection.dat.h \${OCFPATH}/iotivity-lite/include/\"" >> gen.sh
echo "eval \${MY_COMMAND}" >> gen.sh
echo "" >> gen.sh
echo "if [ ! -f ../pki_certs.zip ]; then" >> gen.sh
echo "  # only create when the file does not exist" >> gen.sh
echo "  cd .." >> gen.sh
echo "  MY_COMMAND=\"sh ./pki.sh\"" >> gen.sh
echo "  eval \${MY_COMMAND}" >> gen.sh
echo "fi" >> gen.sh
echo "" >> gen.sh
echo "if [ -e \${CURPWD}/main/\${PROJNAME}.c ];" >> gen.sh
echo "then" >> gen.sh
echo "  cp -f \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/main/\${PROJNAME}-gen.c" >> gen.sh
echo "  if cmp -s \${CURPWD}/main/\${PROJNAME}-gen.c \${CURPWD}/main/\${PROJNAME}-old.c ;" >> gen.sh
echo "  then" >> gen.sh
echo "    echo \"It appears that you have modified the automatically generated source file. main/\${PROJNAME}-gen.c is the file without any of your changes.\"" >> gen.sh
echo "  else" >> gen.sh
echo "    echo \"The source file built by DeviceBuilder changed. You can use diff3 to merge your own modifications.\"" >> gen.sh
echo "    echo \"Example: diff3 -m main/\${PROJNAME}-gen.c main/\${PROJNAME}-old.c main/\${PROJNAME}.c > main/\${PROJNAME}-new.c\"" >> gen.sh
echo "    echo \"Then: cp -f main/\${PROJNAME}-gen.c main/\${PROJNAME}-old.c\"" >> gen.sh
echo "    echo \"And: mv -f main/\${PROJNAME}-new.c main/\${PROJNAME}.c\"" >> gen.sh
echo "  fi" >> gen.sh
echo "else" >> gen.sh
echo "  cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/main/\${PROJNAME}.c" >> gen.sh
echo "  cp \${CURPWD}/device_output/code/simpleserver.c \${CURPWD}/main/\${PROJNAME}-gen.c" >> gen.sh
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
echo "if [ \"\$PLATFORM\" == \"esp32\" ];" >> build.sh
echo "then" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}.c \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/main/vscode-esp32-example.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}-main.c \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/main/main.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/pki_certs.h \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/main/pki_certs.h\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  MY_COMMAND=\"cd \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"idf.py build\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "elif [ \"\$PLATFORM\" == \"arduino\" ];" >> build.sh
echo "then" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}.c \${OCFPATH}/../iotivity-lite/apps/server_devicebuilder.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}-main.cpp \${OCFPATH}/../iotivity-lite/apps/server_arduino.cpp\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  MY_COMMAND=\"cd \${OCFPATH}/../iotivity-lite/port/\${PLATFORM}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"./build_arduino.sh --arch sam --secure\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "else" >> build.sh
echo "  #TODO change this to compile from the project source direcotry, but temporarily copy the souce code over." >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}.c \${OCFPATH}/iotivity-lite/apps/device_builder_server.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"cp \${CURPWD}/main/\${PROJNAME}-main.c \${OCFPATH}/iotivity-lite/apps/device_builder_server-main.c\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "" >> build.sh
echo "  MY_COMMAND=\"cd \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  MY_COMMAND=\"make -f \${CURPWD}/devbuildmake DYNAMIC=1 IPV4=1 device_builder_server\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "  #make -f \${CURPWD}/devbuildmake DYNAMIC=1 device_builder_server" >> build.sh
echo "  #uncomment to make the debug version" >> build.sh
echo "  #make -f \${CURPWD}/devbuildmake DYNAMIC=1 DEBUG=1 device_builder_server" >> build.sh
echo "" >> build.sh
echo "  #TODO remove this command once the above problem is fixed" >> build.sh
echo "  MY_COMMAND=\"cp \${OCFPATH}/iotivity-lite/port/\${PLATFORM}/device_builder_server \${CURPWD}/bin/\${PROJNAME}\"" >> build.sh
echo "  eval \${MY_COMMAND}" >> build.sh
echo "fi" >> build.sh

echo "cd \$CURPWD" >> build.sh

# make scripts executable
chmod +x ${CURPWD}/Project-Scripts/*.sh
#chmod +x ${CURPWD}/Project-Scripts/IoTivity/*.sh
chmod +x ${CURPWD}/Project-Scripts/IoTivity-lite/*.sh

cd ${CURPWD}
