#!/bin/bash

CONFIG="demo-config" ./demo_exec.sh
java -jar /Applications/WEKA.app/Contents/Resources/Java/weka.jar
CONFIG="demo-test-config" ./demo_exec.sh
