# The Dose - Smart Syringe Pump Control App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![MQTT](https://img.shields.io/badge/MQTT-Enabled-3C5280?logo=mqtt)
![License](https://img.shields.io/badge/License-Private-red)

**A modern Flutter application for remote control and monitoring of smart syringe pumps via MQTT protocol**

[Features](#-features) • [Screenshots](#-screenshots) • [Demo](#-demo) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [Technologies](#-technologies)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Demo](#-demo)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**The Dose** is a comprehensive mobile application designed for healthcare professionals to remotely control and monitor smart syringe pump devices. The app provides an intuitive interface for managing intravenous solution administration with real-time communication via MQTT protocol, ensuring precise control and comprehensive logging of all operations.

### Key Highlights

- 🔐 **Secure Authentication** - Firebase-based user authentication and profile management
- 📡 **Real-time Communication** - MQTT protocol for instant device control and status updates
- 📊 **Solution History** - Complete logging and tracking of all administered solutions
- 🎨 **Modern UI/UX** - Clean, responsive design built with Flutter
- ⚡ **Real-time Monitoring** - Live progress tracking and device status updates
- 🏥 **Medical Solutions** - Support for various medical solutions including saline, dextrose, and more

---

## ✨ Features

### 🔑 Authentication & User Management
- User registration and login with Firebase Authentication
- Password recovery functionality
- User profile management
- Secure session handling

### 💉 Syringe Pump Control
- **Amount Control**: Set solution amount (up to 3ml)
- **Duration Control**: Configure administration time in seconds
- **Solution Selection**: Choose from 8+ predefined medical solutions:
  - Normal Saline (0.9% NaCl)
  - Hypotonic Saline (0.45% NaCl)
  - Hypertonic Saline (3% NaCl)
  - Balanced Salt Solutions (BSS)
  - Nasal Rinses/Sprays
  - Dextrose Solutions (D5W)
  - Ringer's Lactate (LR)
  - Glucose-Electrolyte Solutions

### 📊 Real-time Monitoring
- Live progress indicator with circular progress bar
- Real-time device status updates via MQTT
- Start/Stop control functionality
- Visual feedback for all operations

### 📝 Solution History
- Complete log of all administered solutions
- Timestamp tracking for each operation
- Solution details (name, amount, duration)
- Easy access to historical data

### 👤 Profile Management
- View and edit user profile information
- Update personal details
- Change password functionality
- Help and support section
- Terms and conditions

---

## 📸 Screenshots

<div align="center">
  
### Visual identity
<img width="1432" height="805" alt="image" src="https://github.com/user-attachments/assets/161a1618-0b23-402b-8b32-cb02632efb0d" />

### Login & Authentication
<img width="1432" height="805" alt="image" src="https://github.com/user-attachments/assets/357c2899-d554-42b9-bd0a-cdedc98f2aa6" />

### Home Screen - Solution Control
<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/94d2a60a-e86e-4630-bbca-9f84629bf876" />

### Solution History
<img width="1432" height="740" alt="image" src="https://github.com/user-attachments/assets/5aea3f90-e3c6-4f7f-be61-2e5a16814a72" />


### Profile Management
<img width="1432" height="805" alt="image" src="https://github.com/user-attachments/assets/b5b7922c-5058-40fd-ad11-6ac2b2f86204" />

</div>

---

## 🎥 Demo

<div align="center">

### Application Demo Video

https://github.com/user-attachments/assets/89007e8e-87df-4934-804e-e79ac8138741


</div>

---

## 🚀 Installation

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.8.1 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** / **Xcode** (for mobile development)
- **Firebase Account** (for authentication and database)
- **MQTT Broker** (configured and accessible)

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/the_dose.git
cd the_dose
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** (Email/Password)
3. Create a **Firestore Database**
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Place the configuration files in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### Step 4: Configure MQTT

Update the MQTT broker settings in `lib/core/mqtt_services.dart`:

```dart
final String broker = 'your-mqtt-broker.com';
final int port = 1883;
```

### Step 5: Run the Application

```bash
# For Android
flutter run

# For iOS
flutter run

# For specific device
flutter run -d <device-id>
```

---

## ⚙️ Configuration

### MQTT Topics

The application uses the following MQTT topics:

- **Publish Topics:**
  - `syringe/ml` - Solution amount (in ml)
  - `syringe/time` - Duration (in seconds)
  - `syringe/cmd` - Command (1 = Start, 0 = Stop)

- **Subscribe Topics:**
  - `syringe/status` - Device status updates

### Firebase Configuration

Ensure your Firebase project has the following enabled:

- **Authentication:**
  - Email/Password authentication enabled
  - Password reset functionality configured

- **Firestore:**
  - Database created and initialized
  - Security rules configured appropriately
  - Collections: `users`, `solutionLogs`

---

## 📱 Usage

### Getting Started

1. **Launch the App**: Open the application on your mobile device
2. **Create Account**: Register a new account or login with existing credentials
3. **Navigate to Home**: Access the main control screen

### Controlling the Syringe Pump

1. **Select Solution**: Choose the medical solution from the dropdown menu
2. **Enter Amount**: Input the solution amount (maximum 3ml)
3. **Set Duration**: Specify the administration time in seconds
4. **Start Operation**: Tap the "Start" button to begin
5. **Monitor Progress**: Watch the real-time progress indicator
6. **Stop if Needed**: Use the stop functionality if required

### Viewing History

1. Navigate to the **Solution History** screen
2. View all previously administered solutions
3. Check timestamps and details for each operation

### Managing Profile

1. Access the **Profile** section from the navigation menu
2. Update personal information
3. Change password if needed
4. Access help and support resources

---

## 🏗️ Architecture

The application follows a clean architecture pattern with feature-based organization:

```
lib/
├── core/                    # Core utilities and services
│   ├── app_color.dart      # Application color scheme
│   ├── db/                  # Firebase database services
│   ├── mqtt_services.dart   # MQTT communication service
│   └── widgets/             # Reusable widgets
├── features/                # Feature modules
│   ├── account/             # User account management
│   ├── home/                # Main control interface
│   ├── login_signup/        # Authentication
│   └── splash_screen/       # App initialization
├── models/                  # Data models
│   ├── solution_log.dart    # Solution log model
│   └── user.dart            # User model
└── main.dart                # Application entry point
```

### State Management

The application uses **BLoC (Business Logic Component)** pattern for state management:

- `AuthCubit` - Authentication state management
- `HomeCubit` - Home screen and pump control logic
- `ProfileCubit` - User profile management

---

## 🛠️ Technologies

### Core Framework
- **Flutter** 3.8.1 - Cross-platform mobile framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** ^9.1.1 - BLoC pattern implementation

### Backend Services
- **Firebase Core** ^3.15.1 - Firebase initialization
- **Firebase Auth** ^5.6.2 - User authentication
- **Cloud Firestore** ^5.6.12 - NoSQL database

### Communication
- **mqtt_client** ^10.2.0 - MQTT protocol implementation

### UI/UX
- **flutter_screenutil** ^5.9.3 - Responsive design utilities
- **intl** ^0.18.0 - Internationalization support

### Development Tools
- **flutter_launcher_icons** ^0.14.4 - App icon generation

---

## 📁 Project Structure

```
the_dose/
├── android/                 # Android platform files
├── ios/                     # iOS platform files
├── lib/                     # Application source code
│   ├── core/               # Core utilities
│   ├── features/           # Feature modules
│   ├── models/             # Data models
│   └── main.dart           # Entry point
├── assets/                  # Images and resources
│   └── images/             # Application images
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Dependencies configuration
└── README.md               # This file
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter and Dart style guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

## 📄 License

This project is private and proprietary. All rights reserved.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- MQTT community for protocol support
- All contributors and testers

---

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repo if you find it helpful!

</div>
