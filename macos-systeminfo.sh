#!/bin/bash

# Date format
time=`date +%m-%d-%Y`

# Set name to be computername-date
folder="$(scutil --get ComputerName)-($time)"

# Get to correct directory from inside the .app
dir=$(echo "$PWD" | sed 's#macOS-Systeminfo.app/Contents/Resources$##')

# Create and set output directory
output="$dir""$folder"

cd "$dir"

if [ -d "$output" ]
then
    rm -rf "$output"
fi

if [ -f "$output".zip ]
then
    rm -rf "$output".zip
fi

mkdir -p "$output"

echo "Gathering System Information..."

# JAMF log
if [ -f "/var/log/jamf.log" ]
then
	cp /var/log/jamf.log "$output/jamf.log"
fi

# System log
if [ -f "/var/log/system.log" ]
then
    cp /var/log/system.log "$output/system.log"
fi

# Wifi log
if [ -f "/var/log/wifi.log" ]
then
    cp /var/log/wifi.log "$output/wifi.log"
fi

# Kernel Panic Reports
cp /Library/Logs/DiagnosticReports/Kernel*.panic "$output"

# Printers and corresponding connection info
lpstat -s > "$output/printers.txt"

# Network devices and associated MACs
networksetup -listallhardwareports > "$output/network-devices.txt"

# System Profile
system_profiler -xml > "$output/system-profile.spx"

# Compress folder
echo "Compressing folder..."

zip -r -X "$folder".zip "$folder" > /dev/null

# If compression was successful, remove the original folder
if [ $? -eq "0" ]
then
    rm -rf "$folder"
    printf "\r\n"
    echo "The System Report has been placed in $output.zip"
else
    printf "\r\n"
    echo "Compression Failed!"
    printf "\r\n"
    echo "The System Report has been placed in $output"
fi

printf "\r\n"
echo "Press Quit To Exit"
exit
