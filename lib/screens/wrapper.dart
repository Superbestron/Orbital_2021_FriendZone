import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/authenticate/authenticate.dart';
import 'package:myapp/screens/authenticate/verify_email.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:myapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final UserObj? user = Provider.of<UserObj?>(context);
    final AuthService _auth = AuthService(auth: FirebaseAuth.instance);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
      /// Uncomment these lines to enable email verification
    } else if (!_auth.checkEmailVerified()) {
      return VerifyEmail(auth: _auth);
    } else {
      return Home();
    }
  }
}
