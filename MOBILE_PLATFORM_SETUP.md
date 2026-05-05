# Mobile App Platform Detection - Setup Guide

## What Was Implemented

Your Flutter app now has a **platform-aware routing system** that:

✅ **For iOS Users:**
- Detects iOS device
- Shows "Redirecting to Website" screen
- Automatically opens website in browser
- User continues on web version

✅ **For Android Users:**
- Detects Android device
- Shows beautiful options screen with 3 choices:
  1. **Mobile App** - Use the Flutter app (best performance)
  2. **Web Version** - Open website in browser
  3. **Download Latest** - Go to Google Play Store

## Files Created/Modified

### New Files:
1. **lib/screens/platform_check_screen.dart** - Platform detection UI
2. **lib/services/platform_service.dart** - Platform utilities
3. **PLATFORM_DETECTION.md** - Technical documentation

### Modified Files:
1. **lib/main.dart** - Uses PlatformCheckScreen now
2. **pubspec.yaml** - Added url_launcher dependency

## Next Steps to Complete

### 1. Install Dependencies
```bash
cd C:\flutter_projects\teacher_eval_app
flutter pub get
```

### 2. Update Configuration

Edit `lib/services/platform_service.dart` and update the URLs:

```dart
// Change these URLs to your actual URLs:
static const String websiteUrl = 'https://your-actual-website.com';
static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';
```

### 3. Update Android Build Config

Open `android/app/build.gradle` and verify/update:

```gradle
android {
    defaultConfig {
        // Update this to your actual package name
        applicationId "com.fullbright.teacher_eval_app"
    }
}
```

### 4. Create Google Play Store Listing

Before users can download the app from Play Store, you need to:
1. Create Google Play Developer account
2. Create app listing
3. Upload APK/AAB
4. Wait for review
5. Publish app
6. Update the `playStoreUrl` with the actual link

### 5. Test on Real Devices

**Android Testing:**
```bash
flutter run --release
# Then test on Android phone - should see options screen
```

**iOS Testing:**
```bash
flutter run -d <ios-device-id>
# Should redirect to website
```

## Feature Details

### Platform Detection Screen (Android)

The Android users see a professional interface with:
- **School logo and branding**
- **Three interactive option cards:**
  - Mobile App (purple gradient)
  - Web Version (blue outline)
  - Download Latest (green outline)
- **Information section** explaining the benefits
- **Smooth animations and shadows**

### iOS Redirect

iOS users get:
- **Simple loading screen** with "Redirecting to Website"
- **Automatic redirect** to your website
- **Clean transition** to web app

## URL Configuration

Currently set to:
```
Website: https://fullbright-teacher-eval.netlify.app
Play Store: https://play.google.com/store/apps/details?id=com.fullbright.teacher_eval_app
App Store: https://apps.apple.com/app/teacher-eval/id123456789
```

**Update these in `lib/services/platform_service.dart`**

## Using PlatformService in Your App

You can use the platform service anywhere:

```dart
import 'services/platform_service.dart';

// Check if Android
if (PlatformService.isAndroid) {
  print("Running on Android");
}

// Open website
await PlatformService.launchWebsite();

// Open Play Store
await PlatformService.launchPlayStore();

// Get platform info
print(PlatformService.getPlatformName()); // "iOS", "Android"
```

## Customization Ideas

1. **Change colors** - Edit `platform_check_screen.dart` (gradients, colors)
2. **Change text** - Edit all the Text widgets in the screen
3. **Add animations** - Add PageTransition or AnimatedContainer
4. **Add analytics** - Track which option users choose
5. **Add version checking** - Check for updates on startup

## Troubleshooting

### URLs Not Opening
- Ensure URL is correct and accessible
- On iOS simulator, URLs don't open (works on real device)
- Check internet connection

### Platform Detection Wrong
- Verify you're testing on correct device/emulator
- Clear app cache: `flutter clean`

### Dependencies Error
- Run: `flutter pub get`
- Run: `flutter pub upgrade`

## PHP Website Integration

Your PHP website should:
1. Detect user is from app (optional - can add user-agent header)
2. Show appropriate UI
3. Handle evaluations as normal

Current website URL being used:
```
https://fullbright-teacher-eval.netlify.app
```

If this is wrong, update it in `lib/services/platform_service.dart`

## Building for Release

### Android APK/AAB:
```bash
flutter build appbundle  # For Play Store
# or
flutter build apk        # For direct distribution
```

### iOS App (when ready):
```bash
flutter build ipa        # For App Store
```

## Important Notes

⚠️ **For Production:**
- Test thoroughly on real devices
- Update all URLs before building
- Ensure website is accessible from all countries
- Have backup website URL in case main goes down
- Add error handling for URL launch failures

## Questions/Issues?

Check these files:
1. `PLATFORM_DETECTION.md` - Technical details
2. `lib/screens/platform_check_screen.dart` - UI code
3. `lib/services/platform_service.dart` - Logic code

## Current Status

✅ Platform detection implemented
✅ iOS redirect to web implemented
✅ Android options screen implemented
✅ URL launching working
⏳ Google Play Store listing needed
⏳ iOS App listing needed (for future)

Next: Publish to Play Store and update URLs!
