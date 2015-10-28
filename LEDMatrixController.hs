import Data.Bits (testBit)
import Data.Word (Word8)

import System.Hardware.Arduino
import System.Environment (getArgs)


rows :: [Word8]
rows = [0..7]

cols :: [Word8]
cols = [0..7]

dinPin :: Pin
dinPin = pin 8

csPin :: Pin
csPin = pin 9

clkPin :: Pin
clkPin = pin 10

initMatrix :: Arduino ()
initMatrix = do
    setPinMode clkPin OUTPUT
    setPinMode csPin OUTPUT
    setPinMode dinPin OUTPUT

    setPinMode (pin 6) OUTPUT
    digitalWrite (pin 6) False
    delay 50

    writeRaw 0x09 0x00
    writeRaw 0x0a 0x03
    writeRaw 0x0b 0x07
    writeRaw 0x0c 0x01
    writeRaw 0x0f 0x00
    digitalWrite (pin 6) True

clearMatrix :: Arduino ()
clearMatrix = do
    mapM_ (flip writeRaw 0x00) rows

writeBit :: Word8 -> Word8 -> Arduino ()
writeBit data_ position = do
    digitalWrite clkPin False
    digitalWrite dinPin $ testBit data_ $ fromIntegral position
    digitalWrite clkPin True

writeByte :: Word8 -> Arduino ()
writeByte data_ = do
  mapM_ (writeBit data_) $ reverse cols  -- TODO inner function of writeBit since it only makes sensse inside

writeRaw :: Word8 -> Word8 -> Arduino ()
writeRaw address data_ = do
    digitalWrite csPin True
    writeByte address  -- TODO inner function of writeByte since it only makes sense inside
    writeByte data_
    digitalWrite csPin False

arduino :: String -> IO ()
arduino usb = withArduino True usb $ do
    initMatrix
    clearMatrix

main = do
    (usb:_) <- getArgs
    arduino usb
