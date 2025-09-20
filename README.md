# Multipurpose-Agri-Bot
A multifunctional agricultural robot equipped with a flame sensor, radar system, and automated irrigation. This agribot enhances farm safety, monitors field conditions, and supports precision irrigation, helping to automate essential farming activities for increased productivity and reduced manual effort.

Overview:
This agribot is designed to automate essential farming activities by integrating:
Flame sensor for early fire detection and safety alerts
Radar system for obstacle detection and navigation assistance
Automated irrigation controlled by soil moisture sensing
The system enhances farm safety, improves monitoring of field conditions, and supports precision irrigation to boost productivity and reduce manual labor.

Hardware Components:
Microcontroller: Arduino Uno / ESP32 / Raspberry Pi (choose based on your preference)
Flame Sensor Module
Radar Sensor (e.g., 77-81 GHz millimeter wave radar or ultrasonic sensor as alternative)
Soil Moisture Sensor
Water Pump or Solenoid Valve for irrigation control
Power Supply
Connecting wires and breadboard or PCB

Features:
Continuous monitoring of farm field for fire hazards
Obstacle detection with radar to avoid collisions or field obstacles
Automated irrigation based on soil moisture levels to optimize water use
Alert messaging via serial monitor or wireless module (optional)

Setup Instructions:
Connect sensors and actuators to the microcontroller following the circuit diagram.
Upload the provided code to the microcontroller using Arduino IDE or the appropriate platform.
Power the agribot system.
Monitor outputs on LCD or serial monitor for sensor readings and alerts.
Configure irrigation thresholds in code as per crop needs.

Code Structure:
main.ino - Main Arduino sketch handling sensor reading, decision logic, and actuator control
FlameSensor.h/cpp - Module to interface and process flame sensor data
RadarSensor.h/cpp - Module to read and interpret radar sensor data
IrrigationControl.h/cpp - Module to monitor soil moisture and control irrigation actuators
