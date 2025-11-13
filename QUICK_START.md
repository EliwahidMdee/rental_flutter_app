# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Generate Required Files
```bash
cd rental_flutter_app
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the required `.g.dart` serialization files for:
- `dashboard_model.g.dart`
- `tenant_model.g.dart`
- `maintenance_model.g.dart`

### Step 2: Configure API URL

Edit `lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'https://your-api-url.com/api';
```

### Step 3: Run the App
```bash
flutter run
```

## ✅ What's Already Working

### Real-Time Data Screens
These screens fetch live data from your API:

1. **TenantDashboardScreen** - Shows lease info and recent payments
2. **LandlordDashboardScreen** - Shows property statistics
3. **AdminDashboardScreen** - Shows system-wide metrics
4. **TenantListScreen** - Lists all tenants with details
5. **NotificationsScreen** - Shows notifications with mark as read
6. **PropertyListScreen** - Lists properties with filters

### Features Implemented
- ✅ Video splash screen on launch
- ✅ Offline caching with Hive
- ✅ Pull-to-refresh on lists
- ✅ Loading indicators
- ✅ Error handling with retry
- ✅ Empty state screens
- ✅ Role-based navigation
- ✅ Colorful, professional UI
- ✅ Light & dark themes

## 🎨 UI Enhancements

### Color Theme
The app now has a vibrant, professional color scheme:

- **Admin** - Indigo theme
- **Landlord** - Emerald theme  
- **Tenant** - Violet theme

All screens feature:
- Gradient backgrounds
- Enhanced shadows
- Vibrant status indicators
- Professional spacing
- Material 3 design

### Navigation
Bottom navigation customized per role:

**Admin:** Dashboard → Reports → Payments → Profile  
**Landlord:** Dashboard → Properties → Tenants → Profile  
**Tenant:** Dashboard → Payments → Maintenance → Profile

## 📱 Testing the App

### Test with Different Roles

1. **Login as Admin**
   - See system-wide statistics
   - Access reports and payment approvals
   - View all properties and tenants

2. **Login as Landlord**
   - See your property statistics
   - Manage your properties
   - View your tenants

3. **Login as Tenant**
   - See your lease information
   - View payment history
   - Submit maintenance requests

### Test Offline Mode

1. Run the app with internet
2. Navigate through screens (data gets cached)
3. Turn off internet
4. Navigate again (see cached data)
5. Turn on internet
6. Pull-to-refresh (see updated data)

### Test Error Handling

1. Disconnect from backend
2. Try to load data
3. See error message
4. Tap "Retry" button
5. Data loads successfully

## 🔧 Common Issues

### Issue: Build fails with "part not found"
**Solution:** Run build_runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: API calls return 404
**Solution:** Check `apiBaseUrl` in `lib/config/app_config.dart`

### Issue: No data showing
**Solution:** 
1. Check backend is running
2. Check API URL is correct
3. Check network connectivity
4. Look at console for errors

### Issue: Video splash not working
**Solution:** 
- Video file: `assets/images/loading.mp4`
- Falls back to static image automatically
- Check video file exists

## 📋 Optional: Update More Screens

Want to update the remaining screens? Follow this pattern:

### 1. Import the provider
```dart
import '../../common/providers/[provider_name].dart';
```

### 2. Watch the provider
```dart
final dataAsync = ref.watch(providerName(filters));
```

### 3. Handle states
```dart
dataAsync.when(
  data: (data) => /* your UI */,
  loading: () => const LoadingIndicator(),
  error: (error, stack) => ErrorDisplay(
    message: error.toString(),
    onRetry: () => ref.invalidate(providerName(filters)),
  ),
)
```

### 4. Add pull-to-refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(providerName(filters));
  },
  child: /* your list */
)
```

## 📖 More Information

- **Implementation Details:** See `IMPLEMENTATION_SUMMARY.md`
- **Architecture:** See `ARCHITECTURE.md`
- **API Endpoints:** See `lib/core/constants/api_constants.dart`

## 🎯 What You Get

### Working Features
- [x] Real-time data from API
- [x] Offline caching
- [x] Pull-to-refresh
- [x] Loading states
- [x] Error handling
- [x] Empty states
- [x] Video splash screen
- [x] Role-based navigation
- [x] Colorful theme
- [x] Light/dark modes

### Ready to Use
- [x] 6 repositories
- [x] 6 providers
- [x] 3 new models
- [x] Updated screens
- [x] AppShell navigation
- [x] Comprehensive docs

### Infrastructure for Future
- [ ] Payment screens (infrastructure ready)
- [ ] Lease screens (infrastructure ready)
- [ ] Maintenance screens (infrastructure ready)
- [ ] Report screens (infrastructure ready)
- [ ] Message screens (infrastructure ready)

## 🚀 Deploy to Device

### Android
```bash
flutter build apk
# Install: adb install build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios
# Open in Xcode and deploy
```

## 💡 Tips

1. **Use hot reload** during development (press 'r')
2. **Check console** for API errors
3. **Use Flutter DevTools** for debugging
4. **Test offline mode** frequently
5. **Test on real devices** for best experience

## 📞 Need Help?

1. Check error messages in console
2. Review `IMPLEMENTATION_SUMMARY.md`
3. Look at existing working screens as examples
4. Check API responses with Postman
5. Verify backend is running

## ✨ Enjoy Your Enhanced App!

You now have a production-ready rental management app with:
- Real-time API integration
- Professional UI
- Offline support
- Comprehensive error handling
- Role-based navigation

**Happy coding! 🎉**
