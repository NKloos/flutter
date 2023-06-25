import 'package:cpd_ss23/jobs/jobs_screen.dart';
import 'package:cpd_ss23/login_page/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    await tester.pumpWidget(MaterialApp(home: Login()));

    // Überprüfen, ob das Login-Widget angezeigt wird
    expect(find.byType(Login), findsOneWidget);

    // Überprüfen, ob das Login-Widget nicht angezeigt wird
    expect(find.byType(JobScreen), findsNothing);
  });

  testWidgets('UserState Widget - User logged in', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Login()));

    // Überprüfen, ob das Login-Widget angezeigt wird
    expect(find.byType(Login), findsOneWidget);

    // Texteingabe in die E-Mail- und Passwortfelder
    final textFormFields = find.byType(TextFormField);
    if (textFormFields.evaluate().isEmpty) {
      fail('TextFormFields not found');
    } else {
      await tester.enterText(textFormFields.at(0), 'davidwinterhalter@gmx.de');
      await tester.enterText(textFormFields.at(1), '123456');

      // 'Login'-Button drücken
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Überprüfen, ob das Login-Widget nicht angezeigt wird
      expect(find.byType(Login), findsNothing);

      // Überprüfen, ob das JobScreen-Widget angezeigt wird
      expect(find.byType(JobScreen), findsOneWidget);
    }
  });
}
