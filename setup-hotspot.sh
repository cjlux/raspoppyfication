#!/bin/bash

# modified vy JLC for RPi4 2020-02-17

if [ "$(hrpi-version)" = "rpi-3" ]; then
    cd /tmp || exit
    wget -O rpi3-hotspot.zip "https://gitlab.inria.fr/dcaselli/rpi3-hotspot/repository/archive.zip?ref=3.0.1"
    unzip rpi3-hotspot.zip
    rm rpi3-hotspot.zip
    mv rpi3-hotspot* rpi3-hotspot
    cd rpi3-hotspot || exit
    ./install.sh
    cd /tmp || exit
    rm -rf rpi3-hotspot

    tee /boot/hotspot.txt <<EOF
ssid=Poppy Hotspot
passphrase=poppyproject
EOF
elif [ "$(hrpi-version)" = "rpi-4" ]; then
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
fi


