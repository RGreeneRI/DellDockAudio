#!/bin/bash

# Define Variables
SINK_NAME='alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink'
SOURCE_NAME='alsa_input.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock__source'
USERNAME='johnsmith'
USERID='9999'
PID=$(echo $$)

export PULSE_RUNTIME_PATH="/run/user/$USERID/pulse/"

# Log dock detection
echo "$(date) - [PID:$PID] - Dock detected" >> /tmp/DockPlugEvent.log

# Wait for things to settle after dock is plugged in
sleep 5

# Check to see if desired sound devices are already set, and EXIT without changing IF TRUE
sudo -u $USERNAME -E pacmd stat | grep $SINK_NAME &&
	sudo -u $USERNAME -E pacmd stat | grep $SOURCE_NAME &&
	echo "$(date) - [PID:$PID] - Desired Sound device already active" >> /tmp/DockPlugEvent.log &&
	exit 0

# Change sound Source and Sink to the Docking Station sound device if NOT already set
echo "$(date) - [PID:$PID] - Firing Sound device switch" >> /tmp/DockPlugEvent.log
sudo -u $USERNAME -E pacmd set-default-source "SOURCE_NAME"
sudo -u $USERNAME -E pacmd set-default-sink "$SINK_NAME"
echo "$(date) - [PID:$PID] - Fired Sound device switch" >> /tmp/DockPlugEvent.log
