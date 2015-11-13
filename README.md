# LEDMatrixController
Connect the LED Matrix kit https://www.sparkfun.com/products/11861 by the instructions for it.

The StandardFirmata version didn't work that good (perhaps due to a missconfiguration of the serialport?). Recommend using the custom serial communication (further down) instead.
Upload StandardFirmata code to the arduino using Arduino IDE and compile and run as below

```bash
ghc --make LEDMatrixController.hs
./LEDMatrixController /dev/ttyUSB0
```

# NOTE
This experiment did not work as expected for some reason so I have abandon it for now.
With Arduino Nano v3.1 it works great for a second then it hangs for about 5 seconds and repeats.
With Arduino Uno it is really slow between each setting of rows, it takes 5 seconds for each row.
I'm guessing it has to do with some a timeout which happens to be 5 seconds just as the lag.


Summary: it's useless in this state (and Firmata is most probably not intended to be used this way), but I have learnt alot.


# Custom serial communication
LEDMatrixController.ino

Send
```
<row> <led-on-0> <led-on-1> <led-on-2> <led-on-3> <led-on-4> <led-on-5> <led-on-6> <led-on-7>
```
to the connected serial with baudrate 115200.
Example to update the leds on row 3, send: 3 1 1 0 0 1 1 0 0
The serial port will respond with
```
<row> <integer-representation-of-leds>
```

see http://playground.arduino.cc/Interfacing/LinuxTTY on how to send data over USB.

For me this worked (where /dev/ttyACM0 is the USB):
```
stty -F /dev/ttyACM0 115200 cs8  # settings
echo -ne "1 1 1 1 0 0 0 1 0\n" > /dev/ttyACM0
```

## Non-trivial Example
```
python waveexample.py > /dev//ttyACM0
```

## Related to
https://github.com/Jim-Holmstroem/LEDMatrixCounter
