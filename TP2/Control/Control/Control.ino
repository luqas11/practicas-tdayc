#include <NewPing.h>
#include <Wire.h>
#include <Servo.h>

#define PERIOD 20000  // período correspondiente a una frecuencia de 50Hz
#define MIN_SERVO_US 550     // 0° de rotación del servo
#define MAX_SERVO_US 2470    // 180° de rotación del servo
#define MIN_SERVO_ANGLE 50   // Ángulo mínimo del servo que admite la planta
#define MAX_SERVO_ANGLE 130  // Ángulo máximo del servo que admite la planta
#define SERVO_OFFSET 1.5     // Offset de la IMU respecto del servo
#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 200
#define SOUND_SPEED 340.29f
#define DISTANCE_OFFSET 15.38f

Servo myservo;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

unsigned long t1;
int counter = 0;
float value = 90;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta = 0;

float ek1 = 0;
float eac1 = 0;
float position_ref = -5;
float T = 0.02;
float k0 = 3.2;
float kp = k0*0.4;
float ki = k0*0.2;
float kd = kp*0.0001;
float ik1 = 0;
float dk1 = 0;

void setup(void) {
  Serial.begin(115200);
  while (!Serial)
    delay(10);  // will pause Zero, Leonardo, etc until serial console opens

  delay(100);
  myservo.attach(5);
}

void loop() {
  t1 = micros();

  unsigned int time = sonar.ping(40);
  float position = (((time * SOUND_SPEED) / 10000) / 2) - DISTANCE_OFFSET;

  if (counter == 500) {
    counter = 0;
    if (position_ref == -5) {
      position_ref = 5;
    } else {
      position_ref = -5;
    }
  } else {
    counter++;
  }

  // Calcular error
  float ek = position_ref - position;

  // Bilineal
  float uk = kp * ek + ki*(ik1 + T*ek/2 + T*ek1/2) + kd*(2*(ek - ek1)/T - dk1);
  dk1 = 2*(ek - ek1)/T - dk1;
  ik1 = ik1 + ek*T/2 + ek1*T/2;

  // Actualizar error
  ek1 = ek;

  writeServo(-uk);
  matlab_send(position, position_ref);
  //Serial.println(position_ref);

  while (micros() < t1 + PERIOD) {};
}

void writeServo(float angle) {
  float value = angle - SERVO_OFFSET + 90;

  if (value < MIN_SERVO_ANGLE) {
    value = MIN_SERVO_ANGLE;
  }
  if (value > MAX_SERVO_ANGLE) {
    value = MAX_SERVO_ANGLE;
  }

  float valueMicros = value * ((MAX_SERVO_US - MIN_SERVO_US) / 180) + MIN_SERVO_US;
  myservo.writeMicroseconds(valueMicros);
}

void matlab_send(float dato1, float dato2) {
  Serial.write("abcd");
  byte *b1 = (byte *)&dato1;
  Serial.write(b1, 4);
  byte *b2 = (byte *)&dato2;
  Serial.write(b2, 4);
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}
