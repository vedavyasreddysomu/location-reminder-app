# Location Reminder App

A cross-platform mobile application (Android & iOS) that sends alarm notifications when you're approaching a pre-set destination. The app uses real-time GPS tracking, geofencing, and local notifications to remind you 5-10 minutes before you arrive at your destination.

## Features

✨ **Core Features:**
- 🗺️ **Interactive Map UI** - Select destinations by tapping on a Google Map
- 📍 **Real-time Location Tracking** - Continuous GPS-based location monitoring
- 🔔 **Customizable Alarm Timing** - Set reminder time: 5, 10, or custom minutes before arrival
- 🔊 **Audio Alarm Notification** - Loud alarm sound triggered at the right time
- 📱 **Cross-Platform Support** - Works on both Android (API 21+) and iOS (11.0+)
- 🔐 **Automatic Location Permissions** - Requests necessary permissions on first use
- 📍 **Geofencing** - Advanced location boundary detection
- 🎯 **ETA Calculation** - Real-time distance and time to destination calculation
- 💾 **Offline Support** - Reminders work in the background even when app is minimized

## Tech Stack

- **Framework:** Flutter (Dart)
- **Maps:** Google Maps SDK (google_maps_flutter)
- **Location Services:** Location Plugin & Geolocator
- **Notifications:** flutter_local_notifications
- **Background Tasks:** workmanager (for background location tracking)
- **State Management:** Provider / Riverpod
- **Database:** SQLite (for storing reminders)

## Installation & Setup

### Prerequisites

- Flutter SDK (v3.0 or higher)
- Dart SDK (included with Flutter)
- Android SDK (for Android development)
- Xcode (for iOS development)
- Google Maps API Key

### Step 1: Clone Repository

```bash
git clone https://github.com/vedavyasreddysomu/location-reminder-app.git
cd location-reminder-app
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Google Maps Setup

#### Android Configuration

1. Get your Google Maps API Key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android
3. Open `android/app/src/main/AndroidManifest.xml`
4. Add the API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />
```

#### iOS Configuration

1. Open `ios/Runner/GeneratedPluginRegistrant.m`
2. Add your Google Maps API Key to `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

### Step 4: Location Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.VIBRATE" />
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to set destination reminders</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location for background tracking</string>
```

### Step 5: Run the App

#### Android

```bash
flutter run -d android
```

#### iOS

```bash
flutter run -d ios
```

## Usage Guide

### Setting a Reminder

1. **Open the App** - Launch Location Reminder App
2. **Tap "Add New Reminder"** - Start a new location reminder
3. **Select Destination** - Tap on the interactive map to choose your destination
4. **Set Alarm Time** - Choose 5 min, 10 min, or enter custom minutes
5. **Confirm** - Tap "Save Reminder"
6. **Receive Alert** - When you're within the set time from destination, you'll receive an alarm notification

### Alarm Notification

- 🔊 **Default Sound** - Built-in alarm sound plays
- 📳 **Vibration** - Device vibrates along with the sound
- 🎯 **On-Screen Alert** - Notification appears on your device's lock screen and status bar
- ⏹️ **Dismiss Option** - Tap to dismiss the alarm

## File Structure

```
location-reminder-app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   ├── home_screen.dart      # Home screen with reminder list
│   │   ├── map_screen.dart       # Map selection screen
│   │   └── alarm_config_screen.dart  # Configure alarm timing
│   ├── services/
│   │   ├── location_service.dart    # Location tracking logic
│   │   ├── alarm_service.dart       # Alarm notification logic
│   │   ├── geofence_service.dart    # Geofencing implementation
│   │   └── notification_service.dart # Local notifications
│   ├── models/
│   │   ├── reminder_model.dart      # Reminder data model
│   │   └── location_model.dart      # Location data model
│   └── providers/
│       ├── reminder_provider.dart    # State management for reminders
│       └── location_provider.dart    # State management for location
├── pubspec.yaml                  # Dependencies and configuration
├── android/                      # Android-specific code
└── ios/                          # iOS-specific code
```

## Dependencies

Key packages used in this project:

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.4.0
  location: ^5.0.0
  flutter_local_notifications: ^14.0.0
  workmanager: ^0.5.1
  provider: ^6.0.0
  sqflite: ^2.2.0
  path: ^1.8.0
```

## API References

### Location Service

```dart
// Get current location
var location = await LocationService().getCurrentLocation();

// Listen to location updates
LocationService().onLocationChanged().listen((location) {
  print('New location: ${location.latitude}, ${location.longitude}');
});
```

### Alarm Service

```dart
// Trigger alarm
await AlarmService().triggerAlarm();

// Cancel alarm
await AlarmService().cancelAlarm();
```

## Troubleshooting

### Location Permission Issues

- **Android:** Go to Settings > Apps > Location Reminder > Permissions > Location, select "Allow all the time"
- **iOS:** Go to Settings > Privacy > Location Services > Location Reminder, select "Always"

### Map Not Loading

- Verify Google Maps API Key is correctly added
- Check if Maps API is enabled in Google Cloud Console
- Ensure your app's SHA-1 fingerprint is registered

### Alarm Not Triggering

- Check if app has background execution permission
- Verify location permission is set to "Always" or "While Using"
- Ensure volume is not muted on your device
- Check app battery optimization settings

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support & Contributing

For bug reports and feature requests, please open an issue on GitHub.

Contributions are welcome! Please fork the repository and submit a pull request.

## Author

Developed by **Vedas Digi Tech** / **Kittys Micro Solutions**

---

**Last Updated:** November 2025
