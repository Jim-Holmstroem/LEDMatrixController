import Data.Bits (testBit)

import System.Hardware.Arduino
import System.Environment (getArgs)


rows :: [Int]
rows = [0..7]

cols :: [Int]
cols = [0..7]

dinPin :: Pin
dinPin = pin 8

csPin :: Pin
csPin = pin 9

clkPin :: Pin
clkPin = pin 10

init :: Arduino ()
init = do
    setPinMode clkPin OUTPUT
    setPinMode csPin OUTPUT
    setPinMode dinPin OUTPUT

    delay 50

    writeRaw 0x09 0x00
    writeRaw 0x0a 0x03
    writeRaw 0x0b 0x07
    writeRaw 0x0c 0x01
    writeRaw 0x0f 0x00

clear :: Arduino ()
clear = do
    mapM_ (flip writeRaw 0x00) rows

writeBit :: Word8 -> Word8 -> Arduino ()
writeBit data_ position = do
    digitalWrite clkPin False
    digitalWrite dinPin $ testBit data_ position
    digitalWrite clkPin True

writeByte :: Word8 -> Arduino ()
writeByte data_ = do
  digitalWrite csPin False
  mapM_ (writeBit data_) $ reverse cols
  -- digitalWrite csPin True  ??

writeRaw :: Word8 -> Word8 -> Arduino ()
writeRaw address data_ = do
    digitalWrite csPin True
    writeByte address
    writeByte data_
    digitalWrite csPin False

arduino :: String -> Arduino ()
arduino usb = withArduino True usb $ do
    init
    clear
    whiletrue loop

main = do
    (usb:_) = getArgs
    arduino usb
