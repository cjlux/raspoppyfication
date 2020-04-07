# raspoppyfication

All the files are derived from Pierre ROUANET's initial work : https://github.com/poppy-project/raspoppy

This deposit was initially just a way for me to save the state of the scripts I have modified until they work for the raspoppyfification of a Rpi4. The main modifications are tagged with #JLC inside the scripts.

I have begin to re-write the main script raspoppyfication.sh after the work was done on an RPi4, but I have not yet test if it works or not.

I found taht the script setup-hotspot did'nt work but I had no time to debug it, so I just did the hostspot configuration "by hand"...

# How to use

Log in your Raspberry Pi. You can connect via ssh, VNC or directly plug a screen and a keyboard.

The following **requires the Raspberry Pi to have an internet access**.

```bash
curl -L https://raw.githubusercontent.com/cjlux/raspoppyfication/master/raspoppyfication.sh -o /tmp/raspoppyfication.sh -o /tmp/raspoppyfication.sh
chmod +x /tmp/raspoppyfication.sh
sudo /tmp/raspoppyfication.sh
```

These commands will install all the software detailed above, and set up the control interface. When it's done, reboot the Raspberry Pi and connect to `http://poppy.local`.

The installation script defaults will set the board for a Poppy Ergo Jr, but it can be slightly tailored to suit your needs. `./raspoppyfication.sh --help` displays available options.

Options are:

- `--creature`: Set the robot type (default: `poppy-ergo-jr`)
- `--username`: Set the Poppy user name (default: `poppy`)
- `--password`: Set password for the Poppy user (default: `poppy`)
- `--hostname`: Set the robot hostname (default: `poppy`)
- `--branch`: Install from a given git branch (default: `master`)
- `--shutdown`: Shutdowns the system after installation
- `-?|--help`: Shows help
