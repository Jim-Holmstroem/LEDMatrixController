int Max7219_pinCLK = 10;
int Max7219_pinCS = 9;
int Max7219_pinDIN = 8;


void Write_Max7219_byte(unsigned char data) {
  unsigned char i;
  digitalWrite(Max7219_pinCS, LOW);    
  for(i=8;i>=1;i--) {
    digitalWrite(Max7219_pinCLK, LOW);
    digitalWrite(Max7219_pinDIN, data & 0x80);// Extracting a bit data
    data = data << 1;
    digitalWrite(Max7219_pinCLK, HIGH);
  }
}


void Write_Max7219(unsigned char address, unsigned char data) {
  digitalWrite(Max7219_pinCS, LOW);
  Write_Max7219_byte(address);           //addressï¼Œcode of LED
  Write_Max7219_byte(data);               //dataï¼Œfigure on LED 
  digitalWrite(Max7219_pinCS, HIGH);
}


void Init_MAX7219(void) {
  Write_Max7219(0x09, 0x00);       //decoding ï¼šBCD
  Write_Max7219(0x0a, 0x01);       //brightness 
  Write_Max7219(0x0b, 0x07);       //scanlimitï¼›8 LEDs
  Write_Max7219(0x0c, 0x01);       //power-down modeï¼š0ï¼Œnormal modeï¼š1
  Write_Max7219(0x0f, 0x00);       //test displayï¼š1ï¼›EOTï¼Œdisplayï¼š0
}


void setup() {
  pinMode(Max7219_pinCLK, OUTPUT);
  pinMode(Max7219_pinCS, OUTPUT);
  pinMode(Max7219_pinDIN, OUTPUT);
  delay(50);
  Init_MAX7219();
  for(unsigned char i=0; i<8; i++) {
    Write_Max7219(i+1, 0);
  }
  Serial.begin(115200);
}

int row = 0;
int value = 0;
int i = 0;
int on = 0;

void loop() {
  while (Serial.available() > 0) {
    row = Serial.parseInt();
    value = 0;
    for(i=0; i<8; i++) {
      on = Serial.parseInt();
      value |= on << i;
    }
    Write_Max7219(row+1, value);
    if (Serial.read() == '\n') {
      Serial.print(row, DEC);
      Serial.print(" ");
      Serial.println(value, DEC);
    }
  }
}
