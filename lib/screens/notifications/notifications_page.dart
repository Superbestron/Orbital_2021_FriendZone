import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/home/event_tile.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';

import 'notification_tile.dart';

class NotificationsWidget extends StatefulWidget {

  final Function jumpToPage;

  const NotificationsWidget({
    required this.jumpToPage
  });

  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  List<dynamic> notifications = [];

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getNotifications();
  // }

  // Only get user's notifications
  void getNotifications(DatabaseService db, UserObj user) async {
    UserData userData = await db.getUserData(user.uid);
    notifications = userData.notifications;
  }

  @override
  Widget build(BuildContext context) {

    UserObj? user = Provider.of<UserObj?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);
    getNotifications(db, user);

    Iterable<Event> events = (Provider.of<List<Event>?>(context) ?? [])
        .where((event) => event.attendees.contains(user.uid));

    List<Event> upcomingEvents = events
        .where((event) => event.dateTime.isAfter(DateTime.now()))
        .toList();

    // Filter the events which have already happened
    List<Event> pastEvents = events
        .where((event) => event.dateTime.isBefore(DateTime.now()))
        .toList();

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[

          // Notifications
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
              return Dismissible(
                  key: Key(notifications[index]),
                  onDismissed: (direction) async {
                    setState(() {
                      notifications.removeAt(index);
                    });
                    await db.updateNotification(notifications);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: BACKGROUND_COLOR,
                        content: Text('Successfully deleted notification!'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            // I have no idea why notifications doesn't get
                            // removed here so I don't have to add back the
                            // removed notification
                            await db.updateNotification(notifications);
                            // Here it's just to re-render the page
                            setState(() {
                              notifications = notifications;
                            });
                          },
                        ),
                      )
                    );
                  },
                  child: NotificationTile(notificationID: notifications[index], uid: user.uid,),
              );
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

          // Upcoming Events
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
              return EventTile(event: upcomingEvents[index], isNotiPage: true);
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

          // Past Events
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
              return EventTile(event: pastEvents[index], isNotiPage: true);
            },
          ),
        ],
      ),
    );
  }
}


