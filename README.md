# Multipurpose-Agri-Bot

A multifunctional agricultural robot equipped with a flame sensor, radar system, and automated irrigation. This agribot enhances farm safety, monitors field conditions, and supports precision irrigation, helping to automate essential farming activities for increased productivity and reduced manual effort.

# Features

- Flame sensor module for fire detection and automated water pump activation
- Radar system for obstacle detection and interface (Arduino + Processing)
- Automated irrigation using soil moisture sensor and relay
- Modular, easy-to-adapt system for different agricultural needs

# Hardware Used

- Arduino Uno (or compatible board)
- Flame Sensor Module
- Radar/Ultrasonic Sensor (for obstacle detection)
- Soil Moisture Sensor
- Relay Module(s)
- Water Pump(s)
- Jumper wires, Power supply, Breadboard

# Modules and Circuit Diagrams

## Flame Sensor Module

*Purpose:* Detects fire and starts the water pump automatically.

<img width="500" alt="Flame Sensor Circuit" src="<img width="863" height="584" alt="FlameSensor_CircuitDiagram ino" src="https://github.com/user-attachments/assets/678f8b71-f2bb-456a-aa93-55ff975872f0" />">

**Code:** 
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
})

---

## Radar System Module

*Purpose:* Detects obstacles and uses the Processing interface for visualization.

