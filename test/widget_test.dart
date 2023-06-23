import 'package:cpd_ss23/jobs/jobs_screen.dart';
import 'package:cpd_ss23/login_page/login_screen.dart';
import 'package:cpd_ss23/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import './mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Firebase Initialization Test', (WidgetTester tester) async {
    // Initialize Firebase

    // Check if Firebase is initialized
    final isFirebaseInitialized = Firebase.apps.isNotEmpty;

    // Perform your test assertions
    expect(isFirebaseInitialized, isTrue);
  });

  testWidgets('UserState Widget - User not logged in',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: UserState()));

    // Überprüfen, ob das Login-Widget angezeigt wird
    expect(find.byType(Login), findsOneWidget);

    // Überprüfen, ob das JobScreen-Widget nicht angezeigt wird
    expect(find.byType(JobScreen), findsNothing);
  });
}
