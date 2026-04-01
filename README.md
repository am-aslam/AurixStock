<p align="center">
  <img src="assets/images/logo_placeholder.png" width="100" alt="AurixStock Logo"/>
</p>

<h1 align="center">AurixStock</h1>
<p align="center"><strong>Premium Gold Stock Manager — Flutter Android App</strong></p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Version-2.0.0-E6C068?logo=github&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-22C55E" />
</p>

---

## 📥 Download App

[![Download APK](https://img.shields.io/badge/⬇_Download_APK-Release_v2.0.0-E6C068?style=for-the-badge)](../../releases/latest)

## 📱 Installation

1. Download the **APK** from [Releases](../../releases)
2. On your Android phone: **Settings → Security → Install Unknown Apps → Enable**
3. Open the downloaded `.apk` file and tap **Install**
4. Launch **AurixStock** ✨

---

## 🚀 Features

| Feature | Description |
|---------|-------------|
| 📊 **Dashboard** | Real-time stock value, weight, charts |
| 💎 **Stock Management** | Add/edit/delete gold entries with swipe gestures |
| 👥 **Vendor Management** | Track vendors with credit/debit balances |
| 📒 **Ledger** | Full transaction history with payment modes |
| 📈 **Analytics** | Monthly charts, category breakdown, karat analysis |
| 📤 **Export** | CSV & PDF export, file sharing |
| 🔒 **App Lock** | PIN and biometric lock support |
| 🌙 **Dark Mode** | Beautiful Liquid Gold + Midnight Blue UI |
| 📴 **Offline-First** | All data stored locally with Hive |
| 🔍 **Search & Filter** | Filter by category, karat, type, vendor |

---

## 🎨 UI Design System

**Liquid Gold + Midnight Blue + Glassmorphism**

```
Primary Gold:   #E6C068
Soft Gold:      #F4D58D
Dark Gold:      #B8963A
Glow:           #FFD700
Background:     #0A0B10
Surface:        #12141C
Elevated:       #181A24
```

---

## 🏗️ Architecture

```
lib/
├── main.dart                  # Entry point
├── theme.dart                 # AurixColors + AurixTypography + AurixTheme
├── core/
│   ├── constants/             # AppConstants
│   ├── router/                # GoRouter navigation
│   └── utils/                 # AppUtils (formatting)
├── models/                    # Hive data models + adapters
│   ├── stock_entry.dart + .g.dart
│   ├── vendor.dart + .g.dart
│   └── transaction.dart + .g.dart
├── services/                  # Repositories + ExportService
│   ├── hive_service.dart
│   ├── stock_repository.dart
│   ├── vendor_repository.dart
│   ├── transaction_repository.dart
│   └── export_service.dart
├── providers/                 # Riverpod state management
│   └── providers.dart
├── screens/                   # All UI screens
│   ├── splash_screen.dart
│   ├── app_lock_screen.dart
│   ├── shell_screen.dart      # Nav bar shell
│   ├── dashboard_screen.dart
│   ├── stock_screen.dart
│   ├── add_edit_stock_screen.dart
│   ├── vendor_screen.dart
│   ├── add_edit_vendor_screen.dart
│   ├── vendor_detail_screen.dart
│   ├── transaction_screen.dart
│   ├── add_transaction_screen.dart
│   ├── analytics_screen.dart
│   ├── settings_screen.dart
│   └── export_screen.dart
└── widgets/
    └── common/
        └── common_widgets.dart  # GlassCard, GoldButton, EmptyState, etc.
```

**State Management:** Flutter Riverpod (StateNotifierProvider + Provider)  
**Local Storage:** Hive (offline-first, typed boxes)  
**Navigation:** GoRouter (declarative, shell routes)  
**Charts:** fl_chart  
**Animations:** flutter_animate  

---

## 🛠️ Setup & Run

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Android Studio / VS Code
- Android device / emulator (API 23+)

### Steps

```bash
# 1. Clone or extract the project
cd AurixStock

# 2. Install dependencies
flutter pub get

# 3. Run in debug mode
flutter run

# 4. Run on specific device
flutter run -d <device-id>
```

---

## 📦 Build Release APK

### Step 1 — Create keystore

```bash
mkdir -p android/keystore
keytool -genkey -v \
  -keystore android/keystore/aurix-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias aurix_key
```

### Step 2 — Create `android/key.properties`

```properties
storePassword=YourStorePassword
keyPassword=YourKeyPassword
keyAlias=aurix_key
storeFile=../keystore/aurix-release.jks
```

### Step 3 — Build

```bash
# Release APK
flutter build apk --release \
  --build-name=2.0.0 \
  --build-number=1

# Release App Bundle (Play Store)
flutter build appbundle --release \
  --build-name=2.0.0 \
  --build-number=1
```

### Output locations
```
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

---

## 🐙 GitHub Release Setup

```bash
# Tag the release
git add .
git commit -m "feat: AurixStock v2.0.0 — Premium Gold Manager"
git tag -a v2.0.0 -m "Release v2.0.0"
git push origin main --tags
```

Then on GitHub:
1. Go to **Releases** → **Draft new release**
2. Select tag `v2.0.0`
3. Attach `app-release.apk`
4. Publish release

---

## 📋 Release Notes v2.0.0

### ✨ New
- Complete ground-up Flutter rebuild
- Liquid Gold + Midnight Blue Glassmorphism UI
- Riverpod state management
- Analytics dashboard with fl_chart
- PDF & CSV export with file sharing
- Biometric + PIN app lock
- Swipe-to-edit / swipe-to-delete
- Search & advanced filtering

### 🗑️ Removed
- Secret space feature (removed for security)

### 🔧 Improved
- Offline-first with Hive typed storage
- Smooth animations (flutter_animate)
- Material 3 compliant design system
- GoRouter declarative navigation

---

## 📄 License

MIT © 2025 AurixStock. All rights reserved.
