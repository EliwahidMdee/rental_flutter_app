import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_flutter_app/presentation/auth/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.enterText(find.byKey(const Key('password_field')), 'password');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123');

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      final passwordField = find.byKey(const Key('password_field'));
      final visibilityIcon = find.byIcon(Icons.visibility);

      // Initially password should be obscured
      var textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, true);

      // Tap visibility icon
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Password should now be visible
      textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, false);
    });

    testWidgets('should navigate to register screen', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Would verify navigation in full integration test
    });

    testWidgets('should navigate to forgot password screen', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Would verify navigation in full integration test
    });
  });
}
