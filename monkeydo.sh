#!/bin/bash

pkill simulator

TESTMESSAGE=""
if [ "$1" = "-t" ]
then
  TESTMESSAGE="with unit tests"
fi

: ${CIQ_TARGET:="fenix5plus"}
PROJECT=`basename $PWD`
echo "Running $PROJECT for $CIQ_TARGET in simulator $TESTMESSAGE"
connectiq &
sleep 8
monkeydo ${PROJECT}.prg $CIQ_TARGET $1 &
