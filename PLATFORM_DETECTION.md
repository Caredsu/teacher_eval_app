# Platform Detection & Routing System

This document describes the platform detection and routing system for the Teacher Evaluation App.

## Overview

The app now includes an intelligent platform detection system that:
- **Detects device platform** (iOS, Android, Web)
- **Redirects iOS users** to the website (since no iOS app exists yet)
- **Gives Android users options** to use the mobile app or web version
- **Provides easy access** to Google Play Store

## File Structure

```
lib/
├── screens/
│   └── platform_check_screen.dart       # Main platform detection UI
├── services/
│   └── platform_service.dart            # Platform detection utilities
└── main.dart                             # Updated to use PlatformCheckScreen
```

## How It Works

### 1. App Startup Flow

When the app starts:
1. `main.dart` launches the app with `PlatformCheckScreen` as the home screen
2. Platform detection runs automatically

### 2. iOS Users
- Immediately see a "Redirecting to Website" screen
- Automatically redirected to the web version
- Can continue using the web app

### 3. Android Users
- See options screen with three choices:
  1. **Mobile App** - Continue with the Flutter app
  2. **Web Version** - Open the website in browser
  3. **Download Latest** - Go to Google Play Store

## Configuration

### Update URLs

Edit `lib/services/platform_service.dart` to update URLs:

```dart
// Website
static const String websiteUrl = 'https://fullbright-teacher-eval.netlify.app';

// Play Store
static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.fullbright.teacher_eval_app';

// App Store (for future iOS app)
static const String appStoreUrl = 'https://apps.apple.com/app/teacher-eval/id123456789';
```

## Packages Used

- `url_launcher: ^6.2.0` - For opening URLs and app store links

## Usage in Your Code

You can use the `PlatformService` anywhere in your app:

```dart
import 'services/platform_service.dart';

// Check platform
if (PlatformService.isAndroid) {
  // Do something Android-specific
}

// Launch website
await PlatformService.launchWebsite();

// Launch Play Store
await PlatformService.launchPlayStore();

// Get platform name
String platform = PlatformService.getPlatformName(); // "iOS", "Android", or "Web"
```

## Configuration in android/app/build.gradle

Make sure your Android app package name matches in `pubspec.yaml` and `build.gradle`:

```gradle
applicationId "com.fullbright.teacher_eval_app"
```

Update the Play Store URL if package name changes.

## Future Enhancements

1. **iOS App Release** - When iOS app is ready, update the redirect logic to open App Store instead
2. **Version Check** - Add version checking to prompt users to update
3. **Analytics** - Track which platform users are accessing from
4. **Splash Screen** - Add custom splash screen during platform detection
5. **Deep Linking** - Implement deep linking for direct links to specific teachers/evaluations

## Troubleshooting

### URL Not Launching
- Check if URL is correct in `PlatformService`
- For Play Store, ensure package ID is correct
- On iOS simulator, URLs may not open (works on real device)

### Platform Detection Not Working
- Verify `dart:io` package is properly imported
- Check that device/simulator OS is correct

### App Not Redirecting
- Ensure `url_launcher` package is installed: `flutter pub get`
- Check that URL is accessible
- Allow 2-3 seconds for redirect to complete

## Testing

### Test on Android Emulator
```bash
flutter run -d emulator-5554
```

### Test on iOS Simulator
```bash
flutter run -d iPhone-14
```

### Test Platform Detection
```dart
import 'package:flutter/foundation.dart';

// In tests, you can mock Platform
if (kDebugMode) {
  debugPrint('Platform: ${PlatformService.getPlatformName()}');
}
```

## Security Considerations

1. **URL Hardcoding** - Consider moving URLs to a config server in production
2. **HTTPS Only** - All URLs use HTTPS
3. **App Verification** - Use Firebase App Signing for Play Store uploads
4. **URL Validation** - Never accept URLs from user input

## Support

For issues or updates needed, modify:
- `lib/screens/platform_check_screen.dart` - UI changes
- `lib/services/platform_service.dart` - Functionality changes
- `pubspec.yaml` - Dependency updates
