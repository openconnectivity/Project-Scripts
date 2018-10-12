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

NEW_IMPLEMENTATION_DIR=$1

CURPWD=`pwd`

if [ path does not contain "/iot" ]; then
  export PATH="~/iot":${PATH}

# modify the ~/.bashrc file so things are set correctly on boot
  echo "export PATH=~/iot":'$PATH' >> ~/.bashrc
else
  # update the ~/.bashrc file so things are set correctly on boot
  MY_COMMAND="sed -i.bak -e \"s,${OLD_IMPLEMENTATION_DIR},${NEW_IMPLEMENTATION_DIR},g\" ~/.bashrc"
  eval ${MY_COMMAND}
  export PATH=${PATH//${OLD_IMPLEMENTATION_DIR}/${NEW_IMPLEMENTATION_DIR}}
fi

cd $CURPWD
