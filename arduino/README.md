# BIRD - Arduino Code

This directory contains all the code required for the Arduino system.

## Setup

### Libraries Used
* [PCM (Pulse-code modulation)](https://github.com/damellis/PCM)

### Setting up the Code
* [Instructions for installing and using PCM](http://highlowtech.org/?p=1963)
* Simplified instructions for installing PCM:
  * Open the Arduino program
  * Navigate to _File_, _Preferences_
  * Note the location of the Arduino sketchbook folder
  * Move the _libraries_ folder in this repository into the aforementioned sketchbook folder
* Open *arduino/car_system/car_system.ino* and *arduino/sensor_system/sensor_system.ino* in two independent Arduino programs

### Setting up the Circuit

#### Arduino Communication
Due to various technical difficulties, we were unable to configure wireless communication for the project. Therefore, communication between the Arduinos is done by connecting the Serial input/output and ground pins ([online instructions here](http://robotic-controls.com/learn/arduino/arduino-arduino-serial-communication)) - in this case, the Serial pins are set to 2 and 3.

Connections:

| Pin on Arduino 1 | Pin on Arduino 2 |
| --- | --- |
| 2 | 3 |
| 3 | 2 |
| GND | GND |

#### Sensor System Schematic

![Sensor system schematic](arduino/img/p-pad.png)

#### Car System Schematic

![Car system schematic](arduino/img/c-box.png)
