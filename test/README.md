# Add necessary test dependencies to pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mocktail: ^1.0.0
  flutter_lints: ^3.0.0

# Test coverage
# Run tests with coverage:
# flutter test --coverage
# 
# Generate HTML report:
# genhtml coverage/lcov.info -o coverage/html
# 
# Open report:
# open coverage/html/index.html

# Running tests:
# All tests: flutter test
# Unit tests: flutter test test/unit/
# Widget tests: flutter test test/widget/
# Integration tests: flutter test integration_test/
