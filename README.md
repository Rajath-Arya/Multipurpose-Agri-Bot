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


---

## Radar System Module

*Purpose:* Detects obstacles and uses the Processing interface for visualization.

<img ![RadarSystem_CircuitDiagram png](https://github.com/user-attachments/assets/3d9c67ac-6a00-43f6-aa3d-273d2aa10c2a)">


## Soil Moisture & Irrigation Module

*Purpose:* Detects soil dryness and triggers water pump automatically.

<![SoilMoistureSystem_CircuitDiagram](https://github.com/user-attachments/assets/8f4caff1-9f8f-45f4-bac6-8d65bf744231)>



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
