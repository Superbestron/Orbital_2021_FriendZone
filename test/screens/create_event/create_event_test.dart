import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/create_event/create_event.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
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
          value: AuthService(auth: FirebaseAuth.instance).user,
          child: MaterialApp(
              home: StreamProvider<List<Event>?>.value(
                initialData: null,
                value: DatabaseService.events,
                child: CreateEvent(jumpToPage: () {}),
              )
          )),
    );
    final textFields = find.byType(TextField);
    final text1 = find.text('Event Name');
    final nameField = textFields.at(0);
    final text2 = find.text("Select Date:");
    final text3 = find.text("Select Time:");
    final text4 = find.text("Event Description");
    final descriptionField = textFields.at(1);
    final text5 = find.text("Telegram chat URL");
    final telegramField = textFields.at(2);
    final text6 = find.text("Pax: ");
    final text7 = find.text("Location: ");
    final text8 = find.text("Choose your event category:");

    expect(text1, findsOneWidget);
    await tester.tap(nameField);
    await tester.enterText(nameField, 'eventName');
    expect(find.text('eventName'), findsOneWidget);
    expect(text2, findsOneWidget);
    expect(text3, findsOneWidget);
    expect(text4, findsOneWidget);
    await tester.tap(descriptionField);
    await tester.enterText(descriptionField, 'descriptionName');
    expect(find.text('descriptionName'), findsOneWidget);
    expect(text5, findsOneWidget);
    await tester.tap(telegramField);
    await tester.enterText(telegramField, 'telegramURL');
    expect(find.text('telegramURL'), findsOneWidget);
    expect(text6, findsOneWidget);
    expect(text7, findsOneWidget);
    expect(text8, findsOneWidget);
  });

  testWidgets('create event', (tester) async {
    await tester.pumpWidget(
      StreamProvider<UserObj?>.value(
          initialData: null,
          value: AuthService(auth: FirebaseAuth.instance).user,
          child: MaterialApp(
              home: StreamProvider<List<Event>?>.value(
                initialData: null,
                value: DatabaseService.events,
                child: CreateEvent(jumpToPage: () {}),
              )
          )),
    );

    // 1st Icon is selected by default
    List<bool> _isSelected = [true, false, false, false, false];
    String _name = 'eventName';
    String _telegramURL = 'telegramURL';
    DateTime _dateTime =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);
    TimeOfDay _time = TimeOfDay.now();
    int _pax = 2;
    String _description = 'descriptionName';
    int _icon = 0;
    List<int> numbers = List.generate(9, (index) => index++);

    String _location = LOCATIONS[0][0];

    final textFields = find.byType(TextField);
    final nameField = textFields.at(0);
    final descriptionField = textFields.at(1);
    final telegramField = textFields.at(2);

    await tester.tap(nameField);
    await tester.enterText(nameField, _name);

    await tester.tap(descriptionField);
    await tester.enterText(descriptionField, _description);

    await tester.tap(telegramField);
    await tester.enterText(telegramField, _telegramURL);
  });
}
