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

CURPWD=`pwd`
SCRIPTPATH=~/Project-Scripts

if [[ ! (${PATH} == *${SCRIPTPATH}*) ]]; then
  # update the PATH environment variable: NEED TO RUN THIS SCRIPT WITH "source set_path.sh"
  export PATH=${SCRIPTPATH}:${PATH}

  # modify the ~/.bashrc file so things are set correctly on boot
  echo "export PATH=${SCRIPTPATH}":'$PATH' >> ~/.bashrc
fi

cd ${CURPWD}
