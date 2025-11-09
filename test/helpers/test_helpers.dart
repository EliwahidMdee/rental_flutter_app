import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper function to wrap widgets with necessary providers for testing
Widget createTestApp({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Helper to pump a widget with providers
Future<void> pumpProviderWidget(
  WidgetTester tester,
  Widget widget, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    createTestApp(
      child: widget,
      overrides: overrides,
    ),
  );
}

/// Helper to find widgets by key safely
Finder findByKeyOrText(dynamic keyOrText) {
  if (keyOrText is Key) {
    return find.byKey(keyOrText);
  } else if (keyOrText is String) {
    return find.text(keyOrText);
  }
  throw ArgumentError('keyOrText must be a Key or String');
}

/// Helper to wait for async operations
Future<void> waitForAsync(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await Future.delayed(const Duration(milliseconds: 100));
  await tester.pump();
}

/// Helper to enter text in a field
Future<void> enterTextInField(
  WidgetTester tester,
  dynamic fieldKey,
  String text,
) async {
  await tester.enterText(findByKeyOrText(fieldKey), text);
  await tester.pump();
}

/// Helper to tap a widget
Future<void> tapWidget(
  WidgetTester tester,
  dynamic widgetKey, {
  bool settle = true,
}) async {
  await tester.tap(findByKeyOrText(widgetKey));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Helper to scroll until widget is visible
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder finder,
  double scrollDelta, {
  Finder? scrollable,
}) async {
  scrollable ??= find.byType(Scrollable).first;
  
  await tester.scrollUntilVisible(
    finder,
    scrollDelta,
    scrollable: scrollable,
  );
  await tester.pumpAndSettle();
}

/// Helper to verify snackbar message
void expectSnackBar(String message) {
  expect(find.text(message), findsOneWidget);
  expect(find.byType(SnackBar), findsOneWidget);
}

/// Helper to verify dialog
void expectDialog(String title) {
  expect(find.text(title), findsOneWidget);
  expect(find.byType(Dialog), findsOneWidget);
}
