#include <Servo.h>

Servo myservo; // los valores extremos de nuestro servo son 550us y 2470us

void setup() {
  myservo.attach(9);
}

void loop() {
  delay(1000);
  myservo.write(0);
  delay(1000);
  myservo.write(90);
  delay(1000);
  myservo.write(180);
  delay(1000);
}
