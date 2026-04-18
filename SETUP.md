# 🚀 Flutter App - Quick Setup Guide

## 5-Minute Setup

### ✅ Prerequisites Check
```bash
flutter doctor
# All should show ✓ checkmark
```

### 1️⃣ Navigate to Project
```bash
cd C:\flutter_projects\teacher_eval_app
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Update API Base URL

**Edit:** `lib/services/api_service.dart`

Find this line (around line 7):
```dart
static const String baseUrl = 'http://192.168.1.100/teacher-eval/api';
```

**Choose correct URL:**

- **Local PC (Windows):** `http://192.168.1.100/teacher-eval/api` (replace with your PC IP)
- **Android Emulator:** `http://10.0.2.2/teacher-eval/api` (fixed address)
- **Physical Android Device:** `http://192.168.1.100/teacher-eval/api` (replace with your PC IP)
- **Production Server:** `https://yourdomain.com/teacher-eval/api`

**How to find your PC IP:**
```powershell
ipconfig
# Look for "IPv4 Address" under your network (usually 192.168.x.x)
```

### 4️⃣ Start Emulator or Connect Device
```bash
# List available devices
flutter devices

# If no emulator, launch one
flutter emulators --launch emulator-5554

# Wait for emulator to boot, then:
flutter run
```

## 🎯 Expected Output

```
Launching lib/main.dart on Android SDK built for x86 in debug mode...
```

App should open on emulator/device showing:
- ✓ Teacher Evaluation header
- ✓ Search box
- ✓ Department filter chips
- ✓ List of teachers

## ✨ Test the App

1. **Search for a teacher** - Type in search box
2. **Filter by department** - Click on ECT, EDUC, etc.
3. **Click on a teacher** - Opens evaluation form
4. **Rate the teacher** - Click stars (1-5)
5. **Write feedback** - Type min 10 characters
6. **Submit** - Click "Submit Evaluation" button
7. **See success screen** - Should show confirmation

## ❌ Troubleshooting

### App Won't Run
```bash
flutter clean
flutter pub get
flutter run -v
```

### Cannot Connect to API
1. Check backend is running
2. Update API URL (step 3 above)
3. Verify IP address is correct
4. Check firewall

### Error: "Localhost"
- Don't use `localhost`
- Use actual IP address (192.168.x.x or 10.0.2.2)

### Emulator Won't Start
```bash
flutter emulators --launch emulator-5554
# Wait 30 seconds for it to fully boot
```

## 📱 Hot Reload Development

While app is running:
- Press **R** - Hot reload code changes
- Press **R**** - Hot restart entire app
- Type **Q** - Quit app

## 🎨 Customization

### Change Colors
Edit `lib/main.dart` line ~20:
```dart
primarySwatch: Colors.blue,  // Change to Colors.red, Colors.green, etc.
```

### Change API Timeout
Edit `lib/services/api_service.dart`:
```dart
.timeout(
  const Duration(seconds: 10),  // Increase if too slow
  onTimeout: () => throw Exception('Request timeout'),
)
```

### Change Validation Rules
Edit `lib/screens/evaluation_screen.dart`:
```dart
if (feedback.length < 10) {  // Change minimum length
if (feedback.length > 1000) {  // Change maximum length
```

## 📦 Build for Release

### Android APK
```bash
flutter build apk --release
```
Location: `build/app/outputs/flutter-app-release.apk`

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```
Location: `build/app/outputs/bundle-release.aab`

## 📋 Project Files Created

```
lib/
├── main.dart                      ✓
├── screens/
│   ├── home_screen.dart          ✓
│   ├── evaluation_screen.dart    ✓
│   └── success_screen.dart       ✓
├── models/
│   └── teacher.dart              ✓
└── services/
    └── api_service.dart          ✓

pubspec.yaml                       ✓
README.md                          ✓
.gitignore                         ✓
SETUP.md                           ✓ (this file)
```

## 🔒 Security Reminder

**Never share:**
- Backend API URLs with auth tokens
- Database credentials
- Server IP addresses publicly
- Production URLs in app code

## 💡 Tips

1. Use `flutter run -v` for detailed debugging
2. Check `flutter doctor` regularly
3. Keep Flutter SDK updated: `flutter upgrade`
4. Test on real device before deployment
5. Use `flutter build` for production

## 🆘 Still Stuck?

### Check These:
1. Backend running? → `curl http://your-ip/teacher-eval/api/departments`
2. Correct API URL? → Check `api_service.dart`
3. Internet connection? → Try ping
4. Firewall? → Check if port 80 is open
5. Emulator? → Try physical device

### Get Detailed Logs:
```bash
flutter run -v
```

### Complete Reset:
```bash
flutter clean
rm -rf .dart_tool
rm pubspec.lock
flutter pub get
flutter run
```

---

**Ready to go! Happy coding! 🎓✨**

Next: `flutter run` to start the app
