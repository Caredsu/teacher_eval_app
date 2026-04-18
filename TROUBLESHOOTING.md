# 🐛 Troubleshooting Guide

Quick solutions for common issues.

---

## 🔴 Red Error Box: "Connection error. Please check your internet and API URL."

This means the app can't reach your backend server.

### Check 1: Is Backend Running?

```powershell
# Open browser and test:
Start-Process "http://192.168.1.100/teacher-eval/api"

# You should see JSON response like:
# {"message":"API Documentation here..."}

# If blank or error, your backend isn't running!
```

**Fix:** Start XAMPP and make sure Apache is running.

---

### Check 2: Wrong IP Address

```powershell
# Get your PC's IP:
ipconfig

# Look for IPv4 Address. Example:
#   IPv4 Address. . . . . . . . : 192.168.1.50
```

**Fix:** Update `lib/config/constants.dart` line 15 with YOUR IP.

---

### Check 3: Network Issues

- Phone and PC on same WiFi? ✓
- Firewall blocking port 80? ✓
- Antivirus blocking connections? ✓

**Fix:** Temporarily disable firewall for testing (enable it back after!).

---

## 🟡 App Starts But Shows Empty List

The connection works but no teachers found.

### Check 1: Database Has Data?

```powershell
# Run initialization script:
cd C:\xampp\htdocs\teacher-eval
php scripts/init-db.php

# Should output: "Database initialized successfully!"
```

**Fix:** If failed, re-run the init script.

---

### Check 2: Wrong Database?

Verify MongoDB is running and has data:

```powershell
# Connect to MongoDB:
mongo

# In MongoDB shell:
> use teacher_evaluation
> db.teachers.count()

# Should show number > 0
```

**Fix:** Check MongoDB connection in backend.

---

## 🟡 Evaluation Form Won't Submit

### Check 1: Validation Failed?

The form requires:
- ✓ Teaching Quality: 1-5 stars
- ✓ Communication: 1-5 stars  
- ✓ Knowledge: 1-5 stars
- ✓ Feedback: 10-1000 characters

**Fix:** Fill all fields with correct values before submitting.

---

### Check 2: API Error?

Look at app console (verbose mode):

```powershell
flutter run -v
```

Find the POST request to `/api/evaluations`. Check response status and error message.

**Common error codes:**
- 400: Invalid data (check format)
- 401: Not authenticated (shouldn't happen)
- 500: Server error (check backend logs)

---

### Check 3: Duplicate Prevention Triggered

App prevents same person from evaluating same teacher multiple times per hour.

**Fix:** 
- Wait 1 hour, OR
- Evaluate a different teacher, OR  
- Stop by changing IP (different network)

---

## 🟡 Hot Reload Not Working

```powershell
# Kill the app:
flutter run
# Press: q

# Try again:
flutter run
```

---

## 🟡 "Cannot find emulator"

```powershell
# List available emulators:
flutter emulators

# Start emulator:
flutter emulators --launch <emulator_name>

# Wait 30 seconds for it to start
# Then in new terminal:
flutter run
```

---

## 🟡 Build Fails

### Clean build:

```powershell
cd C:\flutter_projects\teacher_eval_app

flutter clean
flutter pub get
flutter run
```

### Clear build cache:

```powershell
flutter pub cache clean
flutter pub get
flutter run
```

---

## 🟡 Data Isn't Saving

Check backend MongoDB:

```powershell
# Connect to MongoDB:
mongo

# Check evaluations:
> use teacher_evaluation
> db.evaluations.find()

# Should show your submissions
```

If empty, backend isn't saving. Check:
- MongoDB connection in `lib/config/constants.dart`
- Backend error logs at `C:\xampp\htdocs\teacher-eval\`

---

## 🟡 App Crashes on Startup

**In terminal with `flutter run -v`, look for:**

```
E/flutter (12345): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: ...
```

**Common causes:**
1. Import error - check `lib/main.dart` imports
2. UI error - check widget code in `lib/screens/`
3. Configuration error - check `lib/config/constants.dart`

**Fix:** 
- Run `flutter pub get` again
- Delete `pubspec.lock` and run `flutter pub get`
- Restart IDE

---

## 🟡 "Version Conflict" Error

```powershell
# Delete lock file and regenerate:
Remove-Item pubspec.lock
flutter pub get
```

---

## 🟡 Dart Syntax Error

```powershell
# Analyze code:
flutter analyze

# Shows all syntax errors with file:line numbers
```

---

## 📊 How to Debug

### Enable Verbose Logging:

```powershell
flutter run -v
```

Shows:
- API requests and responses
- Widget build logs
- Error stack traces
- Network issues

### Check Real-time Logs:

```powershell
# While app is running:
flutter logs
```

### Use DevTools:

```powershell
# Open web-based debugger:
flutter pub global activate devtools
devtools
```

Then follow instructions in terminal.

---

## 📝 Report Issue Format

If something weird happens, note down:

1. What you did (steps to reproduce)
2. Expected result
3. Actual result  
4. API URL you're using
5. Backend version/location
6. Phone/emulator type
7. Error message (screenshot)
8. Console output (from `flutter run -v`)

---

## ✅ System Check

Run this to verify everything is set up:

```powershell
# Check Flutter installation:
flutter doctor -v

# Should show:
# ✓ Flutter (Channel stable/dev)
# ✓ Android SDK / Xcode
# ✓ Android toolchain / Apple Xcode
# etc...

# If any show ✗, run: flutter doctor
# Follow suggestions to fix issues
```

---

## 🚀 Still Stuck?

1. Check [CONFIGURE.md](CONFIGURE.md) for setup steps
2. Check [README.md](README.md) for complete documentation
3. Check [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for architecture
4. Check backend logs at `C:\xampp\htdocs\teacher-eval\`

Good luck! 💪
