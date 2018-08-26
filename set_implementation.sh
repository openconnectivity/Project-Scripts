#!/bin/bash
set -x #echo on
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

IMPLEMENTATION_DIR=$1

CURPWD=`pwd`

if [[ ! -v OCFPATH ]]; then
  export OCFPATH="$IMPLEMENTATION_DIR"
  echo "export OCFPATH=$IMPLEMENTATION_DIR" >> ~/.bashrc

  export PATH=$IMPLEMENTATION_DIR:$PATH
  echo "export PATH=${IMPLEMENTATION_DIR}:${PATH}" >> ~/.bashrc
else
  echo "OCFPATH=${OCFPATH}, IMPLEMENTATION_DIR=${IMPLEMENTATION_DIR}"
  sed -i.bak -e "s,${OCFPATH},${IMPLEMENTATION_DIR},g" ~/.bashrc
  echo "past sed..."

#  PATH | sed -e "s:$OCFPATH:$IMPLEMENTATION_DIR:"
  export OCFPATH=$IMPLEMENTATION_DIR
fi

# MY_COMMAND="cp ./Project-Scripts/IoTivity-lite/*.sh ${OCFPATH}/../iot-lite/"
# eval ${MY_COMMAND}

cd $CURPWD
