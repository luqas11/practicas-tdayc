// Basic demo for accelerometer readings from Adafruit MPU6050

#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <NewPing.h>
#include <Wire.h>
#include <Servo.h>

#define PERIOD 20000  // período correspondiente a una frecuencia de 50Hz
#define ALPHA 0.1f
#define MIN_SERVO_US 557     // 0° de rotación del servo
#define MAX_SERVO_US 2388    // 180° de rotación del servo
#define MIN_SERVO_ANGLE 50   // Ángulo mínimo del servo que admite la planta
#define MAX_SERVO_ANGLE 130  // Ángulo máximo del servo que admite la planta
#define SERVO_OFFSET 12    // Offset de la barra respecto del servo
#define IMU_OFFSET 3.20 // Offset IMU respecto la barra
#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 200
#define SOUND_SPEED 340.29f
#define DISTANCE_OFFSET 15.65f
#define VALUE_I 0
#define VALUE_F -20

Servo myservo;
Adafruit_MPU6050 mpu;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

unsigned long t1;
int counter = 0;
float value = VALUE_I;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta = 0;

void setup(void) {
  Serial.begin(115200);
  while (!Serial)
    delay(10);

  Serial.println("Adafruit MPU6050 test!");

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);

  Serial.println("");
  delay(100);
  myservo.attach(5);
}

void loop() {
  t1 = micros();

  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  theta_g1 = theta_g1 + g.gyro.x * 0.02 * (180 / PI);
  theta_a = atan2(a.acceleration.y, a.acceleration.z) * (180 / PI);

  theta_g = theta + g.gyro.x * 0.02 * (180 / PI);
  theta = ALPHA * theta_a + (1 - ALPHA) * theta_g;

  unsigned int time = sonar.ping(40);
  float position = (((time * SOUND_SPEED) / 10000) / 2) - DISTANCE_OFFSET;

  if (counter == 500) {
    counter = 0;
    if (value == VALUE_I) {
      value = VALUE_F; 
    } else {
      value = VALUE_I;
    }
  } else {  
    counter++;
  }

  writeServo(value);
  //Serial.println(theta + IMU_OFFSET);
  //Serial.println(position);
  //Serial.println();
  matlab_send(position, theta + IMU_OFFSET , value);

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

  float valueMicros = (value * (MAX_SERVO_US - MIN_SERVO_US)) / 180 + MIN_SERVO_US;
  myservo.writeMicroseconds(valueMicros);
}

void matlab_send(float dato1, float dato2, float dato3) {
  Serial.write("abcd");
  byte *b1 = (byte *)&dato1;
  Serial.write(b1, 4);
  byte *b2 = (byte *)&dato2;
  Serial.write(b2, 4);
  byte *b3 = (byte *)&dato3;
  Serial.write(b3, 4);
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}
