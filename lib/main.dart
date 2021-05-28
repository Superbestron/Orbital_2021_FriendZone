import 'package:flutter/material.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/services/auth.dart';
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
        // theme: ThemeData(
        //     primaryColor: Colors.white,
        //     scaffoldBackgroundColor: Colors.white),
        home: Wrapper(),
      ),
    );
  }
}




