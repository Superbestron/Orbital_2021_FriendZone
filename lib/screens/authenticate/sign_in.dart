import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final AuthService _auth = AuthService(auth: FirebaseAuth.instance);
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  String resetPasswordEmail = '';

  @override
  Widget build(BuildContext context) {
    var loginWidget = <Widget> [
      Column(
        children: [
          Center(child: SvgPicture.asset('assets/logo.svg')),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration:
            textInputDecoration.copyWith(
              hintText: 'NUS Email',
              prefixIcon: Icon(Icons.mail),
            ),
            validator: (val) =>
            val!.isEmpty ? 'Enter a NUS email' : null,
            onChanged: (val) => setState(() {
              email = val;
            }),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration:
            textInputDecoration.copyWith(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
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
          SizedBox(height: 20.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text('Forgot your password?', style: NORMAL),
                const SizedBox(width: 15),
                GestureDetector(
                    child: Text('Reset', style: BOLDED_NORMAL.copyWith(
                        color: ORANGE_1
                    )),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Reset Password"),
                          // content: Text(
                          //     'Are you sure you want to sign out?'),
                          content: SizedBox(
                            child: Column(
                              children: [
                                Text('If the provided email was valid, a password reset email will be sent to the specified email.'),
                                const SizedBox(height: 20),
                                TextFormField(
                                  decoration:
                                  textInputDecoration.copyWith(
                                    hintText: 'NUS Email',
                                    prefixIcon: Icon(Icons.mail),
                                  ),
                                  validator: (val) =>
                                  val!.isEmpty ? 'Enter a NUS email' : null,
                                  onChanged: (val) => setState(() {
                                    resetPasswordEmail = val;
                                  }),
                                ),
                              ],
                            ),
                            height: 150
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel",
                                  style: TextStyle(
                                    color: Colors.red,
                                  )),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _auth.resetPassword(resetPasswordEmail);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: BACKGROUND_COLOR,
                                  content: Text('Email sent to $resetPasswordEmail'),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () {},
                                  ),
                                ));
                                Navigator.of(context).pop();
                              },
                              child: Text("Confirm"),
                            ),
                          ],
                        ),
                      );

                    }
                )
              ]
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              child: Text('Sign In', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth
                      .signInWithEmailAndPassword(email, password);
                  print(result);
                  if (result != '') {
                    setState(() {
                      loading = false;
                      error = result;
                    });
                  }
                }
              }),
          ),
          error != ''
            ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(error,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            )
            : const SizedBox(height: 12),
          error != ''
            // to ensure text remains at same height when error text shows
            ? const SizedBox(height: 90 - (2 * 12 + 16))
            : const SizedBox(height: 90),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text('Don\'t have an account?', style: NORMAL),
              const SizedBox(width: 15),
              GestureDetector(
                child: Text('Register', style: BOLDED_NORMAL.copyWith(
                  color: ORANGE_1
                )),
                onTap: () { widget.toggleView(); }
              )
            ]
          )
        ],
      ),
      const SizedBox(height: 20),
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
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('FriendZone',
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 30,
                          )
                      )
                  ),
                  toolbarHeight: 100.0,
                  elevation: 0.0,
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
