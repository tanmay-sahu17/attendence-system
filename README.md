# FaceMark AI - Smart Attendance System (Flutter)

A native mobile application built with Flutter for AI-powered facial recognition attendance tracking.

## Features

- **AI-Powered Face Recognition**: Advanced facial recognition for accurate attendance
- **Real-time Camera**: Live camera feed for capturing student attendance
- **Video Upload**: Upload pre-recorded videos for batch processing
- **Attendance Records**: View and manage historical attendance data
- **Beautiful UI**: Modern, responsive design matching the original web app
- **Cross-Platform**: Runs on both Android and iOS

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for mobile development
- A physical device or emulator for testing camera features

## Installation

1. **Navigate to the Flutter app directory:**
   ```bash
   cd flutter_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS (macOS only):
   ```bash
   flutter run -d ios
   ```

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart              # App entry point with routing
│   ├── theme/
│   │   └── app_theme.dart     # Theme configuration (colors, styles)
│   ├── components/
│   │   ├── bottom_nav.dart    # Bottom navigation bar
│   │   ├── top_bar.dart       # Top app bar
│   │   ├── dashboard.dart     # Dashboard widget
│   │   └── mobile_container.dart
│   └── pages/
│       ├── login_page.dart    # Login screen
│       ├── index_page.dart    # Home/Dashboard screen
│       ├── camera_page.dart   # Camera recording screen
│       ├── upload_page.dart   # Video upload screen
│       ├── processing_page.dart # AI processing screen
│       ├── results_page.dart  # Attendance results
│       ├── records_page.dart  # Historical records
│       ├── settings_page.dart # App settings
│       └── profile_page.dart  # User profile
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
└── pubspec.yaml              # Dependencies

```

## Dependencies

- **go_router**: Navigation and routing
- **camera**: Camera access and video recording
- **image_picker**: Pick videos from gallery
- **provider**: State management
- **shared_preferences**: Local storage
- **http**: API communication

## Camera Permissions

The app requires camera and microphone permissions:

### Android
Permissions are declared in `android/app/src/main/AndroidManifest.xml`

### iOS
Permissions are declared in `ios/Runner/Info.plist`

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Key Differences from Web Version

1. **Native Navigation**: Uses go_router instead of react-router-dom
2. **Camera Integration**: Uses Flutter camera plugin instead of web camera APIs
3. **Material Design**: Implements Material Design 3 components
4. **Performance**: Better performance on mobile devices
5. **Offline Support**: Can work offline with local storage

## UI Preservation

The Flutter app maintains the exact same visual design as the web version:
- Same color scheme (Primary Blue, Accent Cyan, Success Green)
- Identical layout and component structure
- Matching animations and transitions
- Consistent typography and spacing

## Troubleshooting

### Camera Not Working
- Ensure permissions are granted in device settings
- Test on a physical device (emulators may have camera issues)
- Check AndroidManifest.xml and Info.plist for permission declarations

### Build Errors
- Run `flutter clean` and `flutter pub get`
- Update Flutter SDK: `flutter upgrade`
- Check platform-specific requirements

## Development

To run in development mode with hot reload:
```bash
flutter run
```

To run with specific device:
```bash
flutter devices                # List available devices
flutter run -d <device-id>     # Run on specific device
```

## License

This project is part of the VisionMark attendance system.

## Support

For issues and questions, please contact the development team.
