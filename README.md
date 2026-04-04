# Teacher Evaluation Flutter App

A mobile app for students to submit anonymous teacher evaluations. Built with Flutter and connects to the Teacher Evaluation System API.

## 📋 Features

- ✅ View list of all teachers
- ✅ Filter teachers by department
- ✅ Search teachers by name
- ✅ Rate teachers on 3 criteria (Teaching, Communication, Knowledge)
- ✅ Submit detailed feedback (10-1000 characters)
- ✅ Success confirmation screen
- ✅ Error handling and validation
- ✅ Internet connection checking
- ✅ Material Design UI

## 🛠️ Prerequisites

Before running this app, ensure you have:

1. **Flutter SDK** installed ([Download](https://flutter.dev/docs/get-started/install))
2. **A device or emulator** (Android or iOS)
3. **Backend API running** at your server URL
4. **Dart** version 3.0+

### Verify Flutter Installation
```bash
flutter doctor
```

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry point & theme setup
├── screens/
│   ├── home_screen.dart       # Teachers list with filtering
│   ├── evaluation_screen.dart  # Evaluation form with ratings
│   └── success_screen.dart    # Success confirmation
├── services/
│   └── api_service.dart       # API integration
└── models/
    └── teacher.dart           # Teacher data model
```

## 🚀 Getting Started

### Step 1: Create Flutter Project
```bash
# Navigate to your projects folder
cd C:\flutter_projects

# Project already created at: C:\flutter_projects\teacher_eval_app
cd teacher_eval_app
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Update API URL

Edit `lib/services/api_service.dart` and update the base URL:

```dart
// For local development (Windows)
static const String baseUrl = 'http://192.168.1.100/teacher-eval/api';

// For Android Emulator
static const String baseUrl = 'http://10.0.2.2/teacher-eval/api';

// For real device
static const String baseUrl = 'http://your-server-ip/teacher-eval/api';
// Replace with your actual server IP
```

### Step 4: Run the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or run on default device
flutter run
```

## 📱 Usage

### For Students:
1. **Open the app** on your mobile device
2. **Browse or search** for a teacher
3. **Filter by department** if needed
4. **Tap on a teacher** to open evaluation form
5. **Rate on 3 criteria** (1-5 stars each)
6. **Write feedback** (at least 10 characters)
7. **Submit** the evaluation
8. **See confirmation** screen

### API Connection:
- Teacher list fetched from: `GET /api/teachers`
- Departments from: `GET /api/departments`
- Evaluation submitted to: `POST /api/evaluations`

## 🔧 Configuration

### Custom Styling
Edit `lib/main.dart` to customize:
- Colors
- Fonts
- AppBar appearance
- Button styles

### API Timeouts
Modify timeout duration in `lib/services/api_service.dart`:
```dart
.timeout(
  const Duration(seconds: 10),  // Change this value
  onTimeout: () => throw Exception('Request timeout'),
)
```

### Validation Rules
Edit `lib/screens/evaluation_screen.dart`:
- Minimum feedback length: 10 characters
- Maximum feedback length: 1000 characters
- Rating range: 1-5 stars

## 🐛 Troubleshooting

### "Cannot connect to API"
- ✓ Ensure backend is running: `php scripts/init-db.php`
- ✓ Check API URL in `api_service.dart`
- ✓ For emulator: Use `10.0.2.2` instead of `localhost`
- ✓ For physical device: Use device's local IP address
- ✓ Check firewall allows port 80

### "Connection timeout"
- ✓ Increase timeout duration in `api_service.dart`
- ✓ Check internet connectivity
- ✓ Verify backend server is responsive

### "Invalid JSON"
- ✓ Ensure backend is returning proper JSON
- ✓ Check API endpoint URLs
- ✓ Verify database has data

### Star Ratings Not Working
- ✓ Ensure you're tapping on the star icons
- ✓ Rating should show feedback below

### Flutter Installation Issues
```bash
# Clear cache
flutter clean

# Reinstall dependencies
flutter pub get

# Reinstall pubspec
flutter pub upgrade
```

## 🔐 Security Notes

- ✅ No sensitive data stored locally
- ✅ API calls use HTTPS in production
- ✅ Feedback is anonymous (IP-based duplicate prevention on backend)
- ✅ No authentication required (by design)

## 📦 Dependencies

- **http**: ^1.1.0 - HTTP client for API calls
- **intl**: ^0.19.0 - Internationalization (for future features)
- **Flutter & Dart SDK**: Built-in

## 📊 API Response Examples

### Get Teachers
```json
{
  "success": true,
  "message": "Teachers retrieved successfully",
  "data": [
    {
      "id": "507f1f77bcf86cd799439011",
      "firstname": "John",
      "lastname": "Smith",
      "middlename": "Michael",
      "department": "ECT"
    }
  ]
}
```

### Submit Evaluation
```json
{
  "success": true,
  "message": "Evaluation submitted successfully",
  "data": {
    "id": "507f1f77bcf86cd799439020",
    "teacher_id": "507f1f77bcf86cd799439011",
    "submitted_at": "2026-04-03 14:23:12"
  }
}
```

## 🚀 Building for Distribution

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app-release.apk
```

### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle-release.aab
```

### iOS
```bash
flutter build ios --release
# Output: build/ios/iphoneos
```

## 📈 Future Enhancements

- [ ] Offline mode with local caching
- [ ] Biometric authentication
- [ ] Push notifications
- [ ] Multiple language support
- [ ] Dark mode support
- [ ] Evaluation history
- [ ] Analytics dashboard
- [ ] Image/avatar support

## 📝 Development Tips

### Hot Reload
```bash
# Press 'R' in terminal while app is running
r - Hot reload
R - Hot restart
```

### Debug Mode
```bash
flutter run -v  # Verbose logging
flutter run --profile  # Profile mode
flutter run --release  # Release mode
```

### Emulator Commands
```bash
# Launch emulator
flutter emulators --launch emulator-5554

# List emulators
flutter emulators
```

## 🤝 Contributing

For issues or improvements:
1. Test the app thoroughly
2. Document any bugs
3. Test on multiple devices

## 📄 License

This project is provided as-is for educational purposes.

## 💡 Tips for Deployment

1. **Update API URL** for production server
2. **Test thoroughly** on both Android and iOS
3. **Use ProGuard/R8** for Android minification
4. **Add error tracking** (Firebase, Sentry)
5. **Implement analytics** if needed
6. **Add privacy policy** screen
7. **Test with slow internet** to ensure good UX

## 🆘 Quick Help

### Can't find device?
```bash
flutter devices
# If none shown: connect device or start emulator
```

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### API connection issues?
1. Check backend is running
2. Verify API URL in `api_service.dart`
3. Test URL with browser/curl
4. Check firewall settings

## 📞 Support Resources

- Flutter Documentation: https://flutter.dev/docs
- Dart Language: https://dart.dev
- HTTP Package: https://pub.dev/packages/http
- Material Design: https://material.io

---

**Happy evaluating! 🎓✨**

For backend API documentation, see: `../README.md`
