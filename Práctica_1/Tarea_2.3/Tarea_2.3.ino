#include <NewPing.h>

#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 200
#define SOUND_SPEED 340.29f
#define PERIOD 20000 // período correspondiente a una frecuencia de 50Hz

unsigned long t1;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

void setup() {
  Serial.begin(115200);
}

void loop() {
  t1 = micros();
  unsigned int time = sonar.ping();
  float distance = (((time * SOUND_SPEED) / 10000) / 2);
  Serial.println(distance);
  while (micros() < t1 + PERIOD){};
}
