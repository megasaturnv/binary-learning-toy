// TODO:
// Fix bug with 16-bit mode showing negative numbers
// Write code to make it show battery level in %
// Show battery level in % on startup
// Add a secret which shows the last 4 digits of millis()
// Add a secret for a simple AND/OR calculator. A change of signed switch saves the first number and selects enter next number. Position of signed switch selects AND/OR (could show AND/OR on screen until a bit is changed). Answer is displayed after toggling DEC/HEX, in either DEC/HEX depending on switch pos
// check values of SEG_A, SEG_B, SEG_C etc. Probably just 1,2,4,8...
// Replace if else if else if else if with switch case

////////////////////
// Basic Settings //
////////////////////
// Use 'true' if you'd like to keep any leading zeros
#define LEADING_ZEROS false

// Set brightness of display between 0 and 100
#define BRIGHTNESS 100


//////////////////
// Defined Pins //
//////////////////
#define SWITCH_128 1
#define SWITCH_64  0
#define SWITCH_32  2
#define SWITCH_16  3
#define SWITCH_8   4
#define SWITCH_4   5
#define SWITCH_2   6
#define SWITCH_1   7

#define DIGIT_1    8
#define DIGIT_2    9
#define DIGIT_3    10
#define DIGIT_4    11

#define SEGMENT_A  12
#define SEGMENT_B  13
#define SEGMENT_C  14 // A0
#define SEGMENT_D  15 // A1
#define SEGMENT_E  16 // A2
#define SEGMENT_F  17 // A3
#define SEGMENT_G  18 // A4
#define SEGMENT_DP 19 // A5

#define SWITCH_SIGNED 20  // A6
#define SWITCH_DEC_HEX 21 // A7




//////////////////////
// Global Variables //
//////////////////////
#include <SevSeg.h>
SevSeg sevseg; // Instantiate a seven segment object

byte switchesPins[] = {SWITCH_128, SWITCH_64, SWITCH_32, SWITCH_16, SWITCH_8, SWITCH_4, SWITCH_2, SWITCH_1};
byte digitPins[] = {DIGIT_1, DIGIT_2, DIGIT_3, DIGIT_4};
byte segmentPins[] = {SEGMENT_A, SEGMENT_B, SEGMENT_C, SEGMENT_D, SEGMENT_E, SEGMENT_F, SEGMENT_G, SEGMENT_DP};

String customText = " custom ";

bool slowmode = false;

///////////////
// Functions //
///////////////
int readSwitches() {
  uint8_t number = 0;

  // Read in the bits
  for (byte i = 0; i < sizeof(switchesPins); i++) {
    bitWrite(number, 7 - i, !digitalRead(switchesPins[i]));
  }

  if (digitalReadA6A7(SWITCH_SIGNED)) {
    // Read in 8 switches as an unsigned binary number
    return int(number);
  } else {
    // Convert unsigned number to a signed number
    return int(int8_t(number));
  }

}

byte readSwitchesUnsigned() {
  byte number = 0;

  // Read in the bits
  for (byte i = 0; i < sizeof(switchesPins); i++) {
    bitWrite(number, 7 - i, !digitalRead(switchesPins[i]));
  }
  return number;
}

//byte segmentStatusByte = 0;
//for (int i = 0; i < 8; i++) {
//  segmentStatusByte += (segmentStatus[i] << (7 - i));
//}

byte readSwitchesByte() {
  byte number = 0;

  // Read in the bits
  for (byte i = 0; i < sizeof(switchesPins); i++) {
    bitWrite(number, 7 - i, !digitalRead(switchesPins[i]));
  }
  return number;
}

bool digitalReadA6A7(byte pin) {
  //A6 and A7 are analogue-only so need special treatment:
  if (analogRead(pin) < 100) {
    return false;
  } else {
    return true;
  }
}

void refreshDisplayForTime(unsigned int argDuration) {
  unsigned long startTime = millis();
  while (millis() < startTime + argDuration ) {
    sevseg.refreshDisplay();
  }
}

void display16BitNumberForever() {
  byte byte16BitNumberLower = 0;
  byte byte16BitNumberUpper = 0;
  unsigned int numberToDisplay = 0;
  while (true) {

    if (digitalReadA6A7(SWITCH_SIGNED)) {
      byte16BitNumberLower = readSwitchesUnsigned();
    } else {
      byte16BitNumberUpper = readSwitchesUnsigned();
    }

    if ((byte16BitNumberLower + (256 * byte16BitNumberUpper)) < 0xFFFF) {
      numberToDisplay = byte16BitNumberLower + (256 * byte16BitNumberUpper);
    } else {
      numberToDisplay = 0xFFFF; //Prevents overflow since sevseg.setNumber accepts a signed int, not unsigned
    }
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      sevseg.setNumber(numberToDisplay); // Display number in decimal
    } else {
      sevseg.setNumber(numberToDisplay, -1, true); // Display number in hexadecimal
    }

    refreshDisplayForTime(50);
  }
}

