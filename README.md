# LetThereBeLight

LetThereBeLight demonstrates connecting to a BLE service and turning an LED on/off, or cause it to blink.

This project uses an Arduino UNO with a BLE module and connected LED.
The main view controller displays 2 switches. The power switch will turn the LED on/off. When the LED is on, the blink switch will cause the LED to blink. 
The Bluetooth button can be used to re-attempt connection to the BLE

![Screenshot](/images/app-screenshot.jpeg | width=250)


Requires iOS 11.0.

## Hardware Setup

### Components: 

	1. Arduino Uno
	2. DSD TECH Bluetooth 4.0 BLE module SH-HC-08
	3. LED
	4. Resistor
	5. Jumper wires


### Connections: 

#### SH-HC-08 > Arduino Uno

	* TXD > RX
	* RXD > TX
	* GND > GND
	* EN > 5V

![Full setup](/images/full-setup.JPG)

![Arduino Connections](/images/Arduino-connections.JPG)

#### Arduino Uno > Resistor > LED

	* Arduino Pin 13 > Resistor
	* Resistor > LED Positive (Long) Leg 
	* LED Short leg > Arduino GND

![BlE Connections](/images/BLE-connections.JPG)


The sketch, LED-BLE.ino, needs be loaded on to the Arduino. **Note: You may need to disconnect TX and RX from the Arduino in order to install the sketch.

Attributions:

lighting by mynamepong from the Noun Project

Bluetooth by Aybige from the Noun Project
