const int soilMoisturePin = A0;    // Analog input from soil moisture sensor
const int waterPumpPin = 7;        // Digital output to relay controlling pump
int threshold = 600;               // Adjust this value for your sensor

void setup() {
  pinMode(waterPumpPin, OUTPUT);
  Serial.begin(9600);
  // Start with pump OFF
  digitalWrite(waterPumpPin, LOW);
  Serial.println("Soil moisture system with auto pump initialized.");
}

void loop() {
  int moistureValue = analogRead(soilMoisturePin);

  Serial.print("Moisture Value: ");
  Serial.println(moistureValue);

  if (moistureValue < threshold) {
    Serial.println("Soil is dry. Water pump ON.");
    digitalWrite(waterPumpPin, HIGH);  // Turn ON water pump (relay active)
  } else {
    Serial.println("Soil is wet. Water pump OFF.");
    digitalWrite(waterPumpPin, LOW);   // Turn OFF water pump
  }
  delay(1000);
}
