import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:myapp/shared/constants.dart';
import '../../mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('shows events', (WidgetTester tester) async {
    // Populate the fake database.
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('events').doc('AGjugV0E0fb7xrlP3MUA').set({
      'location': 'Yusof Ishak House',
      'telegramURL': 't.me/joinchat/0EkZ8yz0kJ40NjQ9',
      'name': 'Event1',
      'dateTime': DateTime(2022, 1, 1),
      'pax': 10,
      'description': 'Event1 Test',
      'icon': 3,
      'eventID': 'AGjugV0E0fb7xrlP3MUA', // Random eventID
      // my accounts Tze Henn and james
      'attendees': [
        'buFK2djrl7TNbK1SBz4uRsoITKG2',
        'VYfDfuEAdHOJJvbGG6lRi4CrjiW2'
      ],
      'eventMarked': false,
    });

    Home.setFirebaseFirestore(firestore);
    // Render the widget.
    await tester
        .pumpWidget(MaterialApp(title: 'Firestore Example', home: Home()));

    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pumpAndSettle();

    // Verify if the animations work correctly
    var slideTransition = find.byType(SlideTransition);
    expect(slideTransition, findsOneWidget);

    // Verify the output.
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Event1'), findsOneWidget);
    expect(find.text('1/1/22'), findsOneWidget);
    expect(find.text('2 / 10'), findsOneWidget);
    expect(find.byWidget(IMAGE_LIST[3]), findsOneWidget);
  });

  testWidgets('titles', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Home(),
      ),
    );
    await tester.pumpAndSettle(Duration(seconds: 5));
    final title = find.text("Upcoming Events");
    final title1 = find.text("Home");
    final title2 = find.text("Maps");
    final title3 = find.text("Create");
    final title4 = find.text("Notifications");
    final title5 = find.text("Profile");
    final button = find.text("Sign Out");
    expect(title, findsOneWidget);
    expect(title1, findsOneWidget);
    expect(title2, findsOneWidget);
    expect(title3, findsOneWidget);
    expect(title4, findsOneWidget);
    expect(title5, findsOneWidget);
    expect(button, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 5));
  });

  testWidgets('search', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    await tester.pumpAndSettle();
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.tap(textField);

    await tester.enterText(textField, 'Hello');
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Hello'), findsOneWidget);

    // TODO: Test if search function is working correctly
  });
}