void displayIndividualSegmentsForever() {
  // http://lenniea.github.io/LED7Seg/class_sev_seg.html
  // https://arduino.stackexchange.com/questions/71851/how-to-control-segments-with-sevseg-library

  byte segmentStatus[4] = {0x00, 0x00, 0x00, 0x00};
  while (true) {
    byte selectedSegment = 0;
    if (!digitalReadA6A7(SWITCH_DEC_HEX)) {
      selectedSegment += 1;
    }
    if (!digitalReadA6A7(SWITCH_SIGNED)) {
      selectedSegment += 2;
    }
    segmentStatus[selectedSegment] = readSwitchesByte();
    sevseg.setSegments(segmentStatus);

    //sevseg.refreshDisplay();
    refreshDisplayForTime(50);
  }
}

void displayText(String argText, unsigned int argDelay) {
  char fourCharsText[] = "erro\0"; // This text should be overwritten in the next loop, so set it to "erro" which can tell us if there's a problem

  for (byte i = 4; i <= argText.length(); i++) {
    argText.substring(i - 4, i).toCharArray(fourCharsText, 5);
    sevseg.setChars(fourCharsText);

    unsigned long startTime = millis();
    while (millis() < startTime + argDelay ) {
      sevseg.refreshDisplay();
    }
  }
}

void displayTextBackwards(String argText, unsigned int argDelay) {
  char fourCharsText[] = "erro\0"; // This text should be overwritten in the next loop, so set it to "erro" which can tell us if there's a problem

  for (byte i = argText.length(); i >= 4; i--) {
    argText.substring(i - 4, i).toCharArray(fourCharsText, 5);
    sevseg.setChars(fourCharsText);

    unsigned long startTime = millis();
    while (millis() < startTime + argDelay ) {
      sevseg.refreshDisplay();
    }
  }
}

void displayTextForever(String argText, unsigned int argDelay) {

  char fourCharsText[] = "erro\0"; // This text should be overwritten in the next loop, so set it to "erro" which can tell us if there's a problem
  byte charNum = 4;
  bool incrementDirection = true;
  while (true) {
    argText.substring(charNum - 4, charNum).toCharArray(fourCharsText, 5);
    sevseg.setChars(fourCharsText);

    unsigned long startTime = millis();
    while (millis() < startTime + argDelay ) {
      sevseg.refreshDisplay();
    }

    if (incrementDirection) {
      charNum++;
    } else {
      charNum--;
    }

    if (charNum == 4 || charNum == argText.length()) {
      incrementDirection = !incrementDirection;
    }
  }
}

void displaySecondsForever() {
  unsigned long startTime = millis();
  while (true) {
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      // Display number in decimal
      sevseg.setNumber(long((millis() - startTime) / 1000.0));
    } else {
      // Display number in Hexadecimal
      sevseg.setNumber(long((millis() - startTime) / 1000.0), -1, true);
    }
    sevseg.refreshDisplay();
  }
}

void displayNumberSlowly(int argNumber, unsigned int argDelayBetweenSegments, unsigned int argDuration) {
  unsigned long startTime = millis();
  while (millis() < startTime + argDuration ) {
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      // Display number in decimal
      sevseg.setNumber(argNumber);
    } else {
      // Display number in decimal
      sevseg.setNumber(argNumber, -1, true);
    }
    delay(argDelayBetweenSegments);
    sevseg.refreshDisplay();
  }
}

double GetInternalTemp(void)
{
  unsigned int wADC;
  double t;

  // The internal temperature has to be used
  // with the internal reference of 1.1V.
  // Channel 8 can not be selected with
  // the analogRead function yet.

  // Set the internal reference and mux.
  ADMUX = (_BV(REFS1) | _BV(REFS0) | _BV(MUX3));
  ADCSRA |= _BV(ADEN);  // enable the ADC

  delay(20);            // wait for voltages to become stable.

  ADCSRA |= _BV(ADSC);  // Start the ADC

  // Detect end-of-conversion
  while (bit_is_set(ADCSRA, ADSC));

  // Reading register "ADCW" takes care of how to read ADCL and ADCH.
  wADC = ADCW;

  // The offset of 324.31 could be wrong. It is just an indication.
  t = (wADC - 324.31 ) / 1.22;

  // The returned temperature is in degrees Celsius.
  return (t);
}

