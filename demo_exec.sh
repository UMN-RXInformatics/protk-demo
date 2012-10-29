#!/bin/bash

RESULTS="demo.results.TextGrid"

if [ $CONFIG == "demo-test-config" ]; then
    echo "PROTK (TEST MODE)"
    rm sqlite-testing.db
else
    echo "PROTK (MODEL MODE)"
    rm sqlite.db
fi

sleep 1
echo "----- INGESTING DATA -----"
sleep 1

if [ $CONFIG == "demo-test-config" ]; then
    ./ingest.py --textgrid=/opt/data/test/grid-test/ --config=${CONFIG}
else
    ./ingest.py --textgrid=/opt/data/test/grid/ --config=${CONFIG}
fi

sleep 1
echo "----- EXTRACTING FEATURES -----"
sleep 1
./extract.py --formants --execpraat --config=${CONFIG}

sleep 1
echo "----- CREATING ARFF -----"
sleep 1
if [ $CONFIG == "demo-test-config" ]; then
    ./arff.py --target-tier=phone --context=1 --test=demo --config=${CONFIG}
    mv output.arff demo.test.arff
    sleep 1
    echo "----- MERGING TEST RESULTS WITH ORIGINAL -----"
    sleep 1
    ./merge.py --base=SPEAKER0_1.TextGrid --tier=relabel --config=demo-test-config > ${RESULTS}
else
    ./arff.py --target-tier=phone --context=1 --truth-tier=word '--truth-targets=fpu,fpa,<fpu>,<fpa>,fpm,<fpm>' --config=${CONFIG}
    mv output.arff demo.model.arff
fi

sleep 1
echo "----------------------------------"
echo "Completed processing."
if [ $CONFIG == "demo-test-config" ]; then
    echo "> Results TextGrid is named '${RESULTS}'"
else
    echo "> Results ARFF saved to demo.model.arff"
    echo "> USE WEKA TO BUILD A MODEL BEFORE RUNNING AS A TEST
fi
echo "----------------------------------"
