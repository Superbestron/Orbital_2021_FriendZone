import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_page.dart';
import 'package:myapp/shared/clock.dart';
import 'package:myapp/shared/constants.dart';

class UpcomingEventTile extends StatelessWidget {

  final Event event;
  UpcomingEventTile({ required this.event });

  // Probably can color the card red/amber to inform users
  // that their event has been cancelled/edited when they
  // click the notifications page
  // static const Color CANCELLED = Colors.red;
  // static Color? EDITED = Colors.amber[800];

  @override
  Widget build(BuildContext context) {
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
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      leading: Icon(Icons.calendar_today, size: 15),
                      title: Text(getDateText(event.dateTime), style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      leading: Icon(Icons.access_time, size: 15),
                      title: Text('${getTimeText(event.dateTime)}', style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      leading: Icon(Icons.group_rounded, size: 15),
                      title: Text('${event.attendees.length} / ${event.pax}', style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget> [
                    imageList[event.icon],
                    Clock(dateTime: event.dateTime).build(context),
                  ],
                ),
              ),
            ],
          ),

          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stack(
                  fit: StackFit.expand,
                  children: <Widget> [
                    SvgPicture.asset(
                      'assets/background.svg',
                      fit: BoxFit.cover,
                    ),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      // AppBar that is shown on event_page
                      appBar: AppBar(
                        leading: BackButton(color: Colors.black),
                        title: Text(
                          "Event Details",
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget> [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                            child: imageList[event.icon],
                          ),
                        ],
                        toolbarHeight: 75.0,
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                      ),
                      body: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                        child: EventPage(eventID: event.eventID),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}