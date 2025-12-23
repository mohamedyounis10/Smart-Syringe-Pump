# Smart Syringe Pump Project 💉

## 📋 Overview

A smart syringe pump system that operates via remote control over the internet using ESP32 and MQTT protocol. This project enables precise control over liquid volume and injection time with high accuracy.

## 🎯 Features

- ✅ Remote control via WiFi and MQTT
- ✅ Set liquid volume in milliliters (ML)
- ✅ Set injection time in seconds
- ✅ Automatic retraction after injection
- ✅ Real-time system status updates
- ✅ High precision stepper motor control

## 🔧 Hardware Components

### Required Components:
- **ESP32 Development Board** - Main microcontroller with WiFi capability
- **Stepper Motor** - For precise linear movement
- **Stepper Motor Driver** (Optional - depends on motor type)
- **Power Supply** - Appropriate power adapter
- **Jumper Wires** - For connections
- **Breadboard** (Optional) - For prototyping

### Motor Connections:
```
Motor Pin 1 → GPIO 26 (D26)
Motor Pin 2 → GPIO 25 (D25)
Motor Pin 3 → GPIO 33 (D33)
Motor Pin 4 → GPIO 32 (D32)
```

## 🔩 Mechanical Components

### Required Mechanical Parts:

#### 1. Pump Structure
- [ ] Fixed base for the pump
- [ ] Stepper motor mount/holder
- [ ] Needle/tube mounting system

#### 2. Motion System
- [ ] Lead screw connected to the motor
- [ ] Moving platform to hold the syringe
- [ ] Linear guide to ensure straight movement

#### 3. Syringe System
- [ ] Adjustable syringe holder
- [ ] Syringe clamping mechanism
- [ ] Connection tube (optional)

#### 4. Safety and Stability
- [ ] Limit switches (optional)
- [ ] Additional structural support
- [ ] Protective cover (optional)

### Recommended Mechanical Specifications:
- **Frame Material**: Aluminum or ABS plastic
- **Motion Type**: High-precision linear movement
- **Travel Range**: Depends on syringe size
- **Speed Control**: Adjustable via settings

## 💻 Software Setup

### Software Requirements:
- Arduino IDE
- Required Arduino Libraries:
  - WiFi (Built-in)
  - PubSubClient
  - CustomStepper (Included in project)

### Setup Steps:

1. **Install Arduino IDE and ESP32 Board Support**
   ```
   File → Preferences → Additional Board Manager URLs
   Add: https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```

2. **Install PubSubClient Library**
   ```
   Tools → Manage Libraries → Search for "PubSubClient" → Install
   ```

3. **Configure WiFi and MQTT Settings**
   ```cpp
   const char* wifi_ssid = "Your_Network_Name";
   const char* wifi_password = "Your_Password";
   const char* mqtt_server = "test.mosquitto.org";
   ```

4. **Upload Code to ESP32**
   - Select Board: ESP32 Dev Module
   - Select appropriate Port
   - Click Upload

## 📡 MQTT Protocol

### Topics:

| Topic | Description | Data Type |
|-------|-------------|-----------|
| `syringe/ml` | Set liquid volume in milliliters | Float |
| `syringe/time` | Set injection time in seconds | Float |
| `syringe/cmd` | Start command (`start` or `1`) | String |
| `syringe/status` | System status (read-only) | String |

### Usage Example:

```python
# Set volume
client.publish("syringe/ml", "5.0")  # 5 milliliters

# Set time
client.publish("syringe/time", "10.0")  # 10 seconds

# Start injection
client.publish("syringe/cmd", "start")
```

## ⚙️ Configurable Settings

In `script.ino` you can modify:

```cpp
const int STEPS_PER_ML = 3000;        // Steps per milliliter
const int RETRACT_SPEED_MICROS = 2000; // Retraction speed
```

## 🖥️ User Interface (UI)

The system is connected to a Flutter-based user interface located in the app folder.
The UI provides full remote control and monitoring of the syringe pump.

### UI Features:
- Set liquid volume
- Set injection time
- Start/Stop pump control
- Real-time system status display
- Operation and event logs

All UI source code and related details are available inside the app folder.
---

## 📸 Project Images

### Complete Project Image
<img width="1216" height="913" alt="image" src="https://github.com/user-attachments/assets/a363237d-6262-4a7a-a65b-39eb5aa9fef0" />

### UI Connection Image
<img width="1920" height="1080" alt="Smart Syringe Pump" src="https://github.com/user-attachments/assets/d967a152-3814-424c-9687-57bf5d4d5e3e" />

---

## 🎥 Time‑lapse video

watch videos : [Video Link](https://drive.google.com/drive/folders/1vN-H-6kg4Qjui0s4BIMZB5SvRtraOUYK?usp=sharing)

---

## 📊 Status Messages

| Status | Description |
|--------|-------------|
| `System Online` | System ready and connected |
| `ML set to: X` | Volume set |
| `Time set to: X` | Time set |
| `Running...` | Injection in progress |
| `Returning...` | Retracting |
| `Finished. Ready.` | Operation completed |
| `Error: Set ML & Time` | Error: Must set volume and time |

## 🔒 Safety and Warnings

⚠️ **Important Warnings:**
- Ensure proper electrical connections
- Use appropriate power supply
- Do not use with hazardous fluids without supervision
- Clean the system after each use
- Test the system before actual use

## 🐛 Troubleshooting

### Issue: Cannot connect to WiFi
- Check network name and password
- Verify WiFi signal strength

### Issue: Cannot connect to MQTT
- Check server address
- Verify internet connection

### Issue: Motor not working
- Check connections
- Verify power supply voltage
- Review step settings

## 👥 Team & Contributors

This project was developed collaboratively by a team of contributors:

- **Mohamed Younis** – [GitHub Profile](https://github.com/mohamedyounis10)
- **Bassel Elbahnasy** – [GitHub Profile](https://github.com/Bassel1000)
- **‪Yousef ElSaket‬‏** – [GitHub Profile](https://github.com/iiiiOreo)
- **‪Amin Mubarak** – [GitHub Profile](https://github.com/aminayssar)

### Contributions:
- Hardware design and assembly
- Software development and programming
- Mechanical design and fabrication
- Testing and validation
- Documentation

Special thanks to all team members who contributed to making this project possible.

## 📝 License

This project is open source and available for use and modification.
