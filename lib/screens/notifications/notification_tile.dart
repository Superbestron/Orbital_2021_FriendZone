import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/edit_event/edit_event.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/clock.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:provider/provider.dart';

class NotificationTile extends StatefulWidget {
  final String uid;
  final String notificationID;

  NotificationTile({required this.notificationID, required this.uid});

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool initialised = false;
  late NotificationObj notification;
  late Event event;

  void getNotification() async {
    notification = await DatabaseService(uid: widget.uid)
        .getNotificationObj(widget.notificationID);
    if (notification.type == "event_change") {
      String eventID = notification.additionalInfo['eventID'];
      event = await DatabaseService(uid: widget.uid).getEventData(eventID);
    }
    setState(() {
      initialised = true;
    });
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    return initialised
        ? (notification.type == "event_change"
            ? Padding(
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
                      child: Text(notification.title,
                          style: TextStyle(fontSize: 18)),
                    ),
                    subtitle: Text(notification.subtitle,
                        style: TextStyle(fontSize: 18)),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/background.svg',
                                fit: BoxFit.cover,
                                clipBehavior: Clip.hardEdge,
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
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 15, 15, 0),
                                        child: IMAGE_LIST[event.icon],
                                      ),
                                    ],
                                    toolbarHeight: 75.0,
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  body: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 60.0),
                                        child:
                                            EventPage(eventID: event.eventID),
                                      ),
                                      user!.uid == event.attendees[0]
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 28, 30),
                                                      child:
                                                          FloatingActionButton(
                                                              backgroundColor:
                                                                  ORANGE_1,
                                                              tooltip:
                                                                  'Edit Event',
                                                              child: Icon(Icons
                                                                  .edit_rounded),
                                                              onPressed: () {
                                                                int daysToEvent = event
                                                                    .dateTime
                                                                    .difference(
                                                                        DateTime
                                                                            .now())
                                                                    .inDays;
                                                                if (daysToEvent >
                                                                    2) {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                (EditEvent(event: event))),
                                                                  );
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    backgroundColor:
                                                                        BACKGROUND_COLOR,
                                                                    content: Text(
                                                                        'It is too late to edit event now!'),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          'Dismiss',
                                                                      onPressed:
                                                                          () async {},
                                                                    ),
                                                                  ));
                                                                }
                                                              }),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          : Text(""), // empty widget
                                    ],
                                  )),
                            ],
                          ),
                        )),
                  ),
                ),
              )
            : TransparentLoading())
        : TransparentLoading();
  }
}
