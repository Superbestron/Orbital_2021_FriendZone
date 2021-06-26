import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/home/home.dart';
import '../../mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('home title', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Home(),
    ));
    final title = find.text("Upcoming Events");
    expect(title, findsOneWidget);
  });

  testWidgets('navigation bar title', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Home(),
    ));
    final title1 = find.text("Home");
    final title2 = find.text("Maps");
    final title3 = find.text("Create");
    final title4 = find.text("Notifications");
    final title5 = find.text("Profile");
    expect(title1, findsOneWidget);
    expect(title2, findsOneWidget);
    expect(title3, findsOneWidget);
    expect(title4, findsOneWidget);
    expect(title5, findsOneWidget);
  });

  testWidgets('logout button render', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Home(),
    ));
    final button = find.text("logout");
    expect(button, findsOneWidget);
  });
}
