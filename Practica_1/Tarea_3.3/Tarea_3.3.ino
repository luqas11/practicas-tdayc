#include <Servo.h>

#define ANALOG_PIN A0
#define MAX_ADC_VALUE 1023
#define MAX_SERVO_POSITION 180.0f
#define PERIOD 1000000 // período correspondiente a una frecuencia de 1Hz
//#define PERIOD 100000 // período correspondiente a una frecuencia de 10Hz
//##define PERIOD 20000 // período correspondiente a una frecuencia de 50Hz

Servo myservo; // los valores extremos de nuestro servo son 550us y 2470us

unsigned long t1;
unsigned long t2;

void setup() {
  Serial.begin(9600);
  myservo.attach(9);
}

void loop() {
  t1 = micros();
  int sensorValue = analogRead(ANALOG_PIN);
  int servoAngle = sensorValue * MAX_SERVO_POSITION / MAX_ADC_VALUE;
  Serial.println(servoAngle);
  myservo.write(servoAngle);
  while (micros() < t1 + PERIOD){};
}
