// Basic demo for accelerometer readings from Adafruit MPU6050

#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <Servo.h>

#define PERIOD 20000  // período correspondiente a una frecuencia de 50Hz
#define ALPHA 0.1f
#define MIN_SERVO_US 550     // 0° de rotación del servo
#define MAX_SERVO_US 2470    // 180° de rotación del servo
#define MIN_SERVO_ANGLE 60   // Ángulo mínimo del servo que admite la planta
#define MAX_SERVO_ANGLE 150  // Ángulo máximo del servo que admite la planta
#define SERVO_OFFSET 1.5 // Offset de la IMU respecto del servo

Servo myservo;

unsigned long t1;
int counter = 0;
float u = 0;

Adafruit_MPU6050 mpu;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta = 0;

float omega = 0;

float a1 = 1;
float a2 = 0.02;
float a3 = 0;
float a4 = -2.50;
float a5 = 0.68;
float a6 = 0;
float a7 = 0;
float a8 = 0;
float a9 = 1;

float b1 = 0;
float b2 = 0.944;
float b3 = 0;

float theta_k = 0;
float theta_k1 = 0;

float theta_dot_k = 0;
float theta_dot_k1 = 0;

float b_k = 0;
float b_k1 = 0;

float y_k = 0;
float y_dot_k = 0;

float l1 = 0.3832;
float l2 = -0.0060;
float l3 = -2.4899;
float l4 = -0.0182;
float l5 = -0.0380;
float l6 = 0.4947;

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
}

void loop() {
  t1 = micros();

  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  theta_g1 = theta_g1 + g.gyro.x * 0.02 * (180 / PI);
  theta_a = atan2(a.acceleration.y, a.acceleration.z) * (180 / PI);

  theta_g = theta + g.gyro.x * 0.02 * (180 / PI);
  theta = ALPHA * theta_a + (1 - ALPHA) * theta_g;

  omega = g.gyro.x * (180 / PI) + 10;
  
  y_k = theta_k;
  y_dot_k = theta_dot_k + b_k;
  theta_k1 = a1 * theta_k + a2 * theta_dot_k + a3 * b_k + l1 * (theta - y_k) + l2 * (omega - y_dot_k) + b1 * u;
  theta_dot_k1 = a4 * theta_k + a5 * theta_dot_k + a6 * b_k + l3 * (theta - y_k) + l4 * (omega - y_dot_k) + b2 * u;
  b_k1 = a7 * theta_k + a8 * theta_dot_k + a9 * b_k + l5 * (theta - y_k) + l6 * (omega - y_dot_k) + b3 * u;

  matlab_send(u, theta, theta_k, omega, y_dot_k, theta_dot_k, b_k);

  theta_k = theta_k1;
  theta_dot_k = theta_dot_k1;
  b_k = b_k1;

  if (counter == 100) {
    counter = 0;
    if (u == -20) {
      u = 20;
      writeServo(u);
    } else {
      u = -20;
      writeServo(u);
    }
  } else {
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

  float valueMicros = value * ((MAX_SERVO_US - MIN_SERVO_US) / 180) + MIN_SERVO_US;
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