<img ![RadarSystem_CircuitDiagram png](https://github.com/user-attachments/assets/3d9c67ac-6a00-43f6-aa3d-273d2aa10c2a)">

**Arduino Code:**
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
**Processing Code:**
/**
 * Automatic Arduino Radar System Visualization
 * 
 * This Processing sketch creates a modern radar visualization
 * for the Arduino ultrasonic sensor and servo motor radar system.
 * Features direct connection to COM5 for Arduino radar.
 * With centered interface design.
 */

import processing.serial.*;

// Serial port variables
Serial myPort;
String serialData = "";
boolean isConnected = false;
String[] availablePorts;
int selectedPort = 0;

// Radar display parameters
int radarSize = 600;       // Size of radar display
int centerX, centerY;      // Center of radar display
float lastAngle = 0;       // Last angle received
int lastDistance = 0;      // Last distance received
int maxDistance = 200;     // Maximum distance in cm
int fadeSpeed = 4;         // Speed of trail fade

// Arrays to store radar sweep history
int numReadings = 180;     // Store a full sweep of readings
float[] angles = new float[numReadings];
int[] distances = new int[numReadings];
int[] alphas = new int[numReadings];
int readIndex = 0;

// Auto-reconnect variables
int lastDataTime = 0;
int reconnectDelay = 5000; // 5 seconds
int autoConnectTimer = 0;
int autoConnectInterval = 3000; // Try a new port every 3 seconds

// Color scheme
color backgroundColor = color(10, 25, 47);
color gridColor = color(0, 150, 150, 80);
color radarLineColor = color(0, 255, 100, 200);
color detectionColor = color(0, 255, 50);
color textColor = color(0, 255, 150);
color warningColor = color(255, 50, 50);

// UI elements
boolean showHelp = true;
boolean autoConnect = true;

void setup() {
  size(800, 800);
  smooth(8);
  
  // Calculate center of display - PROPERLY CENTERED
  centerX = width / 2;
  centerY = height / 2;
  
  // Initialize arrays
  for (int i = 0; i < numReadings; i++) {
    angles[i] = 0;
    distances[i] = 0;
    alphas[i] = 0;
  }
  
  // Get available serial ports
  availablePorts = Serial.list();
  
  // Setup font
  textAlign(LEFT, CENTER);
  
  // Start connection process immediately
  tryConnect();
}

void draw() {
  // Draw background
  background(backgroundColor);
  
  // Draw title at the top center
  drawTitle();
  
  // Draw connection status
  drawConnectionStatus();
  
  // Draw radar components
  drawRadarBackground();
  drawHistoricalData();
  drawRadarLine();
  drawCurrentDetection();
  drawInfoPanel();
  
  // Draw help if enabled
  if (showHelp) {
    drawHelp();
  }
  
  // Decrease alpha of all points for fade effect
  updateAlphas();
  
  // Check for lost connection
  checkConnection();
  
  // Auto-connect logic
  if (autoConnect && !isConnected && millis() - autoConnectTimer > autoConnectInterval) {
    tryConnect();
    autoConnectTimer = millis();
  }
}

void tryConnect() {
  try {
    if (myPort != null) {
      myPort.stop();
    }
    
   // Directly connect to COM5 instead of using port selection
    println("Connecting directly to COM8");
    myPort = new Serial(this, "COM8", 9600);
    myPort.bufferUntil('\n');
    isConnected = true;
    lastDataTime = millis();
  } 
  catch (Exception e) {
    println("Failed to connect to COM8: " + e.getMessage());
    isConnected = false;
  }
  
  // Reset auto-connect timer
  autoConnectTimer = millis();
}

void checkConnection() {
  if (isConnected && millis() - lastDataTime > reconnectDelay) {
    println("Connection lost. Attempting to reconnect...");
    isConnected = false;
    tryConnect();
  }
}

void drawTitle() {
  textSize(26);
  fill(textColor);
  textAlign(CENTER, CENTER);
  text("Arduino Radar System", width/2, 30);
  textAlign(LEFT, CENTER);
}

void drawConnectionStatus() {
  textSize(14);
  if (isConnected) {
    fill(0, 255, 0);
    text("Connected to: COM8", 20, 60);
  } else {
    fill(255, 0, 0);
    text("Failed to connect to COM8. Retrying...", 20, 60);
  }
}

void drawRadarBackground() {
  // Draw radar arcs
  noFill();
  stroke(gridColor);
  strokeWeight(1);
  
  for (int i = 1; i <= 4; i++) {
    float radius = (radarSize / 4) * i;
    arc(centerX, centerY, radius, radius, PI, TWO_PI);
  }
  
  // Draw radar grid lines
  for (int angle = 0; angle <= 180; angle += 15) {
    float rad = radians(angle);
    float x = centerX + cos(rad - HALF_PI) * (radarSize / 2);
    float y = centerY + sin(rad - HALF_PI) * (radarSize / 2);
    line(centerX, centerY, x, y);
    
   // Add angle labels
    if (angle % 30 == 0) {
      pushMatrix();
  translate(x, y);
      rotate(rad);
      fill(textColor);
  textSize(12);
      text(angle + "°", 10, 0);
  popMatrix();
  }
  }
  
  // Draw distance labels
  for (int i = 1; i <= 4; i++) {
    float radius = (radarSize / 4) * i;
    float distance = (maxDistance / 4) * i;
    fill(textColor);
    textSize(12);
    text(int(distance) + " cm", centerX - 20, centerY - radius/2 + 10);
  }
}

void drawHistoricalData() {
  // Draw historical detection points
  for (int i = 0; i < numReadings; i++) {
    if (alphas[i] > 0 && distances[i] > 0) {
      float rad = radians(angles[i]);
      float distance = map(distances[i], 0, maxDistance, 0, radarSize/2);
      float x = centerX + cos(rad - HALF_PI) * distance;
      float y = centerY + sin(rad - HALF_PI) * distance;
      
  // Draw point with fade effect
   noStroke();
  fill(0, 255, 0, alphas[i]);
  ellipse(x, y, 8, 8);
      
   // Add echo effect
  fill(0, 255, 0, alphas[i]/4);
   ellipse(x, y, 16, 16);
   }
  }
}

void drawRadarLine() {
  // Draw radar line
  stroke(radarLineColor);
  strokeWeight(2);
  float rad = radians(lastAngle);
  float lineX = centerX + cos(rad - HALF_PI) * (radarSize/2);
  float lineY = centerY + sin(rad - HALF_PI) * (radarSize/2);
  line(centerX, centerY, lineX, lineY);
  
  // Add radial gradient to radar line
  for (int i = 0; i < 5; i++) {
    stroke(radarLineColor, 50 - i*10);
    strokeWeight(2 + i);
    line(centerX, centerY, lineX, lineY);
  }
}

void drawCurrentDetection() {
  // Draw current detection point
  if (lastDistance > 0) {
    float rad = radians(lastAngle);
    float distance = map(lastDistance, 0, maxDistance, 0, radarSize/2);
    float x = centerX + cos(rad - HALF_PI) * distance;
    float y = centerY + sin(rad - HALF_PI) * distance;
    
  // Draw point with glow effect
    for (int i = 3; i > 0; i--) {
      fill(detectionColor, 100 - i*20);
      noStroke();
      ellipse(x, y, 20 - i*5, 20 - i*5);
    }
    
  fill(detectionColor);
    ellipse(x, y, 10, 10);
    
  // Draw distance line
    stroke(detectionColor, 100);
    strokeWeight(1);
    line(centerX, centerY, x, y);
    
  // Show distance text
    fill(textColor);
    textSize(12);
    text(lastDistance + " cm", x + 10, y);
  }
}

void drawInfoPanel() {
  // Draw info panel background - moved to bottom left
  fill(0, 80);
  rect(20, height - 120, 220, 100, 10);
  
  // Draw info panel text
  fill(textColor);
  textSize(16);
  text("Angle: " + int(lastAngle) + "°", 30, height - 100);
  text("Distance: " + lastDistance + " cm", 30, height - 70);
  
  // Draw detection status
  String proximityText = "";
  if (lastDistance > 0 && lastDistance < 30) {
    proximityText = "PROXIMITY ALERT!";
    
   // Blink effect for alert
   if (frameCount % 30 < 15) {
   fill(warningColor);
   } else {
   fill(255, 255, 0);
  }
    
   // Draw alert box
   rect(30, height - 40, 180, 25, 5);
   fill(0);
   textAlign(CENTER, CENTER);
   text(proximityText, 120, height - 28);
   textAlign(LEFT, CENTER);
  } else {
    proximityText = "No objects nearby";
    fill(0, 255, 0);
    text(proximityText, 30, height - 40);
  }
}

void drawHelp() {
  // Draw help overlay - moved to bottom right
  fill(0, 180);
  rect(width - 250, height - 120, 230, 100, 10);
  
  fill(255);
  textSize(14);
  text("Keyboard Controls:", width - 235, height - 100);
  textSize(12);
  text("C - Connect to COM8", width - 235, height - 80);
  text("H - Toggle help", width - 235, height - 60);
  text("R - Reset visualization", width - 235, height - 40);
}

void updateAlphas() {
  // Decrease alpha for fade effect
  for (int i = 0; i < numReadings; i++) {
    if (alphas[i] > 0) {
      alphas[i] -= fadeSpeed;
      if (alphas[i] < 0) alphas[i] = 0;
    }
  }
}

void serialEvent(Serial port) {
  // Read serial data from Arduino
  try {
    serialData = port.readStringUntil('\n');
    serialData = trim(serialData);
    
  // Update last data time
   lastDataTime = millis();
    
   // Parse data
   String[] data = split(serialData, ',');
   if (data.length == 2) {
   float angle = float(data[0]);
  int distance = int(data[1]);
      
   // Only update if values make sense
   if (angle >= 0 && angle <= 180 && distance >= 0) {
   lastAngle = angle;
   lastDistance = distance;
        
   // Store in arrays
   angles[readIndex] = lastAngle;
  distances[readIndex] = lastDistance;
  alphas[readIndex] = 255;
        
   // Move to next position
   readIndex = (readIndex + 1) % numReadings;
    }
   }
  } catch (Exception e) {
    println("Error reading serial data: " + e.getMessage());
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    // Try to connect to COM5
    tryConnect();
  } else if (key == 'h' || key == 'H') {
    // Toggle help
    showHelp = !showHelp;
  } else if (key == 'r' || key == 'R') {
    // Reset visualization
    for (int i = 0; i < numReadings; i++) {
      angles[i] = 0;
      distances[i] = 0;
      alphas[i] = 0;
    }
  }
}

---

## Soil Moisture & Irrigation Module

*Purpose:* Detects soil dryness and triggers water pump automatically.

<![SoilMoistureSystem_CircuitDiagram](https://github.com/user-attachments/assets/8f4caff1-9f8f-45f4-bac6-8d65bf744231)
>

**Code:**
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

---

# How to Set Up

1. Connect modules as shown in the circuit diagrams above, using the appropriate sensors, relays, and pumps.
2. Upload the required code to Arduino for each module.
3. For radar, install Processing and run the Processing app code.
4. Power all modules. Each works independently for its function (fire safety, obstacle detection, automated irrigation).

---

# How Each Module Works

## Flame Sensor
- Flame sensor detects a fire (output LOW).
- Arduino activates relay to turn on water pump.

## Radar System
- Sensor scans environment and sends data to Arduino.
- Processing app receives and displays radar readings in real-time.

## Soil Moisture & Irrigation
- Soil sensor checks moisture level.
- If soil is dry, water pump turns ON automatically.

---
