import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
          ),
          Container(
            color: Colors.transparent,
            child: Center(
              child: SpinKitChasingDots(
                color: GREEN_1,
                size: 50.0,
              )
            )
          )
        ]
    );
  }
}
