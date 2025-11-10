# # Rental Management Flutter App

A production-ready Flutter mobile application for rental property management supporting Admin, Landlord, and Tenant roles.

## 📱 Features

### Multi-Role Support
- **Admin**: Full system access, reports, payment approvals, user management
- **Landlord**: Property management, tenant tracking, payment requests, reports
- **Tenant**: Lease details, rent payment, payment history, notifications

### Core Functionalities
- ✅ Multi-auth (Email/Password, Phone OTP, Google Sign-in, Biometric)
- ✅ Offline-first architecture with automatic sync
- ✅ Push notifications (FCM)
- ✅ Light/Dark theme with system preference support
- ✅ Role-based navigation and dashboards
- ✅ Payment integration preparation
- ✅ Clean Architecture with Riverpod
- ✅ Material 3 design
- ✅ Comprehensive testing

## 🏗️ Architecture

This app follows **Clean Architecture** principles:

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)          │
│  ┌─────────────────────────────────┐│
│  │ Screens, Widgets, Providers     ││
│  └─────────────────────────────────┘│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Domain Layer (Business Logic)   │
│  ┌─────────────────────────────────┐│
│  │ Entities, Use Cases, Repos      ││
│  └─────────────────────────────────┘│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Data Layer                       │
│  ┌─────────────────────────────────┐│
│  │ Models, Repos, API, Cache       ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK** (3.16.0 or higher)
   ```bash
   # Download from https://docs.flutter.dev/get-started/install
   flutter --version
   flutter doctor
   ```

2. **IDE** (Choose one)
   - Android Studio with Flutter/Dart plugins
   - VS Code with Flutter/Dart extensions

3. **Platform Requirements**
   - **Android**: Android SDK (API 21-34), Java JDK 11+
   - **iOS**: Xcode 14+, CocoaPods (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/EliwahidMdee/rental_flutter_app.git
   cd rental_flutter_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure environment**
   - Copy `.env.example` to `.env` and update values
   - Update API URLs in `lib/config/app_config.dart`

5. **Run the app**
   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device_id>
   
   # Run in release mode
   flutter run --release
   ```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── config/                            # Configuration
│   ├── app_config.dart               # Environment & API configs
│   ├── routes.dart                   # Route definitions
│   └── theme.dart                    # Theme configuration
├── core/                              # Core utilities
│   ├── constants/                    # App constants
│   ├── errors/                       # Custom exceptions
│   ├── network/                      # API client
│   ├── storage/                      # Local storage
│   └── utils/                        # Utility functions
├── data/                              # Data layer
│   ├── models/                       # Data models (JSON)
│   ├── repositories/                 # Repository implementations
│   └── datasources/                  # Remote & local data sources
├── presentation/                      # UI layer
│   ├── common/                       # Shared widgets
│   ├── auth/                         # Authentication screens
│   ├── admin/                        # Admin role UI
│   ├── landlord/                     # Landlord role UI
│   └── tenant/                       # Tenant role UI
└── services/                          # Services
    ├── notification_service.dart
    └── cache_service.dart
```

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔧 Configuration

### API Configuration

Update `lib/config/app_config.dart`:

```dart
static String get apiBaseUrl {
  switch (environment) {
    case 'development':
      return 'http://10.0.2.2:8000/api';
    case 'production':
      return 'https://yourdomain.com/api';
  }
}
```

### Firebase Setup (Optional)

1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app: Package name from `android/app/build.gradle`
3. Download `google-services.json` to `android/app/`
4. Add iOS app and download `GoogleService-Info.plist` to `ios/Runner/`
5. Run: `flutter pub get`

## 📱 Building for Production

### Android

```bash
# Generate keystore
keytool -genkey -v -keystore rental-app.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias rental-app

# Configure signing in android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=rental-app
storeFile=<path-to-keystore>

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Open Xcode workspace
cd ios
pod install
open Runner.xcworkspace

# In Xcode:
# 1. Configure Bundle ID and Signing
# 2. Product > Archive
# 3. Distribute to App Store
```

## 🎨 Theming

The app supports light/dark themes with Material 3:

```dart
// Switch theme
ThemeMode.light
ThemeMode.dark
ThemeMode.system  // Follows system preference
```

Role-specific accent colors:
- Admin: Blue (#3B82F6)
- Landlord: Green (#10B981)
- Tenant: Purple (#8B5CF6)

## 🔐 Security

- **Token Storage**: Flutter Secure Storage for auth tokens
- **SSL Pinning**: Implemented for production builds
- **Input Validation**: All forms validated
- **Secure Communication**: HTTPS-only API calls
- **Biometric Auth**: Optional fingerprint/face ID

## 📚 Documentation

- [Architecture Diagram](ARCHITECTURE_DIAGRAM.txt)
- [Comprehensive Guide](COMPREHENSIVE_GUIDE.txt)
- [Development Guide](FLUTTER_APP_DEVELOPMENT_GUIDE.txt)
- [Code Examples](CODE_EXAMPLES.txt)
- [Folder Structure](FOLDER_STRUCTURE_TEMPLATE.txt)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Development Team** - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors to the open-source packages used
- Community for feedback and support

## 📞 Support

For issues and questions:
- Open an issue in this repository
- Contact the development team
- Check documentation files

---

**Built with ❤️ using Flutter**