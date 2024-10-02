#!/bin/bash

# Wrapped Arduino CLI commands

# Author: Martin Eden
# Last mod.: 2024-09-25

#
# Echo arduino-cli board name for Arduino Uno
#
# Of course I can type "arduino:avr:uno" but I want to keep style.
#
get_uno_board_name() {
  echo "arduino:avr:uno"
}

#
# Echo USB port name by a given port index
#
# Input
#
#   $1 PortIndex =0 -- USB port index for /dev/ttyUSB<>
#
# Sample output
#
#   /dev/ttyUSB0
#
get_port_name() {
  # Port index is the first argument or 0
  local port_index=${1:-0}

  local port_name="/dev/ttyUSB"$port_index

  echo $port_name
}

#
# Compile sketch in current directory for Arduino Uno
#
# Input
#
#   None
#
# Output
#
#   Exit code
#
uno_compile() {
  local board_name=$(get_uno_board_name)

  arduino-cli compile \
    . \
    --fqbn $board_name \
    --clean \
    --quiet \
    --warnings all \
    --build-property \
      compiler.cpp.extra_flags="-std=c++1z -Werror" \

  result=$?

  return $result
}

#
# Upload to Arduino Uno on given USB port
#
# Input
#
#   $1 port_name =get_port_name() -- USB port name. Like "/dev/ttyUSB0".
#
# Output
#
#   Exit code
#
uno_upload() {
  # Port name is the first arg or result of get_port_name()
  local port_name=${1:-$(get_port_name)}

  # Get board name
  local board_name=$(get_uno_board_name)

  arduino-cli upload \
    --fqbn $board_name \
    --port $port_name \

  result=$?

  return $result
}

#
# Start serial monitor on USB port with given speed
#
# Input
#
#   $1 port_name -- USB port name
#   $2 speed =57600 -- Serial UART speed (bps)
#
# Output
#
#   Exit code
#
start_monitor() {
  # Port name is first arg
  local port_name=$1

  # Serial port speed is second arg or 57600
  local speed=${2:-57600}

  arduino-cli monitor \
    --port $port_name \
    --config baudrate=$speed \
    --quiet \

  result=$?

  return $result
}

# 2024-09-25
