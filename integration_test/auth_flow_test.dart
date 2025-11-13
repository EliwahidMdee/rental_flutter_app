import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rental_management_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('complete auth flow: login -> dashboard -> logout', 
        (WidgetTester tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should navigate to login screen
      expect(find.text('Welcome Back'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'tenant@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Should navigate to tenant dashboard
      expect(find.text('Tenant Dashboard'), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget);

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Tap logout
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Confirm logout
      await tester.tap(find.text('Yes, Logout'));
      await tester.pumpAndSettle();

      // Should return to login screen
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('registration flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to register screen
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);

      // Fill registration form
      await tester.enterText(find.byKey(const Key('name_field')), 'New User');
      await tester.enterText(find.byKey(const Key('email_field')), 'newuser@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'password123');

      // Select role
      await tester.tap(find.text('Tenant'));
      await tester.pump();

      // Submit registration
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Would navigate to dashboard in real scenario
    });

    testWidgets('forgot password flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to forgot password screen
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);

      // Enter email
      await tester.enterText(find.byKey(const Key('email_field')), 'user@example.com');

      // Submit
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Reset link sent'), findsOneWidget);
    });
  });
}
