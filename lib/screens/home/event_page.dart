import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';

class EventPage extends StatefulWidget {
  final String eventID;

  EventPage({ required this.eventID });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool hasConfirmedAttendance(Event event, String uid) {
    return event.attendees.contains(uid);
  }

  String error = "";

  @override
  Widget build(BuildContext context) {
    // Still need this to listen for user's uid
    final user = Provider.of<UserObj?>(context);
    var dbService = DatabaseService(uid: user!.uid);

    return StreamBuilder<Event>(
        // Get the event based on uid for now
        // TODO: Change this logic
        stream: dbService.getEvent(widget.eventID),
        // temp function to append empty attendee
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Event event = snapshot.data!;
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Text(
                          event.name,
                          style: TEXT_FIELD_HEADING,
                        ),
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.calendar_today, size: 15),
                      title: Text('${getDateText(event.dateTime)}',
                          style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.access_time, size: 15),
                      title: Text('${getTimeText(event.dateTime)}',
                          style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Icon(Icons.group_rounded, size: 15),
                      title: Text('${event.attendees.length} / ${event.pax}',
                          style: TextStyle(fontSize: 15)),
                      minLeadingWidth: 10.0,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      // Right now I'm just gonna hard code this thing.
                      title: Text('Initiated by Tze Henn',
                          style: NORMAL),
                      minLeadingWidth: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: ORANGE_1,
                                  padding: EdgeInsets.all(2.0),
                                ),
                                onPressed: () {}, // Link to Telegram
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  leading: Icon(Icons.message, size: 15.0),
                                  minLeadingWidth: 5.0,
                                  title: Transform(
                                    transform: Matrix4.translationValues(-10, 0.0, 0.0),
                                    child: Text(
                                      'Join Telegram',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: hasConfirmedAttendance(event, user.uid)
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: revokeAttendance,
                                        padding: EdgeInsets.all(2.0),
                                      ),
                                      onPressed: () async {
                                        int daysToEvent = event.dateTime
                                            .difference(DateTime.now())
                                            .inDays;
                                        // print(daysToEvent);
                                        if (daysToEvent > 2) {
                                          await dbService.removeUserFromEvent(
                                              widget.eventID, user.uid);
                                        } else {
                                          setState(() {
                                            error =
                                                "It is too late to withdraw!";
                                          });
                                        }
                                      }, // Confirm to join event
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                        leading: Icon(Icons.check, size: 15.0),
                                        minLeadingWidth: 0,
                                        title: Transform(
                                          transform: Matrix4.translationValues(-10, 0.0, 0.0),
                                          child: Text('Revoke Attendance',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                    )
                                  : event.attendees.length < event.pax
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: ORANGE_1,
                                            padding: EdgeInsets.all(2.0),
                                          ),
                                          onPressed: () async {
                                            if (event.attendees.length <
                                                event.pax) {
                                              await dbService.addUserToEvent(
                                                  widget.eventID, user.uid);
                                            }
                                          }, // Confirm to join event
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                            leading:
                                                Icon(Icons.check, size: 15.0),
                                            minLeadingWidth: 0,
                                            title: Transform(
                                              transform: Matrix4.translationValues(-10, 0.0, 0.0),
                                              child: Text('Confirm Attendance',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12)),
                                            ),
                                          ))
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: ORANGE_1,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              error =
                                                  "Event full! Try other events.";
                                            });
                                          },
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(0.0),
                                            leading:
                                                Icon(Icons.check, size: 15.0),
                                            minLeadingWidth: 5.0,
                                            title: Text('Event is full!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 12)),
                                          ))),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(124, 0, 0, 0),
                      child: SizedBox(
                        child: Text(error,
                          textAlign: TextAlign.center,
                          style:
                            TextStyle(color: Colors.red, fontSize: 14.0)),
                      )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Description',
                            style: TEXT_FIELD_HEADING,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            event.description,
                            style: NORMAL,
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          } else {
            return TransparentLoading();
          }
        });
  }
}
