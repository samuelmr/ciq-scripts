#!/bin/bash

TARGETS=($(ls -1 "${CIQ_HOME}../../devices"))
PROJECT=`basename $PWD`

BETAMC="$CIQ_HOME/bin/monkeyc"
BETAVERSION=`"$BETAMC" --version |sed -e 's/.*version //'`

echo "Compiling $PROJECT beta releases with $BETAVERSION for various devices"
BETAFILE="releases/${PROJECT}-${BETAVERSION}.iq"
echo $BETAFILE
"$BETAMC" -f beta.jungle -e -y $CIQ_KEYFILE -o ${BETAFILE}

for TARGET in "${TARGETS[@]}"
do
  OUTFILE="releases/${PROJECT}-${BETAVERSION}-${TARGET}.prg"
  echo $OUTFILE
  "$BETAMC" -f beta.jungle -d ${TARGET} -y $CIQ_KEYFILE -o ${OUTFILE}
done
echo "Finished!"
