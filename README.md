# DellDockAudio

Forces pulseaudio sound device switch via script when docking station detected.

## Why?
I have a Dell WD19 dock and a Latitude 5580 runing Ubuntu 20.04.  When I plug my dock in to my laptop, it switches sound output to the dock's headphone jack rather than the dock's line-out jack.  If I change the sound output device in settings, it will work fine until I unplug the dock. It "forgets" my choice when I plug it back in.

## Info needed for this script to work
If you have the same issue as I described above, there's some info you'll need in order to customize the included files to work with your hardware.
Example output below is cleaned up to only show the relevant needed info...

1. Your Username and UID:
```
echo $USER
johnsmith
echo $UID
9999
```

2. Sound Device names (Set the desired sound devices in the GUI before running this command):
```
pacmd stat
Default sink name: alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink
Default source name: alsa_input.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock__source
```

3. Hardware ID of the docking unit:
```
lsusb
Bus 002 Device 005: ID 0bda:0487 Realtek Semiconductor Corp. Dell dock
```
If your dock isn't as easy to find as the example above, run the command with and without the dock plugged in and compare the devices listed to determine the correct device.

## Customizing the rules file

In step 3 above, the example device listed has a vendor ID of "0bda", and a product ID of "0487".  Use the values of your dock ID and replace these values in the `docksound.rules` file.

## Customizing the script file

Edit `docksound.sh` with the info you gathered in steps 1 and 2, replacing the values **within the quotes** of the following variables:
```
SINK_NAME	corresponds to	"Default sink name"
SOURCE_NAME	corresponds to	"Default source name"
USERNAME	corresponds to	"$USER"
USERID		corresponds to	"$UID"
```
## Putting the files in the right place

You will need root access to put the files where they need to go.  The script will be run as root.  You may need to `chmod +x docksound.sh` to make it executable.

Place `docksound.rules` in `/etc/udev/rules.d/`
Place `docksound.sh` in `/root/`.  If you want to put `docksound.sh` somewhere else, you'll have to change the path in `docksound.rules` to point th the right location.

## Misc
You can `tail -f /tmp/DockPlugEvent.log` to watch detection happen.  When I plug my dock in it gets detected multiple times, which is why the script checks if the desired sound devices are already active before switching.  Each detection fires an instance of the script...


If you know a better way to do this, please let me know.
Thanks
