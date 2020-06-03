// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pos_labs_demo/core/enums/biometric_type.dart';
import 'package:pos_labs_demo/core/models/models.dart';
import 'package:pos_labs_demo/main.dart';
import 'package:pos_labs_demo/ui/keys.dart';
import 'package:pos_labs_demo/ui/widgets/widgets.dart';

import 'blocs/location_bloc_test.dart';
import 'blocs/login_bloc_test.dart';

void main() {
  MockAuthService _auth;
  MockLocationService _locationService;

  setUp(() {
    _auth = MockAuthService();
    _locationService = MockLocationService();
  });

  Future<void> buildLoginView(WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(POSLabsDemo(authService: _auth));

    // Wait until no more frames are scheduled (true when loading complete)
    await tester.pumpAndSettle();
  }

  Future<void> buildMapView(WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(POSLabsDemo(
      locationService: _locationService,
      initialRoute: '/map',
    ));

    // Wait until no more frames are scheduled (true when loading complete)
    await tester.pumpAndSettle();
  }

  group('LoginView', () {
    testWidgets('| No Biometrics', (WidgetTester tester) async {
      // Setup mock services for proper bloc flow
      when(_auth.availableBiometricType)
          .thenAnswer((_) async => BiometricType.None);

      // Build the login view
      await buildLoginView(tester);

      // Make sure there are the correct number of buttons
      expect(find.byKey(Keys.loginWithFacebookButton), findsOneWidget);
      expect(find.byKey(Keys.loginWithBiometricsButton), findsOneWidget);
      expect(find.byKey(Keys.requestPushNotificationButton), findsOneWidget);
      expect(find.byType(RaisedButton), findsNWidgets(3));
    });

    testWidgets('| Touch Biometrics', (WidgetTester tester) async {
      // Setup mock services for proper bloc flow
      when(_auth.availableBiometricType)
          .thenAnswer((_) async => BiometricType.Touch);

      // Build the login view
      await buildLoginView(tester);

      // Make sure there are the correct number of buttons
      expect(find.byKey(Keys.loginWithFacebookButton), findsOneWidget);
      expect(find.byKey(Keys.loginWithBiometricsButton), findsOneWidget);
      expect(find.byKey(Keys.requestPushNotificationButton), findsOneWidget);
      expect(find.byType(RaisedButton), findsNWidgets(3));
    });

    testWidgets('| Face Biometrics', (WidgetTester tester) async {
      // Setup mock services for proper bloc flow
      when(_auth.availableBiometricType)
          .thenAnswer((_) async => BiometricType.Face);

      // Build the login view
      await buildLoginView(tester);

      // Make sure there are the correct number of buttons
      expect(find.byKey(Keys.loginWithFacebookButton), findsOneWidget);
      expect(find.byKey(Keys.loginWithBiometricsButton), findsOneWidget);
      expect(find.byKey(Keys.requestPushNotificationButton), findsOneWidget);
      expect(find.byType(RaisedButton), findsNWidgets(3));
    });

    testWidgets('| Exception', (WidgetTester tester) async {
      // Setup mock services for proper bloc flow
      when(_auth.availableBiometricType)
          .thenAnswer((_) async => BiometricType.None);
      when(_auth.initiateFacebookLogin()).thenThrow(Exception());

      // Build the login view
      await buildLoginView(tester);

      // Tap the Login button
      await tester.tap(find.byKey(Keys.loginWithFacebookButton));

      // Rebuild the widget after the state has changed
      await tester.pump();

      // Expect to find an ExceptionView
      expect(find.byType(ExceptionView), findsOneWidget);
    });
  });

  group('MapView', () {
    testWidgets('| Map loaded successfully', (WidgetTester tester) async {
      // Setup location services
      when(_locationService.getUserLocation())
          .thenAnswer((_) async => mockLocation);

      // Build the map view
      await buildMapView(tester);

      // Expect to find a GoogleMap and a FloatingActionButton
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('| Exception', (WidgetTester tester) async {
      // Setup location services
      when(_locationService.getUserLocation())
          .thenThrow(LocationException.unknown());

      // Build the map view
      await buildMapView(tester);

      // Expect to find an ExceptionView widget
      expect(find.byType(ExceptionView), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
