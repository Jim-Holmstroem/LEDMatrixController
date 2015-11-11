# LEDMatrixController
Connect the LED Matrix kit https://www.sparkfun.com/products/11861 by the instructions for it.
Upload StandardFirmata code to the arduino using Arduino IDE and compile and run as below

```bash
ghc --make LEDMatrixController.hs
./LEDMatrixController /dev/ttyUSB0
```

# NOTE
This experiment did not work as expected for some reason so I have abandon it for now.
With Arduino Nano v3.1 it works great for a second then it hangs for about 5 seconds and repeats.
With Arduino Uno it is really slow between each setting of rows, it takes 5 seconds for each row.
I'm guessing it has to do with some timeout of the communication (which happens to be 5 seconds)


Summary: it's useless in this state.

## Related to
https://github.com/Jim-Holmstroem/LEDMatrixCounter
