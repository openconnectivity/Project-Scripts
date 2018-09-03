#!/bin/bash
PROJNAME=$1
MY_COMMAND="mkdir -p ./$PROJNAME"
eval ${MY_COMMAND}
MY_COMMAND="mkdir -p ./$PROJNAME/src"
eval ${MY_COMMAND}
MY_COMMAND="mkdir -p ./$PROJNAME/bin"
eval ${MY_COMMAND}
MY_COMMAND="cp ${OCFPATH}/default.json ./$PROJNAME/$PROJNAME.json"
eval ${MY_COMMAND}
MY_COMMAND="cp ${OCFPATH}/default.Makefile ./$PROJNAME/Makefile"
eval ${MY_COMMAND}

cd $PROJNAME
