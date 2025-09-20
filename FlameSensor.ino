const int flameSensorPin = 2;      // Digital pin for flame sensor
const int waterPumpPin = 7;        // Digital pin for relay (water pump)

void setup() {
  pinMode(flameSensorPin, INPUT);
  pinMode(waterPumpPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("Flame sensor system with auto pump initialized.");
}

void loop() {
  int sensorValue = digitalRead(flameSensorPin);

  if (sensorValue == LOW) {  // Flame detected (typically LOW signal)
    Serial.println("Flame detected! Water pump activated.");
    digitalWrite(waterPumpPin, HIGH);    // Turn ON water pump (activate relay)
  } else {
    Serial.println("No flame detected. System normal.");
    digitalWrite(waterPumpPin, LOW);     // Turn OFF water pump
  }
  delay(500);
}
