#!/bin/bash

if [ -z "$1" ]; then # empty; use default
  MANIFEST="manifest.xml"
else
  MANIFEST=$1
fi

UUID=`grep entry $MANIFEST | sed -e 's/.*id="\([^"]*\)".*/\1/'`
echo "Getting errors using UUID $UUID"

ERA=`era -k $CIQ_KEYFILE -a $UUID`
