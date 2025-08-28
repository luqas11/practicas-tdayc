unsigned long t1;
unsigned long t2;

void setup() {
  Serial.begin(9600);
}

void loop() {
  t1 = micros();
  int sensorValue = analogRead(A0); // 110us aproximado, considerando que micros() y las asignaciones toma tiempo
  t2 = micros() - t1;
  Serial.println(sensorValue);
  Serial.println(t2);
}
