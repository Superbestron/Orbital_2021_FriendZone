import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import '../../mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // widget tests
  testWidgets('sign in button render', (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp()
    );
    final button = find.widgetWithText(ElevatedButton, "Sign in");
    expect(button, findsOneWidget);
  });

  testWidgets('register button render', (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp()
    );
    final button = find.widgetWithText(ElevatedButton, "Register");
    expect(button, findsOneWidget);
  });
}
