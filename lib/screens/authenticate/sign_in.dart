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
      Column(
        children: [
          Center(child: SvgPicture.asset('assets/logo.svg')),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration:
            textInputDecoration.copyWith(
              hintText: 'Email',
              prefixIcon: Icon(Icons.mail),
            ),
            validator: (val) =>
            val!.isEmpty ? 'Enter an email' : null,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
                child: Text('Sign In',
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
          SizedBox(height: 12.0),
          Text(error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text('Don\'t have an account?', style: NORMAL),
              const SizedBox(width: 15),
              GestureDetector(
                child: Text('Register', style: BOLDED_NORMAL),
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
