 #!/bin/bash

TEST=""
TESTMESSAGE=""
if [ "$1" = "-t" ]
then
  TEST="--unit-test"
  TESTMESSAGE="with unit tests"
fi
JUNGLEFILE=${2:-monkey.jungle}

: ${CIQ_TARGET:="fenix5plus"}
PROJECT=`basename $PWD`
TARGETPOSTFIX=""
if [ $CIQ_TARGET = "fr920xt" ]
then
  TARGETPOSTFIX="_sim"
fi
echo "Compiling $PROJECT for ${CIQ_TARGET}${TARGETPOSTFIX} $TESTMESSAGE"
monkeyc -f $JUNGLEFILE -d ${CIQ_TARGET}${TARGETPOSTFIX} -y $CIQ_KEYFILE -o ${PROJECT}.prg $TEST
