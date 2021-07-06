import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/local_notification_service.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';

// Receive message when app is in background solution for on message
Future backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserObj?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.transparent,
          buttonColor: ORANGE_1,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: ORANGE_1,
              onPrimary: Colors.white,
            )
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: ORANGE_1,
            foregroundColor: Colors.white
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: GREEN_1
          ),
          accentColor: ORANGE_1,
          iconTheme: IconThemeData(
            color: ORANGE_1
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: TextStyle(
              color: Colors.black
            ),
          )
        ),
        home: Wrapper(),
      ),
    );
  }
}




