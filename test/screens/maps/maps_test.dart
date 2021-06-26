import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/maps/maps.dart';
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

  testWidgets('maps render', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: StreamProvider<List<Event>?>.value(
        initialData: null,
        value: DatabaseService.events,
        child: Maps(),
      )
    ));
  });
}
