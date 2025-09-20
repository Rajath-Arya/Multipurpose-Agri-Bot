#include <Servo.h>
#define TRIG_PIN 9
#define ECHO_PIN 10
#define SERVO_PIN 6

Servo myServo;

void setup() {
  Serial.begin(9600);
  myServo.attach(SERVO_PIN);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  for (int angle = 0; angle <= 180; angle += 2) {
    myServo.write(angle);
    delay(30);
    long duration, distance;
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);
    duration = pulseIn(ECHO_PIN, HIGH);
    distance = duration * 0.034 / 2;
    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);
    delay(20);
  }
  for (int angle = 180; angle >= 0; angle -= 2) {
    myServo.write(angle);
    delay(30);
    long duration, distance;
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);
    duration = pulseIn(ECHO_PIN, HIGH);
    distance = duration * 0.034 / 2;
    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);
    delay(20);
  }
}
