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
