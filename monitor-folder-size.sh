#!/bin/bash

# Monitor the size of a folder and print the current and maximum size in KB.
# It refreshes every second.

MAX_SIZE=0

function printUsage {
  printf "usage: monitor-folder-size.sh [-h|--help] [-r|--refresh]<refresh-rate-in-seconds> <path>\n\n"
  printf "Monitors the size of a folder and print the current and maximum size in KB.\n\n"
  printf "positional arguments:\n"
  printf "  path           The path to monitor the folder size.\n"
  printf "\noptional arguments:\n"
  printf "  -h, --help     Show this help message and exit.\n"
  printf "  -r, --refresh  The number of seconds to wait before each refresh.\n"
  printf "\n\n"
}

while (("$#")); do
  case "$1" in
  -r | --refresh)
    REFRESH="$2"
    shift 2
    ;;
  -h | --help)
    printUsage
    exit 0
    ;;
  -* | --*=)
    echo "Error: Unsupported flag $1" >&2
    exit 1
    ;;
  *)
    PARAMS="$PARAMS $1"
    shift
    ;;
  esac
done
eval set -- "$PARAMS"

FOLDER="$1"
if [ -z "${FOLDER}" ]; then
  printf "ERROR: Invalid path.\n\n" >&2
  printUsage
  exit 1
fi

if [ -z "${REFRESH}" ]; then
  REFRESH=1
fi

echo "Press <CTRL+C> to stop."

while true; do
  if [ -d "$FOLDER" ]; then
    CURRENT_SIZE=$(du -s "$FOLDER" 2>/dev/null | awk '{print $1}')
    if [ "${CURRENT_SIZE}" -gt "${MAX_SIZE}" ]; then
      MAX_SIZE=${CURRENT_SIZE}
    fi
  fi
  echo -ne "\r\033[KCurrent Size: ${CURRENT_SIZE:-0} KB, Max Size: ${MAX_SIZE} KB"
  sleep ${REFRESH}
done
