import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/profile/profile_page.dart';
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
  testWidgets('profile page build', (tester) async {
    await tester.pumpWidget(
      StreamProvider<UserObj?>.value(
          initialData: UserObj(uid: '0'),
          value: AuthService(auth: FirebaseAuth.instance).user,
          child: MaterialApp(
              home: StreamProvider<List<Event>?>.value(
                initialData: null,
                value: DatabaseService.events,
                child: ProfilePage(profileID: '0'),
              )
          )),
    );
  });
}
