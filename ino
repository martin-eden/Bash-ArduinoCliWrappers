#!/bin/bash

# Arduino sketch: compile, upload and start monitor
#
# More specific:
#
#   Compile. If not failed, upload. If not failed, start monitor.
#
# Input
#
#   $1 [port_index] -- USB port index for /dev/ttyUSB<>
#   $2 [speed] -- UART serial speed for monitor
#
# Output
#
#   Exit code:
#
#     0 - OK
#     1 - Compilation failed
#     2 - Upload failed
#     3 - Serial monitor start failed

# Author: Martin Eden
# Last mod.: 2024-09-25

#
# Implementation will use defaults for port index and speed,
# so we can just pass empty strings.
#
port_index=$1
speed=$2

#
# Compile
# (
ino.pile

result=$?

if [ $result -ne 0 ]; then
  exit 1
fi
# )

#
# Upload if okay
# (
ino.load $port_index

result=$?

if [ $result -ne 0 ]; then
  exit 2
fi
# )

#
# Start serial monitor if okay
# (
ino.mon $port_index $speed

result=$?

if [ $result -ne 0 ]; then
  exit 3
fi
# )
