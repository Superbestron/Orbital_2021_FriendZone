import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/screens/authenticate/sign_in.dart';
import '../../mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  // widget tests
  testWidgets('sign in button render', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignIn(toggleView: () {})));
    final button = find.text("Sign In");
    expect(button, findsOneWidget);
  });

  testWidgets('register button render', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignIn(toggleView: () {})));
    final button = find.widgetWithText(GestureDetector, "Register");
    expect(button, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('no error message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignIn(toggleView: () {})));
    final msg = find.widgetWithText(Text, "Incorrect Email/Password!");
    expect(msg, findsNothing);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('empty sign in', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignIn(toggleView: () {})));
    final button = find.widgetWithText(ElevatedButton, "Sign In");
    await tester.tap(button);
    await tester.pump();
    final error1 = find.text("Enter a NUS email");
    final error2 = find.text("Enter a password 6+ chars long");
    expect(error1, findsOneWidget);
    expect(error2, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
