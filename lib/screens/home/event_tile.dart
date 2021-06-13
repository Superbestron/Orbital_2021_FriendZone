import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/edit_event/edit_event.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';

class EventTile extends StatelessWidget {
  final Event event;

  EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
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
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        leading: Icon(Icons.calendar_today, size: 15),
                        title: Text(getDateText(event.dateTime),
                            style: TextStyle(fontSize: 15)),
                        minLeadingWidth: 10.0,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        leading: Icon(Icons.access_time, size: 15),
                        title: Text('${getTimeText(event.dateTime)}',
                            style: TextStyle(fontSize: 15)),
                        minLeadingWidth: 10.0,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        leading: Icon(Icons.group_rounded, size: 15),
                        title: Text('${event.attendees.length} / ${event.pax}',
                            style: TextStyle(fontSize: 15)),
                        minLeadingWidth: 10.0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      imageList[event.icon],
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
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/background.svg',
                          fit: BoxFit.cover,
                        ),
                        Scaffold(
                          // AppBar that is shown on event_page
                          appBar: AppBar(
                            leading: BackButton(color: Colors.black),
                            title: Text(
                              "Event Details",
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 15, 0),
                                child: imageList[event.icon],
                              ),
                            ],
                            toolbarHeight: 75.0,
                          ),
                          body: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 60.0),
                                child: EventPage(eventID: event.eventID),
                              ),
                              user!.uid == event.initiatorID ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: FloatingActionButton(
                                            backgroundColor: ORANGE_1,
                                            tooltip: 'Edit Event',
                                            child: Icon(Icons.edit_rounded),
                                            onPressed: () {
                                              int daysToEvent = event.dateTime
                                                  .difference(DateTime.now())
                                                  .inDays;
                                              if (daysToEvent > 2) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => (EditEvent(event: event))),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: BACKGROUND_COLOR,
                                                      content: Text('It is too late to edit event now!'),
                                                      action: SnackBarAction(
                                                        label: 'Dismiss',
                                                        onPressed: () async {

                                                        },
                                                      ),
                                                    )
                                                );
                                              }
                                            }
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ) : Text(""), // empty widget
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
