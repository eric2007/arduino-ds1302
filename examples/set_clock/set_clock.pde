// Example sketch for interfacing with the DS1302 timekeeping chip.
//
// Copyright (c) 2009, Matt Sparks
// All rights reserved.
//
// http://quadpoint.org/projects/arduino-ds1302
#include <stdio.h>
#include <string.h>
#include <DS1302.h>

// Set the appropriate digital I/O pin connections. These are the pin
// assignments for the Arduino as well for as the DS1302 chip. See the DS1302
// datasheet:
//
//  http://datasheets.maximintegrated.com/en/ds/DS1302.pdf
static const int kCePin   = 5;  // Chip Enable
static const int kIoPin   = 6;  // Input/Output
static const int kSclkPin = 7;  // Serial Clock

// Create buffers.
char buf[50];
char day[10];

// Create a DS1302 object.
DS1302 rtc(kCePin, kIoPin, kSclkPin);

void print_time() {
  // Get the current time and date from the chip.
  Time t = rtc.time();

  // Name the day of the week.
  memset(day, 0, sizeof(day));  // clear day buffer
  switch (t.day) {
    case 1:
      strcpy(day, "Sunday");
      break;
    case 2:
      strcpy(day, "Monday");
      break;
    case 3:
      strcpy(day, "Tuesday");
      break;
    case 4:
      strcpy(day, "Wednesday");
      break;
    case 5:
      strcpy(day, "Thursday");
      break;
    case 6:
      strcpy(day, "Friday");
      break;
    case 7:
      strcpy(day, "Saturday");
      break;
  }

  // Format the time and date and insert into the temporary buffer.
  snprintf(buf, sizeof(buf), "%s %04d-%02d-%02d %02d:%02d:%02d",
           day,
           t.yr, t.mon, t.date,
           t.hr, t.min, t.sec);

  // Print the formatted string to serial so we can see the time.
  Serial.println(buf);
}

void setup() {
  Serial.begin(9600);

  // Initialize a new chip by turning off write protection and clearing the
  // clock halt flag. These methods needn't always be called. See the DS1302
  // datasheet for details.
  rtc.write_protect(false);
  rtc.halt(false);

  // Make a new time object to set the date and time.
  // Sunday, September 22, 2013 at 01:38:50.
  Time t(2013, 9, 22, 1, 38, 50, Time::kSunday);

  // Set the time and date on the chip.
  rtc.time(t);
}

// Loop and print the time every second.
void loop() {
  print_time();
  delay(1000);
}
