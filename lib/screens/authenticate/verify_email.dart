import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/shared/constants.dart';

class VerifyEmail extends StatefulWidget {

  final AuthService auth;

  VerifyEmail({ required this.auth });

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  bool buttonTappable = false;
  static const int TIME_BETWEEN_EMAILS = 30;
  Timer? _timer;
  int _start = TIME_BETWEEN_EMAILS;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            setButtonTappable();
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    buttonTappable = true;
    super.initState();
  }

  void setButtonTappable() {
    setState(() {
      buttonTappable = true;
      _start = TIME_BETWEEN_EMAILS;
    });
  }

  void setButtonNotTappable() {
    setState(() {
      buttonTappable = false;
    });
  }


  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      fit: StackFit.expand,
      children: <Widget> [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
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
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: TextButton.icon(
                    icon: Icon(Icons.person, color: Colors.black),
                    label: Text('Sign In', style: TextStyle(color: Colors.black)),
                    onPressed: () async { await widget.auth.signOut(); }
                ),
              ),
            ],
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Please verify your NUS email!',
                  style: TEXT_FIELD_HEADING),
              ),
              Align(
                alignment: Alignment.center,
                child: buttonTappable
                ? ElevatedButton(
                  onPressed: () async {
                    await widget.auth.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: BACKGROUND_COLOR,
                      content: Text('Email sent to ${widget.auth.getUserEmail()}'),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {},
                      ),
                      duration: Duration(seconds: 5)
                    ));
                    setButtonNotTappable();
                    startTimer();
                  },
                  child: Text('Send Verification Email')
                )
                : ElevatedButton(
                  onPressed: () {},
                  child: Text('Please wait $_start seconds...'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  )
                ),
              ),
              const SizedBox(height: 100),
              SvgPicture.asset('assets/tree.svg',
                  // fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge),
            ]
          ),
        ),
      ],
    );
  }
}
