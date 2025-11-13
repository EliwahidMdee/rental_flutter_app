import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'core/storage/local_storage.dart';
import 'presentation/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local caching
  await Hive.initFlutter();
  await LocalStorage.init();
  
  // Initialize Firebase (if using)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(
    const ProviderScope(
      child: RentalManagementApp(),
    ),
  );
}

class RentalManagementApp extends ConsumerStatefulWidget {
  const RentalManagementApp({super.key});

  @override
  ConsumerState<RentalManagementApp> createState() => _RentalManagementAppState();
}

class _RentalManagementAppState extends ConsumerState<RentalManagementApp> {
  @override
  void initState() {
    super.initState();
    // Trigger auth status check once on startup so any persisted session is restored
    Future.microtask(() => ref.read(authStateProvider.notifier).checkAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Routing
      routerConfig: router,
    );
  }
}
