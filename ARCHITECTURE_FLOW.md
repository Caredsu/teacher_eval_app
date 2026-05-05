# Platform Detection Flow Diagram

## 📊 Complete Application Flow

```
USER DOWNLOADS & OPENS APP
    |
    v
[main.dart] Starts TeacherEvalApp
    |
    v
[PlatformCheckScreen] Loads
    |
    +------------------------------------------+
    |  Platform Detection (dart:io Platform)  |
    +------------------------------------------+
    |
    +--------+--------+--------+
    |        |        |        |
    v        v        v        v
  [iOS]  [Android] [Web]   [Other]
   |        |        |
   |        |        |
   YES      YES      NO (disable or error)
   |        |
   |        +---------------------------------+
   |                                         |
   v                                         v
SHOW iOS             SHOW Android OPTIONS SCREEN
REDIRECT SCREEN
   |                                    |
   |                    +---+---+---+---+---+
   |                    |   |   |   |   |   |
   |                    v   v   v   v   v   v
   |               Mobile Web Download
   |               App    Ver  Latest
   |               |     |     |
   v               v     v     v
Website         HomeScreen Website PlayStore
(browser)       (app)     (browser) (opens)
```

## 🔄 Detailed Decision Tree

```
App Startup
│
├─ Check Platform ──┐
│                   │
└─ Is iOS? ─────────┼─ YES ─┐
                    │       │
                    NO      │
                    │       v
                    │   [iOS Redirect Screen]
                    │   • Show "Redirecting..."
                    │   • Launch Website
                    │   • Close App
                    │
                    └─ Is Android? ─ YES ─┐
                                    │     │
                                    NO    v
                                    │  [Android Options]
                                    │  ┌─────────────────┐
                                    │  │ Choose One:     │
                                    │  ├─────────────────┤
                                    │  │ 1. Mobile App   │
                                    │  │    → HomeScreen │
                                    │  │                 │
                                    │  │ 2. Web Version  │
                                    │  │    → Browser    │
                                    │  │                 │
                                    │  │ 3. Download     │
                                    │  │    → PlayStore  │
                                    │  └─────────────────┘
                                    │
                                    └─ Other/Web
                                       (show error)
```

## 📱 Screen Navigation Flow

```
┌─────────────────────────────────────────────────────────┐
│                    App Start (main.dart)                │
│              Uses [PlatformCheckScreen]                 │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        v                         v
   [iOS Branch]            [Android Branch]
        │                         │
        v                         v
   Quick Redirect          Options Screen
   (2-3 seconds)            (User choice)
        │                    │  │  │
        │                    │  │  └──→ [PlayStore Link]
        │                    │  └──────→ [Website Link]  
        │                    └─────────→ [HomeScreen]
        │                                  │
        └──→ [Website Link]                v
             (Auto launch)          [Evaluation App]
                                     • List Teachers
                                     • Fill Evaluation
                                     • Submit Form
```

## 🔧 Code Architecture

```
┌─────────────────────────────────────────────────────┐
│                    lib/main.dart                    │
│              (App Entry Point)                      │
│  • Imports: PlatformCheckScreen                     │
│  • Sets home: PlatformCheckScreen()                 │
└────────────────────┬────────────────────────────────┘
                     │
                     v
┌─────────────────────────────────────────────────────┐
│       lib/screens/platform_check_screen.dart        │
│     (Platform Detection & UI Rendering)            │
│  • Detects Platform (iOS vs Android)               │
│  • Renders appropriate screen                       │
│  • Handles button interactions                      │
│  • Calls PlatformService for URLs                  │
└────────────────────┬────────────────────────────────┘
                     │
                     v
┌─────────────────────────────────────────────────────┐
│       lib/services/platform_service.dart            │
│     (Platform Business Logic)                      │
│  • isIOS, isAndroid properties                     │
│  • launchWebsite()                                 │
│  • launchPlayStore()                               │
│  • Reads URLs from AppConfig                       │
└────────────────────┬────────────────────────────────┘
                     │
                     v
┌─────────────────────────────────────────────────────┐
│         lib/config/app_config.dart                 │
│    (Centralized Configuration)                     │
│  • websiteUrl                                      │
│  • playStoreUrl                                    │
│  • appStoreUrl                                     │
│  • schoolName, schoolEmail, etc.                   │
└─────────────────────────────────────────────────────┘
                     │
                     v
                [url_launcher]
              (Flutter Package)
          • Launch URLs in browser
          • Open app store links
```

## 📲 User Journey Map

