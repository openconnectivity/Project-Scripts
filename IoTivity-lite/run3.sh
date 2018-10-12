#!/bin/bash
CURPWD=`pwd`
PROJNAME=${PWD##*/}

cd ./bin

./${PROJNAME}
cd ${CURPWD}
