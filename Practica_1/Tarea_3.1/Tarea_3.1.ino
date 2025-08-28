#include <Servo.h>

Servo myservo; // los valores extremos de nuestro servo son 550us y 2470us

void setup() {
  myservo.attach(9);
}

void loop() {
  delay(1000);
  myservo.writeMicroseconds(1000);
  delay(1000);
  myservo.writeMicroseconds(1500);
  delay(1000);
  myservo.writeMicroseconds(2000);
  delay(1000);
}
