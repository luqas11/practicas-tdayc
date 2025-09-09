// Basic demo for accelerometer readings from Adafruit MPU6050

#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

#define PERIOD 20000 // período correspondiente a una frecuencia de 50Hz
#define ALPHA 0.1f

unsigned long t1;
int counter = 0;

Adafruit_MPU6050 mpu;

float theta_g1 = 0;
float theta_g = 0;
float theta_a = 0;
float theta = 0;

void setup(void) {
  Serial.begin(115200);
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

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
}

void loop() {
  t1 = micros();

  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  theta_g1 = theta_g1 + g.gyro.x * 0.02 * (180 / PI);
  theta_a = atan2(a.acceleration.y, a.acceleration.z) * (180 / PI);

  theta_g = theta + g.gyro.x * 0.02 * (180 / PI);
  theta = ALPHA * theta_a + (1-ALPHA) * theta_g;

  if (counter == 0){
    counter = 0;
    matlab_send(theta_g, theta_a, theta);
  } else {
    counter++;
  }

  /* Print out the values */
  Serial.print("Ángulo (giroscopio): ");
  Serial.print(theta_g);
  Serial.println("°");

  Serial.print("Ángulo (acelerómetro): ");
  Serial.print(theta_a);
  Serial.println("°");

  Serial.print("Ángulo (complementario): ");
  Serial.print(theta);
  Serial.println("°");

  Serial.println("");
  //delay(500);
  while (micros() < t1 + PERIOD){};
}

void matlab_send(float dato1, float dato2, float dato3){
  Serial.write("abcd");
  byte * b = (byte *) &dato1;
  Serial.write(b,4);
  b = (byte *) &dato2;
  Serial.write(b,4);
  b = (byte *) &dato3;
  Serial.write(b,4);
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}