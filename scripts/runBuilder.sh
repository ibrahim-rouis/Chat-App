#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
( cd $SCRIPT_DIR/.. ; dart run build_runner watch -d)
