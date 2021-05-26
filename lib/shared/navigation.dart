import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: GREEN_1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.home, size: 30),
            ),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
          ),
          Padding(
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.calendar_today, size: 25),
            ),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
          ),
          Padding(
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.add, size: 30),
            ),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
          ),
          Padding(
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications, size: 30),
            ),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
          ),
          Padding(
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.person, size: 30,),
            ),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
          ),
        ],
      ),
    );
  }
}
