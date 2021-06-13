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

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    var loginWidget = <Widget>[
      Stack(
        children: [
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 409, 0, 0),
          //   child: SvgPicture.asset('assets/tree.svg'),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Center(child: SvgPicture.asset('assets/logo.svg')),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 233, 0, 0),
            child: Container(
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => setState(() {
                        email = val;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) {
                        return val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null;
                      },
                      obscureText: true,
                      onChanged: (val) => setState(() {
                        password = val;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 395, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Register',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: ORANGE_1,
                    ),
                    onPressed: () {
                      widget.toggleView();
                    }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      child: Text('Sign in',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: ORANGE_1,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Incorrect Email/Password!';
                            });
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
          // Toggle Register Page
          // TextButton.icon(
          //   icon: Icon(Icons.person),
          //   label: Text('Register'),
          //   onPressed: () { widget.toggleView(); },
          // ),
        ],
      ),
      SvgPicture.asset('assets/tree.svg'),
    ];

    return loading
        ? Loading()
        : Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset('assets/background.svg',
                  fit: BoxFit.cover, clipBehavior: Clip.hardEdge),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: loginWidget,
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
              ),
            ],
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
