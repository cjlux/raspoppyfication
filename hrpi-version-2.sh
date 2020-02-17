#!/bin/sh

usage() {
  echo "Usage: $(basename "$0") [-r]
Show a human-readable Raspberry Pi board version based on its revision.

Arguments:
    -h  Show this help text and exit.
    -r  Print the raw board revision." 1>&2;
  exit 1;
}

while getopts "rh" option; do
  case "${option}" in
    r)
      raw=1
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

pi_revision=$(grep -i '^Revision' /proc/cpuinfo | tr -d ' ' | cut -d ':' -f 2)

if [ "$raw" = "1" ]; then
  echo "$pi_revision"
else
  case "$pi_revision" in
    "900092" | "900093")
      echo "rpi-zero"
      ;;
    "a01040" | "a01041" | "a21041" | "a22042")
      echo "rpi-2"
      ;;
    "a02082" | "a22082")
      echo "rpi-3"
      ;;
    "c03111" )
      echo "rpi-4"
      ;;
  esac
fi

exit 0
