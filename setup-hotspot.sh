#!/bin/bash

# modified by JLC to use rpi3-4-hotspot.zip for Rapbian-buster :

cd /tmp || exit
wget -O rpi3-4-hotspot.zip "https://github.com/cjlux/raspoppyfication/raw/master/rpi3-4-hotspot.zip"
unzip rpi3-4-hotspot.zip
rm rpi3-4-hotspot.zip
mv rpi3-4-hotspot-* rpi3-hotspot
cd rpi3-hotspot || exit
./install.sh
cd /tmp || exit
rm -rf rpi3-hotspot

tee /boot/hotspot.txt <<EOF
ssid=Poppy Hotspot
passphrase=poppyproject
EOF
