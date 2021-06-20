import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/create_event/create_event.dart';
import 'package:myapp/services/auth.dart';
import '../../mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
import 'package:myapp/models/event.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('input labels', (tester) async {
    await tester.pumpWidget(
      StreamProvider<UserObj?>.value(
          initialData: null,
          value: AuthService().user,
          child: MaterialApp(
              home: StreamProvider<List<Event>?>.value(
                initialData: null,
                value: DatabaseService(uid: '').events,
                child: CreateEvent(jumpToPage: () {}),
              )
          )),
    );
    final text1 = find.text("Select Date:");
    final text2 = find.text("Select Time:");
    final text3 = find.text("Pax: ");
    final text4 = find.text("Location: ");
    final text5 = find.text("Choose your event icon: ");
    expect(text1, findsOneWidget);
    expect(text2, findsOneWidget);
    expect(text3, findsOneWidget);
    expect(text4, findsOneWidget);
    expect(text5, findsOneWidget);
  });
}
