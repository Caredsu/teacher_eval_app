# 🔧 Configure API Connection

Your Flutter app is ready! Now just one simple step: **Tell it where to find your backend server.**

---

## ⚡ TLDR (Just do this)

### Windows:
```powershell
# 1. Open this file in VS Code:
code lib/config/constants.dart

# 2. Find line 15 that says:
# static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';

# 3. Replace 192.168.1.100 with YOUR PC's IP address
# 4. Save the file

# 5. Run the app:
flutter run
```

---

## 🎯 Step-by-Step Guide

### Step 1: Get Your PC's IP Address

**On Windows:**
```powershell
# Open PowerShell and run:
ipconfig

# Look for IPv4 Address (usually starting with 192.168 or 10.0)
# Example output:
#   IPv4 Address. . . . . . . . : 192.168.1.100
```

**On Mac/Linux:**
```bash
ifconfig | grep "inet "
```

### Step 2: Choose Configuration Based on How You're Testing

#### Option A: Testing with Android Phone (Same WiFi)
🎯 **Choose this if you have an Android phone on the same WiFi**

File to edit: `lib/config/constants.dart` (line 15)

Change:
```dart
static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';
```

To (with your PC IP):
```dart
static const String API_BASE_URL = 'http://YOUR_PC_IP/teacher-eval/api';
```

Example:
```dart
static const String API_BASE_URL = 'http://192.168.1.50/teacher-eval/api';
```

---

#### Option B: Testing with Android Emulator
🎯 **Choose this if using Android Virtual Device (emulator)**

File to edit: `lib/config/constants.dart` (line 15-17)

Uncomment line 17:
```dart
// static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api'; // Android Emulator
```

Comment out line 15:
```dart
static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';
```

Result:
```dart
// static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';
static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api'; // Android Emulator
```

---

#### Option C: Testing with iOS Simulator
🎯 **Choose this if using iOS simulator on Mac**

File to edit: `lib/config/constants.dart` (line 15, 18)

Change to:
```dart
static const String API_BASE_URL = 'http://localhost/teacher-eval/api'; // iOS Simulator
```

---

#### Option D: Production Deployment
🎯 **Choose this for real deployment**

File to edit: `lib/config/constants.dart` (line 15)

Change to:
```dart
static const String API_BASE_URL = 'https://your-production-domain.com/teacher-eval/api';
```

---

## ✅ Verify Backend is Running

Before testing the app, make sure your backend is running:

```powershell
# Check if backend is accessible
Invoke-WebRequest -Uri "http://192.168.1.100/teacher-eval/api/teachers" -Method GET

# You should see a response with teacher data
```

If you get an error, make sure:
- ✓ XAMPP is running (Apache + MySQL)
- ✓ Backend files are in `C:\xampp\htdocs\teacher-eval`
- ✓ You're using the correct PC IP address

---

## 🚀 Run the App After Configuration

```powershell
# Navigate to project directory
cd C:\flutter_projects\teacher_eval_app

# Get dependencies
flutter pub get

# Run the app
flutter run

# Press 'r' to hot reload while testing
# Press 'q' to quit
```

---

## 🐛 Troubleshooting

### Connection Error When Starting App

**Symptom:** App shows red error box saying "Connection error"

**Solution:**
1. Check your API URL in `lib/config/constants.dart`
2. Verify backend is running: open browser and visit `http://YOUR_PC_IP/teacher-eval/api`
3. If browser shows an error, restart XAMPP
4. Try again: `flutter run`

---

### Emulator Can't Connect

**Symptom:** Android emulator shows connection error

**Solution:**
Make sure you're using `10.0.2.2` not `localhost` or your PC IP:
```dart
static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api'; // Emulator
```

---

### Phone Can't Connect

**Symptom:** Physical phone shows connection error

**Solution:**
1. Both phone and PC must be on **same WiFi network**
2. Use your PC's IP address (e.g., `192.168.1.100`)
3. Make sure backend firewall isn't blocking port 80

---

## 📱 Testing Checklist

After configuring and running the app:

- [ ] App opens without errors
- [ ] Home screen shows list of teachers
- [ ] Can search teachers by name
- [ ] Can filter by department
- [ ] Can click a teacher to open evaluation form
- [ ] Can submit an evaluation with ratings
- [ ] See success screen after submission
- [ ] Can evaluate another teacher

---

## 💡 Tips

**Development Tip:** Keep this open while developing:
```powershell
flutter run
```

Then any time you change code, just press 'r' to hot reload - changes appear in seconds!

**Debugging Tip:** To see API requests in console:
```powershell
flutter run -v  # verbose mode shows all requests
```

---

## ❓ Still Having Issues?

Check these files for more info:
- **SETUP.md** - 5-minute quick start guide
- **README.md** - Complete documentation  
- **lib/config/constants.dart** - All configuration options with comments
- Backend logs in: `C:\xampp\htdocs\teacher-eval\`

Good luck! 🎉
