import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool isNUS = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {

    var defaultLogin = <Widget>[
      SvgPicture.asset('assets/logo.svg'),
      Container(
        height: 205,
        child: Column(
          children: [
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (val) => setState(() { email = val; }),
            ),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Password'),
              validator: (val) { return val!.length < 6
                  ? 'Enter a password 6+ chars long' : null; },
              obscureText: true,
              onChanged: (val) => setState(() { password = val; }),
            ),
            ElevatedButton(
                child: Text('Sign in', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() { loading = true; });
                    dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = 'could not sign in with those credentials';
                      });
                    }
                  }
                }),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
      SvgPicture.asset('assets/tree.svg'),
    ];

    // ignore: non_constant_identifier_names
    var NUSLogin = <Widget>[
      SizedBox(height: 80.0),
      SvgPicture.asset('assets/logo.svg'),
      SizedBox(height: 20.0),
      Stack(
        children: <Widget>[
          Center(
            child:SvgPicture.asset(
              'assets/login.svg',
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(22.0),
              child: ElevatedButton(
                child: Text('NUSNET ID', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    email = "admin@google.com"; // default email for dev
                    password = "adminadmin"; // default password for dev
                    setState(() { loading = true; });
                    dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = 'could not sign in with those credentials';
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: ORANGE_1,
                  minimumSize: Size(135, 40),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),
      ),
      SvgPicture.asset('assets/tree.svg'),
    ];

    return loading ? Loading() : Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: isNUS
                ? NUSLogin
                : defaultLogin,
          ),
        ),
      ),
    );
  }
}

// old app bar

// flutter pub get
// to install dependencies in flutter
// appBar: AppBar(
//     backgroundColor: GREEN_1,
//     elevation: 0.0,
//     title: Text('Sign in to FriendZone'),
//     actions: <Widget>[
//         TextButton.icon(
//         icon: Icon(Icons.person),
//         label: Text('Register'),
//         onPressed: () { widget.toggleView(); },
//         )
//     ]
// ),
