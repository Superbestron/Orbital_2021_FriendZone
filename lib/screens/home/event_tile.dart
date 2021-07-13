import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/shared/clock.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/widgets.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final bool isNotiPage;

  EventTile({
    required this.event,
    this.isNotiPage = false
  });

  @override
  Widget build(BuildContext context) {
    print(event.icon);
    print(event.attendees);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: CARD_BACKGROUND,
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          minLeadingWidth: 10,
          dense: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            child: Text(event.name, style: TextStyle(fontSize: 18)),
          ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    buildEventDetailsListTile(event,
                      Icon(Icons.calendar_today, size: 15),
                      Text('${getDateText(event.dateTime)}', style: NORMAL)
                    ),
                    buildEventDetailsListTile(event,
                      Icon(Icons.access_time, size: 15),
                      Text('${getTimeText(event.dateTime)}', style: NORMAL)
                    ),
                    buildEventDetailsListTile(event,
                      Icon(Icons.group_rounded, size: 15),
                      Text('${event.attendees.length} / ${event.pax}', style: NORMAL)
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    IMAGE_LIST[event.icon],
                    if (isNotiPage)
                      Clock(dateTime: event.dateTime).build(context)
                  ],
                ),
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(event: event),
            ),
          )),
      ),
    );
  }
}
