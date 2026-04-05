# IoT Device Manager

A cloud-based IoT device management platform built with Flutter. Monitor and control your IoT devices remotely through a modern, intuitive mobile interface.

## Features

### Authentication

- Email/password registration and login
- Persistent sessions with auto-login
- Secure sign out functionality

### Dashboard

- Real-time device monitoring
- Device status indicators (ON/OFF)
- Live temperature updates
- Pull-to-refresh functionality

### Device Control

- Toggle device status
- View detailed device information
- Last updated timestamps

## Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **Backend:** Firebase (Auth + Firestore)
- **State Management:** Provider
- **Architecture:** Clean Architecture

## Prerequisites

- Flutter SDK 3.x
- Firebase project with Authentication and Firestore enabled
- Android SDK 21+ / iOS 12.0+

## Installation

```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd iot_device_manager

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Firebase Setup

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password provider)
3. Enable Cloud Firestore
4. Download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
5. Place the config files in their respective directories

## Database Schema

### users Collection

```text
users/{userId}
  - email: String
  - createdAt: Timestamp
  - displayName: String (optional)
```

### devices Collection

```text
devices/{deviceId}
  - userId: String
  - name: String
  - temperature: double
  - status: String ("on" | "off")
  - lastUpdated: Timestamp
  - createdAt: Timestamp
  - isOnline: Boolean
```

## Project Structure

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   ├── services/
│   └── repositories/
├── providers/
├── screens/
└── widgets/
```

## Color Palette

| Color       | Hex Code  | Usage               |
|-------------|-----------|---------------------|
| Background  | #0D1117   | Main background    |
| Surface     | #161B22   | Card backgrounds   |
| Accent Cyan | #00D9FF   | Interactive elements |
| Accent Green| #00FF88   | Online status      |
| Accent Red  | #FF4757   | Offline/warning    |

## Design

- **Theme:** Dark mode with futuristic IoT aesthetic
- **Typography:** Inter font family
- **Layout:** Mobile-first, card-based design

## License

MIT License
