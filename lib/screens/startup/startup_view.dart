import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:myapp/shared/constants.dart';

class StartupView extends StatefulWidget {
  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    // set time to load the new page
    Future.delayed(
      Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper())
        );
      }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: SvgPicture.asset('assets/logo.svg')),
                const SizedBox(height: 40),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'FriendZone',
                      textStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      speed: const Duration(milliseconds: 500),
                      colors: <Color> [
                        Colors.blue,
                        Colors.yellow,
                        ORANGE_1,
                        Colors.red,
                      ]
                    ),
                  ],
                ),
                SizedBox(
                  child: Lottie.asset('assets/lottie/startup.json'),
                  width: 300
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}
