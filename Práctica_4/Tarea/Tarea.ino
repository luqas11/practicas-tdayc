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
#define SERVO_OFFSET 1.5     // Offset de la IMU respecto del servo

Servo myservo;

unsigned long t1;
int counter = 0;
float value = 90;

Adafruit_MPU6050 mpu;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta = 0;

float error_prev = 0;
float theta_servo_prev = 0;

float theta_ref = 0;

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

  matlab_send(theta, theta_ref);

  /* Print out the values */
  Serial.print("Ángulo: ");
  Serial.print(theta);
  Serial.println("°");

  Serial.println("");

  if (counter == 200) {
    counter = 0;
    if (theta_ref == 0) {
      theta_ref = 20;
    } else {
      theta_ref = 0;
    }
  } else {
    counter++;
  }

  float error = theta_ref - theta;
  // Forward
  // float theta_servo = error_prev * 0.2196 + theta_servo_prev;
  // Bilineal
  float theta_servo = 0.5 * (0.2196 * error + 0.2196 * error_prev + 2 * theta_servo_prev);

  writeServo(theta_servo - SERVO_OFFSET);

  theta_servo_prev = theta_servo;
  error_prev = error;

  while (micros() < t1 + PERIOD) {};
}

void writeServo(float angle) {
  float value = angle;

  if (angle < MIN_SERVO_ANGLE) {
    value = MIN_SERVO_ANGLE;
  }
  if (angle > MAX_SERVO_ANGLE) {
    value = MAX_SERVO_ANGLE;
  }

  float angleMicros = angle * ((MAX_SERVO_US - MIN_SERVO_US) / 180) + MIN_SERVO_US;
  myservo.writeMicroseconds(angleMicros);
}

void matlab_send(float dato1, float dato2) {
  Serial.write("abcd");
  byte *b1 = (byte *)&dato1;
  Serial.write(b1, 4);
  byte *b2 = (byte *)&dato2;
  Serial.write(b2, 4);
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}
