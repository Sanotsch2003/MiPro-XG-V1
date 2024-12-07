# Serial Port Access Manual

When you have problems with permissions on linux systems you can run

```bash
ls -l /dev/ttyUSB* 
```

to list all available USB-devices.

Check the permissions of the serial device. You will see output similar to this:

```bash
crw-rw---- 1 root dialout 188, 0 Dec 6 10:00 /dev/ttyUSB0
```

The device is owned by the `root` user and the `dialout` group. In order give yourself permissions to use the serial port, run

```bash
sudo usermod -a -G dialout $USER
```

Alternatively, you can run:


```bash
sudo usermod -a -G uucp $USER
```

You need to reboot for the changes to take effect.
