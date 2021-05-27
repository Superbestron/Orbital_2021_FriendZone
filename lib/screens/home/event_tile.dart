import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/shared/constants.dart';

class EventTile extends StatelessWidget {

  final Event event;
  EventTile({ required this.event });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: CARD_BACKGROUND,
        margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child: Text(
                event.name,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 0, 5),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0.0, 0, 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          minLeadingWidth: 10,
                          dense: true,
                          leading: Icon(Icons.calendar_today, size: 15),
                          title: Text(
                            event.date,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          minLeadingWidth: 10,
                          dense: true,
                          leading: Icon(Icons.access_time, size: 15),
                          title: Text(
                            event.time,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                        ),
                        ListTile(
                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                          minLeadingWidth: 10,
                          dense: true,
                          leading: Icon(Icons.group_rounded, size: 15),
                          title: Text(
                            event.pax.toString(),
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/event_icons/food.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
