import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String _initiator = "";
  String _error = "";
  String _initiatorID = '';

  @override
  Widget build(BuildContext context) {
    // Still need this to listen for user's uid
    final user = Provider.of<UserObj?>(context);
    var dbService = DatabaseService(uid: user!.uid);

    return StreamBuilder<Event>(
      // Get the event based on uid for now
      stream: dbService.getEvent(widget.eventID),
      // temp function to append empty attendee
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Event event = snapshot.data!;
          void setInitiatorName() async {
            _initiatorID = event.attendees[0];
            String name = await dbService.getNameFromUserID(_initiatorID);
            setState(() {
              _initiator = name;
            });
          }
          setInitiatorName();
          return ListView(
              physics: BouncingScrollPhysics(),
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
                    style: NORMAL),
                  minLeadingWidth: 10.0,
                ),
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Icon(Icons.access_time, size: 15),
                  title: Text('${getTimeText(event.dateTime)}',
                    style: NORMAL),
                  minLeadingWidth: 10.0,
                ),
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Icon(Icons.group_rounded, size: 15),
                  title: Text('${event.attendees.length} / ${event.pax}',
                    style: NORMAL),
                  minLeadingWidth: 10.0,
                ),
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Icon(Icons.location_on, size: 15),
                  title: Text(event.location,
                    style: NORMAL),
                  minLeadingWidth: 10.0,
                ),
                ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Icon(Icons.person_pin_circle_rounded, size: 15),
                  title: Text(_initiator,
                    style: NORMAL),
                  minLeadingWidth: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ORANGE_1,
                            padding: EdgeInsets.all(2.0),
                          ),
                          onPressed: () async {
                            await launch(event.telegramURL);
                          }, // Link to Telegram
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
                        padding: const EdgeInsets.all(6.0),
                        child: hasConfirmedAttendance(event, user.uid)
                        // If User has confirmed attendance
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
                                if (user.uid == event.attendees[0]) {
                                  setState(() {
                                    _error = 'You are the event host!';
                                  });
                                } else if (daysToEvent < 2) {
                                  setState(() {
                                    _error =
                                    'It is too late to withdraw!';
                                  });
                                } else { // User can revoke attendance
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Revoke Attendance"),
                                      content: Text(
                                        'Are you sure you want to revoke your attendance?'
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            await dbService.removeUserFromEvent(
                                                widget.eventID, user.uid);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel",
                                            style: TextStyle(
                                              color: Colors.red,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Cannot Revoke Attendance"),
                                    content: Text(_error),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  ),
                                );
                              }, // Confirm to join event
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                leading: Icon(Icons.check, size: 20.0),
                                minLeadingWidth: 0,
                                title: Transform(
                                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                                  child: Text('Revoke Attendance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            )
                          // If User has not confirmed attendance
                          : event.attendees.length < event.pax
                              // If there's still space to join
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: ORANGE_1,
                                    padding: EdgeInsets.all(2.0),
                                  ),
                                  onPressed: () async {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirm Attendance'),
                                        content: Text(
                                          'Are you sure you want to confirm attendance?\n\n'
                                          'Note: You cannot revoke your attendance '
                                          'if the event is less than 2 days away from now.'
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                )
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await dbService.addUserToEvent(
                                                  widget.eventID, user.uid);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Confirm"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }, // Confirm to join event
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                                    leading: Icon(Icons.check, size: 20.0),
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
                                    primary: Colors.grey,
                                    padding: EdgeInsets.all(2.0),
                                  ),
                                  onPressed: () async {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Cannot Confirm Attendance'),
                                        content: Text('Event is full! Try other events.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Confirm"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    leading: Icon(Icons.report_gmailerrorred, size: 20.0),
                                    minLeadingWidth: 5.0,
                                    title: Transform(
                                      transform: Matrix4.translationValues(-10, 0.0, 0.0),
                                      child: Text(
                                        'Event Full',
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ))),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Event Description', style: TEXT_FIELD_HEADING),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.notes),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 100,
                            minWidth: 500,
                          ),
                          child: Text(event.description),
                        ),
                        decoration: boxDecoration,
                        padding: const EdgeInsets.all(15.0),
                      )
                    ],
                  ),
                ),
              ],
            );
        } else {
          return TransparentLoading();
        }
      });
  }
}
