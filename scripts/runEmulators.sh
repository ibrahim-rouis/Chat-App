#!/usr/bin/env bash
echo "Running Firebase emulators..."
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
( cd $SCRIPT_DIR/.. ; firebase emulators:start --export-on-exit=./emulators_data --import=./emulators_data)
