import 'package:flutter/material.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5.0),
              backgroundColor: MaterialStateProperty.all(ORANGE_1),
              textStyle: MaterialStateProperty.all(TextStyle(
                color: Colors.black,
              ))
            )
          )
        ),
        home: Wrapper(),
      ),
    );
  }
}




