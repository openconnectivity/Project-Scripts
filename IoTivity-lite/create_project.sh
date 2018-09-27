#!/bin/bash
PROJNAME=$1
mkdir -p ./${PROJNAME}
mkdir -p ./${PROJNAME}/src
mkdir -p ./${PROJNAME}/bin
cp ${OCFPATH}/default.json ./$PROJNAME/$PROJNAME.json
cp ${OCFPATH}/default.Makefile ./$PROJNAME/Makefile

cd ${PROJNAME}
