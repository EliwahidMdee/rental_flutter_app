# Quick Start Guide - Rental Management Flutter App

## 🚀 Quick Setup (5 minutes)

### 1. Prerequisites Check
```bash
# Verify Flutter installation
flutter doctor -v

# Should show:
# ✓ Flutter (Channel stable, 3.16.0 or higher)
# ✓ Android toolchain
# ✓ Xcode (for iOS development - macOS only)
# ✓ Connected devices
```

### 2. Clone and Install
```bash
# Clone the repository
git clone https://github.com/EliwahidMdee/rental_flutter_app.git
cd rental_flutter_app

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure Backend
```dart
// Edit lib/config/app_config.dart

static String get apiBaseUrl {
  switch (environment) {
    case 'development':
      return 'http://10.0.2.2:8000/api';  // Android Emulator
      // return 'http://localhost:8000/api';  // iOS Simulator
    case 'production':
      return 'https://your-api-domain.com/api';
  }
}
```

### 4. Run the App
```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Or specify device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## 🧪 Test Login Credentials

The app currently uses mock authentication for development:

### Admin Access
- Email: `admin@example.com`
- Password: `any password (6+ characters)`

### Landlord Access
- Email: `landlord@example.com`
- Password: `any password (6+ characters)`

### Tenant Access
- Email: `tenant@example.com` or `user@example.com`
- Password: `any password (6+ characters)`

## 📱 Features Currently Implemented

### ✅ Completed
- Project structure and configuration
- Clean Architecture setup
- Authentication flow (mock)
- Role-based routing
- Material 3 theming (light/dark)
- Splash screen
- Login screen
- Three role-specific dashboards (Admin, Landlord, Tenant)
- Secure storage for tokens
- Local caching with Hive
- Basic navigation

### 🚧 In Progress
- API integration with Laravel backend
- Complete CRUD operations for properties
- Payment processing
- Notifications system
- Offline sync
- Complete testing suite

## 🔧 Development Commands

```bash
# Run tests
flutter test

# Run with specific environment
flutter run --dart-define=ENVIRONMENT=development

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release

# Analyze code
flutter analyze

# Format code
flutter format .

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📂 Key Files to Know

- `lib/main.dart` - App entry point
- `lib/config/app_config.dart` - Environment configuration
- `lib/config/routes.dart` - Navigation routes
- `lib/config/theme.dart` - UI theme configuration
- `lib/presentation/auth/providers/auth_provider.dart` - Authentication logic
- `pubspec.yaml` - Dependencies

## 🎨 Role-Based Color Scheme

- **Admin**: Blue (#3B82F6)
- **Landlord**: Green (#10B981)
- **Tenant**: Purple (#8B5CF6)

## 📖 Next Steps

1. **Connect to Backend**: Update API configuration with your Laravel backend URL
2. **Implement Features**: Follow DEVELOPMENT_CHECKLIST.md for feature implementation
3. **Add Tests**: Write unit, widget, and integration tests
4. **Deploy**: Follow deployment guides for Android/iOS

## 🆘 Troubleshooting

### Flutter Doctor Issues
```bash
# Update Flutter
flutter upgrade

# Clean and rebuild
flutter clean
flutter pub get
```

### Build Errors
```bash
# Clear build cache
flutter clean
rm -rf build/

# Reinstall dependencies
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

### Android Emulator Network Issues
- Use `10.0.2.2` instead of `localhost` for Android emulator
- Ensure emulator has internet access
- Check firewall settings

## 📚 Documentation

- [Comprehensive Guide](COMPREHENSIVE_GUIDE.txt) - Full implementation guide
- [Development Guide](FLUTTER_APP_DEVELOPMENT_GUIDE.txt) - Step-by-step development
- [Code Examples](CODE_EXAMPLES.txt) - Ready-to-use code snippets
- [Architecture Diagram](ARCHITECTURE_DIAGRAM.txt) - System architecture
- [Development Checklist](DEVELOPMENT_CHECKLIST.md) - Feature tracking

## 💡 Tips

1. **Start Small**: Begin with one role (e.g., Tenant) and expand
2. **Test Often**: Run `flutter analyze` and `flutter test` frequently
3. **Follow Patterns**: Look at existing code for patterns and structure
4. **Use Hot Reload**: Press `r` in terminal for hot reload, `R` for hot restart
5. **Check Guides**: Reference the comprehensive guides for detailed implementations

## 🔐 Security Notes

- Never commit sensitive data (API keys, tokens) to version control
- Use environment variables for configuration
- Keep dependencies updated
- Follow security best practices from COMPREHENSIVE_GUIDE.txt

---

**Ready to start developing?** Run `flutter run` and begin building! 🚀
