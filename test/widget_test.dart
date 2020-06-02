// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pos_labs_demo/core/enums/biometric_type.dart';

import 'package:pos_labs_demo/core/services/auth_service.dart';
import 'package:pos_labs_demo/main.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  MockAuthService _auth;

  setUp(() {
    _auth = MockAuthService();
  });

  group('Appropriate number of buttons', () {
    testWidgets('| No Biometrics', (WidgetTester tester) async {
      // Setup mock services for proper bloc flow
      when(_auth.availableBiometricType)
          .thenAnswer((_) async => BiometricType.None);

      // Build our app and trigger a frame.
      await tester.pumpWidget(POSLabsDemo(authService: _auth));

      // Wait until no more frames are scheduled (true when loading complete)
      await tester.pumpAndSettle();

      // Make sure there are exactly 1 RaisedButton (no login with Touch/Face ID)
      expect(find.byType(RaisedButton), findsOneWidget);
    });
  });
}
