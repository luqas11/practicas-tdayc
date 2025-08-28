#include <NewPing.h>

#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 200
#define SOUND_SPEED 340.29f

unsigned long t1;
unsigned long t2;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

void setup() {
  Serial.begin(115200);
}

void loop() {
  delay(10);
  t1 = micros();
  unsigned int time = sonar.ping();
  t2 = micros() - t1;
  float distance = (((time * SOUND_SPEED) / 10000) / 2);

  Serial.println(t2);
  Serial.println(distance);
}
