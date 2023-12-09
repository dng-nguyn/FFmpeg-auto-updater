# FFmpeg-auto-updater
This script updates FFmpeg automatically by downloading BtbN's daily builds using a linux bash file.
## BEFORE USING:
Please take a look at the script and modify the environment variables to your preferences.

This script relies on cron to update ffmpeg daily by adding a `crontab -e` entry, as this script itself does not automatically run on its own.

The files are taken from [BtbN's daily builds](https://github.com/BtbN/FFmpeg-Builds), with the default provided build being latest linux64 GPL. This can be change by modifying the script's environment variable `nano ./script.sh`

Please note that this may create conflicts with your existing FFmpeg installation and may cause unexpected behaviors with certain applications that also use FFmpeg. This script defaults to installing FFmpeg on the user's local directory `/home/$USER/.local/bin`.

## HOW TO RUN:

Clone the repository and change into the directory: 
```sh
git clone https://github.com/dng-nguyn/FFmpeg-auto-updater.git
cd FFmpeg-auto-updater
```
Add execution permission for the script:
```sh
chmod +x script.sh
```
Run the script:
```sh
./script.sh
```
Note that this only run the script once, and not automatically update daily.

## ADDING A CRON ENTRY:

To add a cron entry, please refer to other guides for your updating preferences. This is an example to update your ffmpeg every day at 3AM:

Opening the cron editor:
```sh
crontab -e
```
Add this entry to the file:
```sh
0 3 * * * /bin/bash /path/to/script.sh
```
Please note that you need to modify the `/path/to/script.sh` to your actual path of the script.
