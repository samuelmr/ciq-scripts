#!/bin/bash

PROJECT=`basename $PWD`
echo "Compiling $PROJECT for submission"
monkeyc -f monkey.jungle -e -y $CIQ_KEYFILE -o ${PROJECT}.iq
