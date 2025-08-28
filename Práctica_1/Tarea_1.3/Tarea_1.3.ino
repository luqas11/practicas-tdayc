#define ANALOG_PIN A0
#define MAX_ADC_VALUE 1023
#define MAX_ANGLE 279.0f
#define PERIOD 20000 // período correspondiente a una frecuencia de 50Hz

unsigned long t1;
unsigned long t2;

void setup() {
  Serial.begin(9600);
}

void loop() {
  t1 = micros();
  int sensorValue = analogRead(ANALOG_PIN);
  float angle = sensorValue * MAX_ANGLE / MAX_ADC_VALUE;
  Serial.println(angle);
  while (micros() < t1 + PERIOD){};
}
