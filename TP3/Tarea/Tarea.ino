// Basic demo for accelerometer readings from Adafruit MPU6050

#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <Servo.h>
#include <NewPing.h>

#define PERIOD 20000  // período correspondiente a una frecuencia de 50Hz
#define ALPHA 0.1f
#define MIN_SERVO_US 550     // 0° de rotación del servo
#define MAX_SERVO_US 2470    // 180° de rotación del servo
#define MIN_SERVO_ANGLE 60   // Ángulo mínimo del servo que admite la planta
#define MAX_SERVO_ANGLE 150  // Ángulo máximo del servo que admite la planta
#define SERVO_OFFSET 13 // Offset de la IMU respecto del servo
#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 200
#define SOUND_SPEED 340.29f
#define DISTANCE_OFFSET 15.38f
#define IMU_OFFSET 2.1f

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);
Servo myservo;
Adafruit_MPU6050 mpu;

unsigned long t1;
int counter = 0;
float u = 0;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta_c = 0;
float theta = 0;

float a1 = 1;
float a2 = 0.02;
float a3 = 0;
float a4 = 0;
float a5 = 0;
float a6 = 0.8124;
float a7 = -0.6;
float a8 = 0;
float a9 = 0;
float a10 = 0;
float a11 = 1;
float a12 = 0.02;
float a13 = 0;
float a14 = 0;
float a15 = -2.0480;
float a16 = 0.6;

float b1 = 0;
float b2 = 0;
float b3 = 0;
float b4 = 0.97;

float theta_k = 0;
float theta_k1 = 0;

float theta_dot_k = 0;
float theta_dot_k1 = 0;

float p_k = 0;
float p_k1 = 0;

float p_dot_k = 0;
float p_dot_k1 = 0;

float y_theta_k = 0;
float y_p_k = 0;

float l1 = 0.6709;
float l2 = 0.1353;
float l3 = 2.8563;
float l4 = 1.1237;
float l5 = 0.0078;
float l6 = 0.4742;
float l7 = 0.009;
float l8 = -2.0056;

void setup(void) {
  Serial.begin(115200);
  while (!Serial)
    delay(10);  // will pause Zero, Leonardo, etc until serial console opens

  Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
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

  writeServo(0);
}

void loop() {
  t1 = micros();

  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  theta_g1 = theta_g1 + g.gyro.x * 0.02 * (180 / PI);
  theta_a = atan2(a.acceleration.y, a.acceleration.z) * (180 / PI);

  theta_g = theta_c + g.gyro.x * 0.02 * (180 / PI);
  theta_c = ALPHA * theta_a + (1 - ALPHA) * theta_g;

  float theta = theta_c + IMU_OFFSET;
  float theta_dot = g.gyro.x * (180 / PI);

  unsigned int time = sonar.ping(40);
  float p = (((time * SOUND_SPEED) / 10000) / 2) - DISTANCE_OFFSET;
  
  y_theta_k = theta_k;
  y_p_k = p_k;

  theta_k1 = a1 * theta_k + a2 * theta_dot_k + a3 * p_k + a4 * p_dot_k + l1 * (theta - y_theta_k) + l2 * (p - y_p_k) + b1 * u;
  theta_dot_k1 = a5 * theta_k + a6 * theta_dot_k + a7 * p_k + a8 * p_dot_k + l3 * (theta - y_theta_k) + l4 * (p - y_p_k) + b2 * u;
  p_k1 = a9 * theta_k + a10 * theta_dot_k + a11 * p_k + a12 * p_dot_k + l5 * (theta - y_theta_k) + l6 * (p - y_p_k) + b3 * u;
  p_dot_k1 = a13 * theta_k + a14 * theta_dot_k + a15 * p_k + a16 * p_dot_k + l7 * (theta - y_theta_k) + l8 * (p - y_p_k) + b4 * u;

  matlab_send(theta, theta_k, theta_dot, theta_dot_k, p, p_k, p_dot_k);

  theta_k = theta_k1;
  theta_dot_k = theta_dot_k1;
  p_k = p_k1;
  p_dot_k = p_dot_k1;

  if (counter == 500) {
    u = 10;
    writeServo(u);
    counter++;
  } else if (counter == 550){
    u = 0;
    writeServo(u);
    counter = 0;
  }
  else {
    counter++;
  }

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

void matlab_send(float dato1, float dato2, float dato3, float dato4, float dato5, float dato6, float dato7) {
  Serial.write("abcd");
  byte *b1 = (byte *)&dato1;
  Serial.write(b1, 4);
  byte *b2 = (byte *)&dato2;
  Serial.write(b2, 4);
  byte *b3 = (byte *)&dato3;
  Serial.write(b3, 4);
  byte *b4 = (byte *)&dato4;
  Serial.write(b4, 4);
  byte *b5 = (byte *)&dato5;
  Serial.write(b5, 4);
  byte *b6 = (byte *)&dato6;
  Serial.write(b6, 4);
  byte *b7 = (byte *)&dato7;
  Serial.write(b7, 4);
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}