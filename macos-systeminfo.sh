#!/bin/bash

# Date format
DATE=`date +%m-%d-%Y`

# Set name to be computername-date
NAME="$(scutil --get ComputerName)-($DATE)"

# Get to correct directory from inside the .app
cd $(echo "$PWD" | sed 's#macOS-Systeminfo.app/Contents/Resources$##')

# Create and set output directory
output="$PWD"/system-information/"$NAME"
mkdir -p "$output" 2> /dev/null

echo "Gathering System Information..."

# JAMF log
cp /var/log/jamf.log "$output/jamf.txt" 2> /dev/null

# Printers and corresponding connection info
lpstat -s > "$output/printers.txt"

# Network devices and associated MACs
networksetup -listallhardwareports > "$output/network-devices.txt"

# System Profile
system_profiler -xml > "$output/system-profile.spx" 2> /dev/null

printf "\r\n"
echo "The System Report has been placed in $output"
printf "\r\n"
echo "Press Quit To Exit"

exit