### Android User Journey
```
1. Opens App
    ↓
2. Sees Options Screen
    ↓
    ├─ Choice: "Mobile App" ────────┐
    │                              │
    ├─ Choice: "Web Version" ───┐  │
    │                           │  │
    └─ Choice: "Download Latest"│  │
                                │  │
                    ┌───────────┴──┴──────────┐
                    │                        │
                    v                        v
                Android App            Website/Browser
                (Offline)              (Any device)
```

### iOS User Journey
```
1. Opens App
    ↓
2. Sees "Redirecting..." screen
    ↓
3. Website opens automatically
    (3 seconds and app closes)
    ↓
4. Evaluates on website
```

## 🔄 Data Flow

```
User Interaction
        │
        v
platform_check_screen.dart
        │
        ├─ OnTap: "Mobile App"
        │   └─ Navigate to HomeScreen
        │       └─ Load Teachers/Evaluations
        │
        ├─ OnTap: "Web Version"
        │   └─ PlatformService.launchWebsite()
        │       └─ Open Browser
        │           └─ Website loads
        │
        ├─ OnTap: "Download Latest"
        │   └─ PlatformService.launchPlayStore()
        │       └─ Open Play Store
        │           └─ Show App Page
        │
        └─ iOS Auto Redirect
            └─ PlatformService.launchWebsite()
                └─ Open Browser
                    └─ Website loads
```

## 🎨 UI Component Hierarchy

```
PlatformCheckScreen
├─ Scaffold
│  ├─ AppBar (optional, hidden in this designs)
│  └─ Body
│     └─ Container (main content)
│        ├─ Column
│        │  ├─ Header Section
│        │  │  ├─ Logo Circle (Gradient)
│        │  │  ├─ School Name (Text)
│        │  │  └─ School Tag (Text)
│        │  │
│        │  ├─ Options Section (Android)
│        │  │  ├─ Card 1: Mobile App
│        │  │  │  ├─ Icon Container
│        │  │  │  ├─ Title
│        │  │  │  └─ Description
│        │  │  ├─ Card 2: Web Version
│        │  │  │  ├─ Icon Container
│        │  │  │  ├─ Title
│        │  │  │  └─ Description
│        │  │  └─ Card 3: Download Latest
│        │  │     ├─ Icon Container
│        │  │     ├─ Title
│        │  │     └─ Description
│        │  │
│        │  └─ Info Section
│        │     ├─ Icon
│        │     ├─ Title
│        │     └─ Description Text
│        │
│        └─ Loading State (iOS)
│           ├─ Icon (Language)
│           ├─ Title
│           ├─ Description
│           └─ Progress Indicator
```

## 🔐 Security & Access Control

```
[External URLs]
     │
     ├─ Website (HTTPS)
     │  └─ Public access
     │     └─ Any browser
     │
     ├─ Google Play Store (HTTPS)
     │  └─ Public access
     │     └─ Requires Google Play Account
     │
     └─ App Store (HTTPS - Future)
        └─ Public access
           └─ Requires Apple ID

All URLs validated through url_launcher package
URL launching only through system browser
No direct network calls to external sites
```

## 📊 State Management Flow

```
App State
    │
    ├─ isIOS (boolean)
    │  └─ Set at screen init
    │
    ├─ isAndroid (boolean)
    │  └─ Set at screen init
    │
    └─ Widget State (if needed)
       └─ Can track user choice
       └─ Can track navigation

No complex state management needed
Single screen handles platform detection
Navigation handled by Flutter Navigator
```

## 🚀 Performance Flow

```
App Launch
    │
    v
[Platform Detection] ← Very fast (< 100ms)
    │
    ├─ If iOS
    │  └─ Load Redirect Screen ← Fast (prebuilt)
    │     └─ Launch URL ← Fast (system call)
    │
    └─ If Android
       └─ Load Options Screen ← Fast (prebuilt)
          └─ Wait for user choice
```

## 📝 Configuration References

```
app_config.dart
    │
    ├─ websiteUrl
    │  └─ Used by: launchWebsite()
    │     └─ Context: iOS redirect & Web option
    │
    ├─ playStoreUrl
    │  └─ Used by: launchPlayStore()
    │     └─ Context: Android download option
    │
    ├─ appStoreUrl
    │  └─ Used by: launchAppStore()
    │     └─ Context: Future iOS app store link
    │
    ├─ schoolName
    │  └─ Used by: UI display
    │     └─ Context: Header section
    │
    └─ schoolEmail
       └─ Used by: Contact/Support
          └─ Context: Support info
```

---

**This diagram shows the complete architecture and flow of your platform detection system!** 🎯
