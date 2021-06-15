import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/notifications/upcoming_event_tile.dart';
import 'package:myapp/services/database.dart';
import 'package:provider/provider.dart';

import 'notification_tile.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  List<dynamic> notifications = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getNotifications();
  }

  void getNotifications() async {
    UserObj? user = Provider.of<UserObj?>(context);
    UserData userData =
        await DatabaseService(uid: user!.uid).getUserData(user.uid);
    notifications = userData.notifications;
  }

  @override
  Widget build(BuildContext context) {
    UserObj? user = Provider.of<UserObj?>(context);
    Iterable<Event> events = (Provider.of<List<Event>?>(context) ?? [])
        .where((event) => event.attendees.contains(user!.uid));
    // Filter the events which have already happened
    List<Event> upcomingEvents = events
        .where((event) => event.dateTime.isAfter(DateTime.now()))
        .toList();

    List<Event> pastEvents = events
        .where((event) => event.dateTime.isBefore(DateTime.now()))
        .toList();

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Notifications',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationTile(notificationID: notifications[index]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Upcoming',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              return UpcomingEventTile(event: upcomingEvents[index]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Past',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pastEvents.length,
            itemBuilder: (context, index) {
              return UpcomingEventTile(event: pastEvents[index]);
            },
          ),
        ],
      ),
    );
  }
}
