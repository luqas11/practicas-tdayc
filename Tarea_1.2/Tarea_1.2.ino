#define ANALOG_PIN A0
#define MAX_ADC_VALUE 1023
#define MAX_ANGLE 279.0f

// Para obtener el ángulo máximo del pote:
// alpha = 170
// alpha + 180° = 830
// Entonces:
// 660 = 180°
// 1023 = 279°

void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(ANALOG_PIN);
  float angle = sensorValue * MAX_ANGLE / MAX_ADC_VALUE;
  Serial.println(angle);
}
