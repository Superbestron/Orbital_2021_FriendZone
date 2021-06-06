import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Stack(fit: StackFit.expand, children: [
            SvgPicture.asset('assets/background.svg',
                fit: BoxFit.cover, clipBehavior: Clip.hardEdge),
            Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 50.0),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                  "Create an account!",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) {
                                return val!.isEmpty ? 'Enter an email' : null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Password'),
                              validator: (val) {
                                return val!.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null;
                              },
                              obscureText: true,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      child: Text('Back to Sign in',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        widget.toggleView();
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      child: Text('Register',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _auth
                                              .registerWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              loading = false;
                                              error =
                                                  'please supply a valid email';
                                            });
                                          }
                                          print(password);
                                        }
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        )))),
          ]);
  }
}
