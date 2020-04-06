#!/usr/bin/env bash

# version modified by JLC for RPi4 2020/02/13
#
# install_custom_raspiconfig() seems to be obsolete for RPi4
#

username=$1
password=$2

#JLC osbolete> install_custom_raspiconfig()
#JLC osbolete> {
#JLC osbolete>     wget https://raw.githubusercontent.com/poppy-project/raspi-config/master/raspi-config
#JLC osbolete>     chmod +x raspi-config
#JLC osbolete>     sudo chown root:root raspi-config
#JLC osbolete>     sudo mv raspi-config /usr/bin/
#JLC osbolete> }

setup_user()
{
    username=$1
    password=$2

    echo -e "\e[33mCreate a user \e[4m$username\e[0m."

    pass=$(perl -e 'print crypt($ARGV[0], "password")' "$password")
    sudo useradd -m -p "$pass" -s /bin/bash "$username"

    # copy groups from pi user
    user_groups=$(id -Gn pi)
    user_groups=${user_groups// /,}
    sudo usermod -a -G "$user_groups" "$username"

    echo "$username ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/011_poppy-nopasswd
}

system_setup()
{
    # Change password for pi user
    sudo usermod -p "$(mkpasswd --method=sha-512 raspoppy)" pi

    # Add more langs (GB, US, FR)
    sudo sed -i 's/^#\s*\(en_GB.UTF-8 UTF-8\)/\1/g' /etc/locale.gen
    sudo sed -i 's/^#\s*\(en_US.UTF-8 UTF-8\)/\1/g' /etc/locale.gen
    sudo sed -i 's/^#\s*\(fr_FR.UTF-8 UTF-8\)/\1/g' /etc/locale.gen
    sudo locale-gen

    #JLC osbolete for RPi4> echo -e "\e[33mEnable camera.\e[0m"
    #JLC osbolete for RPi4> echo "start_x=1" | sudo tee --append /boot/config.txt
    #JLC osbolete for RPi4> echo "bcm2835-v4l2" | sudo tee /etc/modules-load.d/bcm2835-v4l2.conf

    #JLC osbolete for RPi4> echo -e "\e[33mSetup serial communication.\e[0m"
    #JLC osbolete for RPi4> sudo raspi-config --disable-serial-log
    #JLC osbolete for RPi4> sudo tee --append /boot/config.txt > /dev/null <<EOF
    #JLC osbolete for RPi4> init_uart_clock=16000000
    #  JLC osbolete for RPi4> dtoverlay=pi3-miniuart-bt
    #JLC osbolete for RPi4> EOF
}

install_additional_packages()
{
    sudo apt-get update

    sudo apt-get install -y \
        build-essential unzip whois \
        network-manager \
        git \
        samba samba-common avahi-autoipd avahi-utils \
        libxslt-dev \
        python3-venv

    # board version utility
    #JLC obsolete for RPi4> wget https://github.com/damiencaselli/hrpi-version/archive/1.0.1.zip -O hrpi-version.zip
    #JLC obsolete for RPi4> unzip hrpi-version.zip
    sudo cp hrpi-version-2.sh /usr/bin/hrpi-version
    sudo chmod +x /usr/bin/hrpi-version
    #JLC osbolete for RPi4> rm hrpi-version.zip
    #JLC osbolete for RPi4> rm -rf hrpi-version-1.0.1
}

setup_network_tools()
{
    # samba
    sudo sed -i 's/map to guest = .*/map to guest = never/g' /etc/samba/smb.conf
    (echo "poppy"; echo "poppy") | sudo smbpasswd -s -a poppy

    # avahi services
    sudo tee /etc/avahi/services/ssh.service <<EOF
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">SSH on %h</name>
  <service>
    <type>_ssh._tcp</type>
    <port>22</port>
  </service>
  <service>
    <type>_sftp-ssh._tcp</type>
    <port>22</port>
  </service>
</service-group>
EOF

    sudo tee /etc/avahi/services/poppy.service <<EOF
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">poppy on %h</name>
  <service>
    <type>_poppy-robot._tcp</type>
    <port>9</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>0</port>
  </service>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
</service-group>
EOF
}

#JLC osbolete> install_custom_raspiconfig
install_additional_packages
setup_user "$username" "$password"
system_setup
setup_network_tools
