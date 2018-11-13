/*
  LED-BLE

  Reads input from BLE and turns on/off or blinks the connected LED.
  LED is connected on Pin 13 of the Arduino.
*/

const int ledPin = 13; // set ledPin to on-board LED
char data = 0;
bool blink = false;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  Serial.println(F("Blink start"));
}

// the loop function runs over and over again forever
void loop() {

  if(Serial.available()>0)// if get data 
  {
    char c=Serial.read(); //read char from BLE
    Serial.println("char: " + c);
    if (c == '0') {
      blink = false;
      digitalWrite(ledPin, LOW);
      Serial.println(F("LED Off"));
    }
    else if (c == '1') {
      digitalWrite(ledPin, HIGH);
      Serial.println(F("LED On"));
    }
    else if (c == '2') {
      blink = true;
    }
    else if (c == '3') {
      blink = false;
      digitalWrite(ledPin, HIGH);
    }
  }

  if (blink) {
    digitalWrite(ledPin, HIGH);   // turn the LED on
    Serial.println(F("LED On"));
    delay(1000);                       // wait for 1 second
    digitalWrite(ledPin, LOW);    // turn the LED off
    Serial.println(F("LED Off"));
    delay(1000);                       // wait for 1 second
  }
}