long readVcc() {
  long result;
  // Read 1.1V reference against AVcc
  ADMUX = _BV(REFS0) | _BV(MUX3) | _BV(MUX2) | _BV(MUX1); delay(20); // Wait for Vref to settle
  ADCSRA |= _BV(ADSC); // Convert
  while (bit_is_set(ADCSRA, ADSC));
  result = ADCL;
  result |= ADCH << 8;
  result = 1126400L / result; // Back-calculate AVcc in mV
  return result;
}

void displayVccForever() {
  while (true) {
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      // Display number in decimal
      sevseg.setNumberF(readVcc()/1000.0, 3);
    } else {
      // Display number in Hexadecimal
      sevseg.setNumberF(readVcc()/1000.0, 3, true);
    }
    refreshDisplayForTime(500);
  }
}

void displayVccForeverPercent() {
  while (true) {
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      // Display number in decimal
      sevseg.setNumber(readVcc()/1000);
    } else {
      // Display number in Hexadecimal
      sevseg.setNumber(readVcc()/1000, -1, true);
    }
    refreshDisplayForTime(500);
  }
}

long readTemp() {
  long result;
  // Read temperature sensor against 1.1V reference
  ADMUX = _BV(REFS1) | _BV(REFS0) | _BV(MUX3); delay(20); // Wait for Vref to settle
  ADCSRA |= _BV(ADSC); // Convert
  while (bit_is_set(ADCSRA, ADSC));
  result = ADCL;
  result |= ADCH << 8;
  result = (result - 125) * 1075;
  return result;
}

void displayTempForever() {
  while (true) {
    if (digitalReadA6A7(SWITCH_DEC_HEX)) {
      // Display number in decimal
      sevseg.setNumber(readTemp()/10000);
    } else {
      // Display number in Hexadecimal
      sevseg.setNumber(readTemp()/10000, -1, true);
    }
    refreshDisplayForTime(500);
  }
}

//////////////////
// Main Program //
//////////////////
void setup() {
  for (byte i = 0; i < sizeof(switchesPins); i++) {
    pinMode(switchesPins[i], INPUT_PULLUP);
  }

  byte numDigits = 4; // Todo: Replace with len(digitPins)
  bool resistorsOnSegments = false; // 'false' means resistors are on digit pins
  byte hardwareConfig = COMMON_CATHODE; // See README.md for options
  bool updateWithDelays = false; // Default 'false' is Recommended
  //bool disableDecPoint = true; // Use 'true' if your decimal point doesn't exist or isn't connected
  bool disableDecPoint = false;
  sevseg.begin(hardwareConfig, numDigits, digitPins, segmentPins, resistorsOnSegments,
               updateWithDelays, LEADING_ZEROS, disableDecPoint);
  sevseg.setBrightness(BRIGHTNESS);

  if (readSwitches() == 1) {
    displayText("   16-bit   ", 500);
    display16BitNumberForever();
  } else if (readSwitches() == 2) {
    displayText("   7-seg   ", 500);
    displayIndividualSegmentsForever(); // Secret sevseg control
  } else if (readSwitches() == 4) {
    displayTextForever(customText, 500); // Display customText and scroll on screen
  } else if (readSwitches() == 8) {
    displayText("   counter   ", 500);
    displaySecondsForever();
  } else if (readSwitches() == 16) {
    displayText("   delay   ", 500);
    while (true) {
      if (readSwitches() > 0) {
        displayNumberSlowly(2017, readSwitches(), 100);
      } else {
        displayNumberSlowly(2017, 0, 100);
      }
    }
  } else if (readSwitches() == 32) {
    displayText("   Voltage   ", 500);
    displayVccForever();
  } else if (readSwitches() == 64  ) {
    displayText("   Percent   ", 500);
    displayTextForever("------", 500);
    //displayVccForeverPercent();
  } else if (readSwitches() == 128  ) {
    displayText("   Tenperature   ", 500);
    displayTempForever();
  }
}

void loop() {
  if (digitalReadA6A7(SWITCH_DEC_HEX)) {
    // Display number in decimal
    sevseg.setNumber(readSwitches());
  } else {
    // Display number in Hexadecimal
    sevseg.setNumber(readSwitches(), -1, true);
  }

  refreshDisplayForTime(50);

  //unsigned long startTime = millis();
  //while (millis() < startTime + 100 ) {
  //  sevseg.refreshDisplay();
  //}
}
