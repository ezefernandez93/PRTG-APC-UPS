# PRTG-APC-UPS
PRTG custom sensor to get data from APC PowerChute Personal Edition

![Preview](https://raw.github.com/YandereSkylar/PRTG-APC-UPS/master/sensor.png)

## Dependencies
* Perl

* APC PowerChute Personal Edition, in its default install directory or $logpath changed to where you put it.  Powerchute must be running, or it won't produce the log file.
* ```tail``` from GNU Coreutils in the system path

## Known issues
* Occasionally it returns blank data for no apparent reason
