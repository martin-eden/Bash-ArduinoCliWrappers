#!/bin/bash

# Wrapped Arduino CLI commands

# Author: Martin Eden
# Last mod.: 2025-11-29

#
# Return arduino-cli board name for Arduino Uno
#
get_uno_board_name() {
  echo "arduino:avr:uno"
}

#
# Return USB port name by given port index
#
# Input
#
#   $1 =0 - USB port index for /dev/ttyUSB<>
#
# Sample output
#
#   /dev/ttyUSB0
#
get_port_name() {
  local port_index=${1:-0}

  local port_name="/dev/ttyUSB"$port_index

  echo $port_name
}

#
# Compile sketch in current directory for Arduino Uno
#
# Output
#
#   Exit code
#
uno_compile() {
  local board_name=$(get_uno_board_name)

  local output=$( \
    arduino-cli \
      compile \
      . \
      --fqbn $board_name \
      --clean \
      --quiet \
      --warnings all \
      --build-property \
        compiler.cpp.extra_flags="-std=c++1z" \
        # compiler.cpp.extra_flags="-std=c++1z -O1" \
        # compiler.cpp.extra_flags="-std=c++1z -Os" \
        # compiler.cpp.extra_flags="-std=c++1z -Werror" \
    )

  local result=$?

  # Additionally, we filter the list of used libraries from
  # "arduino-cli compile" output. Coincidentally we cut tail lines
  # with platform name.

  output=$( echo "$output" | sed '/Used library/,$d' )

  echo "$output"

  return $result
}

#
# Upload to Arduino Uno on given USB port
#
# Input
#
#   $1 =get_port_name() - USB port name. Like "/dev/ttyUSB0".
#
# Output
#
#   Exit code
#
uno_upload() {
  local port_name=${1:-$(get_port_name)}
  local board_name=$(get_uno_board_name)

  arduino-cli \
    upload \
    --fqbn $board_name \
    --port $port_name \

  local result=$?

  return $result
}

#
# Start serial monitor of USB port with given speed
#
# Input
#
#   $1 - USB port name
#   $2 =115200 - UART speed (bps)
#
# Output
#
#   Exit code
#
start_monitor() {
  local port_name=$1
  local speed=${2:-115200}

  arduino-cli \
    monitor \
    --port $port_name \
    --config baudrate=$speed \
    --quiet \

  local result=$?

  return $result
}

# 2024-09-25
# 2025-09-19 Styling
# 2025-11-28 Dropping useless compile output
