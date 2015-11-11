import Data.Bits (testBit)
import Data.Word (Word8)

import System.Hardware.Arduino
import System.Environment (getArgs)

import Control.Monad.IO.Class (liftIO)
import Control.Monad (forever)
import Text.Printf (printf)

-- NOTE The serial transmission has good speed _but_ seems to be lagging.. :(
-- @Arduino Nano v3.1
--
-- NOTE The serial transmission seems to be unusably slow ..
-- @Arduino Uno
--
-- NOTE it's undefined what happens just before the program stops its execution
-- there are no guarantees that all the signals already sent will be recieved by
-- the Arduino (or at least seems like it, can perhaps be because of the
-- transmission lagg).

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

    delay 50

    writeRaw 0x09 0x00
    writeRaw 0x0a 0x03
    writeRaw 0x0b 0x07
    writeRaw 0x0c 0x01
    writeRaw 0x0f 0x00

clearMatrix :: Arduino ()
clearMatrix = do
    mapM_ (flip writeRaw 0x00.(+1)) rows

writeBit :: Word8 -> Word8 -> Arduino ()
writeBit data_ position = do
    digitalWrite clkPin False
    digitalWrite dinPin $ testBit data_ $ fromIntegral position
    digitalWrite clkPin True


blinkDuring :: Arduino () -> Arduino ()
blinkDuring m = do
    digitalWrite (pin 6) True
    m
    digitalWrite (pin 6) False


writeByte :: Word8 -> Arduino ()
writeByte data_ = do
  mapM_ (writeBit data_) $ reverse cols  -- TODO inner function of writeBit since it only makes sensse inside

writeRaw :: Word8 -> Word8 -> Arduino ()
writeRaw address data_ = blinkDuring $ do

    liftIO $ putStrLn $ "writeRaw " ++ (printf "%2d" address) ++ " " ++ (printf "%2d" data_)

    digitalWrite csPin False
    writeByte address  -- TODO inner function of writeByte since it only makes sense inside
    writeByte data_
    digitalWrite csPin True


fill :: Word8 -> Arduino ()
fill n = mapM_ (flip writeRaw n.(+1)) rows


arduino :: String -> IO ()
arduino usb = withArduino False usb $ do
    setPinMode (pin 6) OUTPUT
    digitalWrite (pin 6) False

    initMatrix

    clearMatrix

    forever $ mapM_ fill [0..255::Word8]

main = do
    (usb:_) <- getArgs
    arduino usb
