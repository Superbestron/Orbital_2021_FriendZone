import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService(auth: FirebaseAuth.instance);
  final _formKey = GlobalKey<FormState>();
  // final nameController = TextEditingController();
  // final textController = TextEditingController();
  // final passwordController = TextEditingController();
  // final verifyPasswordController = TextEditingController();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String fullName = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
      ? Loading()
      : Stack(fit: StackFit.expand, children: [
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
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text("Create an account!",
                      style: BOLDED_HEADING
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      // controller: nameController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.close),
                        //   onPressed: () => nameController.clear()
                        // )
                      ),
                      validator: (val) {
                        return val!.isEmpty ? 'Enter your name' : null;
                      },
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'NUS Email',
                        prefixIcon: Icon(Icons.mail),
                      ),
                      validator: (val) {
                        return val!.isEmpty
                          ? 'Enter a NUS email'
                          : val.endsWith('@u.nus.edu')
                            ? null
                            : 'Please enter a valid NUS email';
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
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
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
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (val) {
                        return val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : password != val
                              ? 'Passwords don\'t match'
                              : null;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
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
                                      email, password, fullName);
                              if (result != '') {
                                setState(() {
                                  loading = false;
                                  error = result;
                                });
                              }
                            }
                          }),
                    ),
                  ],
                )),
              error != ''
                ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(error,
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ),
                )
                : const SizedBox(height: 12),
              error != ''
              // to ensure text remains at same height when error text shows
                  ? const SizedBox(height: 130 - (2 * 12 + 16))
                  : const SizedBox(height: 130),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text('Have an account?', style: NORMAL),
                    const SizedBox(width: 15),
                    GestureDetector(
                        child: Text('Sign In', style: BOLDED_NORMAL.copyWith(
                            color: ORANGE_1
                        )),
                        onTap: () { widget.toggleView(); }
                    )
                  ]
              ),
              const SizedBox(height: 20),
              SvgPicture.asset('assets/tree.svg'),
            ]
      )),
    ]);
  }
}
