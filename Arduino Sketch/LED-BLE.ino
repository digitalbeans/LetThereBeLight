/*
  LED-BLE

  Reads input from BLE and turns on/off or blinks the connected LED.
  LED is connected on Pin 13 of the Arduino.
*/

// set ledPin to on-board LED
const int ledPin = 13; 
char data = 0;
// flag to indicate blinking is enabled
bool blink = false;
// last time LED was updated
unsigned long previousMillis = 0;
// interval at which to blink (milliseconds)
const long interval = 1000;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  Serial.println(F("LED-BLE start"));
}

// the loop function runs over and over again forever
void loop() {

  // if available, read input from BLE
  if(Serial.available()>0)// if get data 
  {
    // read char from BLE
    char c=Serial.read(); 
    Serial.println("char: " + c);
    if (c == '0') {
      blink = false;
      digitalWrite(ledPin, LOW);
    }
    else if (c == '1') {
      digitalWrite(ledPin, HIGH);
    }
    else if (c == '2') {
      blink = true;
    }
    else if (c == '3') {
      blink = false;
      digitalWrite(ledPin, HIGH);
    }
  }

  // Check if blink interval has elapsed and turn LED on/off
  if (blink) {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;

      if (digitalRead(ledPin) == LOW) {
        digitalWrite(ledPin, HIGH);   // turn the LED on
        Serial.println(F("LED On"));
      }
      else if (digitalRead(ledPin) == HIGH) {
        digitalWrite(ledPin, LOW);    // turn the LED off
        Serial.println(F("LED Off"));
      }
    }
  }
}
