import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/shared/constants.dart';

class EventTile extends StatelessWidget {

  final Event event;
  EventTile({ required this.event });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: CARD_BACKGROUND,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[50],
            // backgroundImage: AssetImage('assets/...png'),
          ),
          title: Text(event.name),
          subtitle: Text('Takes sugar(s)'),
        ),
      ),
    );
  }
}
