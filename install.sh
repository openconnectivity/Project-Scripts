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

if [[ ! -v OCFPATH ]]; then
    export OCFSUBPATH=/iot
    echo "export OCFSUBPATH=${OCFSUBPATH}" >> ~/.bashrc

    export OCFPATH=${HOME}${OCFSUBPATH}
    echo "export OCFPATH=${OCFPATH}" >> ~/.bashrc

    export PATH=${OCFPATH}:${PATH}
    echo "export PATH=${OCFPATH}":'$PATH' >> ~/.bashrc
fi

git clone https://github.com/openconnectivity/Project-Scripts.git

MY_COMMAND="cp ./Project-Scripts/IoTivity/*.sh ${OCFPATH}/../iot/"
eval ${MY_COMMAND}

MY_COMMAND="cp ./Project-Scripts/IoTivity-lite/*.sh ${OCFPATH}/../iot-lite/"
eval ${MY_COMMAND}

cd $CURPWD
