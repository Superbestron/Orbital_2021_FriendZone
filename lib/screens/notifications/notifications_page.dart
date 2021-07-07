import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
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
  List<dynamic> notificationIDs = [];

  // Only get user's notifications
  void getNotifications(UserObj user) async {
    UserData userData = await DatabaseService.getUserData(user.uid);
    notificationIDs = userData.notifications;
  }

  @override
  Widget build(BuildContext context) {

    UserObj? user = Provider.of<UserObj?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);
    getNotifications(user);

    Iterable<Event> allEvents = (Provider.of<List<Event>?>(context) ?? []);
    Iterable<Event> events = allEvents.where((event) => event.attendees.contains(user.uid));

    List<Event> createdEvents = events
        .where((event) => event.attendees[0] == user.uid)
        .toList();

    List<Event> upcomingEvents = events
        .where((event) => event.dateTime.isAfter(DateTime.now()))
        .toList();

    // Filter the events which have already happened
    List<Event> pastEvents = events
        .where((event) => event.dateTime.isBefore(DateTime.now()))
        .toList().reversed.toList(); // Earlier events are shown later


    // Make sure callback function runs only once but after build()
    // has been called once
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Delete old events
      List<Event> pastEventsToBeDeleted = allEvents
          .where((event) => event.dateTime.isBefore(DateTime.now()))
          .toList().reversed.toList();
      DatabaseService.deleteOldEvents(pastEventsToBeDeleted);

      // Delete old notifications
      DatabaseService.deleteNotifications(notificationIDs);
    });

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          // Notifications
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notificationIDs.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notificationIDs[index]),
                onDismissed: (direction) async {
                  // ONLY for notifications of type 'friend_notification'
                  await DatabaseService.makeNotificationExpire(notificationIDs[index], true);
                  setState(() {
                    notificationIDs.removeAt(index);
                  });
                  await db.updateNotification(notificationIDs);
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
                          await db.updateNotification(notificationIDs);
                          await DatabaseService.makeNotificationExpire(notificationIDs[index], false);
                          // Here it's just to re-render the page
                          setState(() {
                            notificationIDs = notificationIDs;
                          });
                        },
                      ),
                    )
                  );
                },
                child: NotificationTile(notificationID: notificationIDs[index], uid: user.uid),
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

          // My Created Events
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'My Created Events',
                      style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: createdEvents.length,
            itemBuilder: (context, index) {
              return EventTile(event: createdEvents[index], isNotiPage: true);
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
                        text: 'Upcoming Events',
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
                        text: 'Past Events',
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


