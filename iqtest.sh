#!/bin/bash

: ${CIQ_TARGET:="fenix5plus"}
PROJECT=`basename $PWD`
TARGETPOSTFIX=""
if [ $CIQ_TARGET = "fr920xt" ]
then
 TARGETPOSTFIX="_sim"
fi
echo "Compiling $PROJECT for ${CIQ_TARGET}${TARGETPOSTFIX} with unit tests"
monkeyc -f monkey.jungle -d ${CIQ_TARGET}${TARGETPOSTFIX} -y $CIQ_KEYFILE -o ${PROJECT}.prg --unit-test
echo "Running $PROJECT for $CIQ_TARGET in simulator with unit tests"
connectiq &
sleep 1
monkeydo ${PROJECT}.prg $CIQ_TARGET -t &
