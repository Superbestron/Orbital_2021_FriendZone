import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/screens/profile/profile_page.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:myapp/shared/widgets.dart';

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
  Event? event;

  String getEventType(int index) {
    return EVENT_TYPES.keys.elementAt(index);
  }

  void getNotification() async {
    notification = await DatabaseService(uid: widget.uid)
        .getNotificationObj(widget.notificationID);
    if (notification.type == getEventType(0)) {
      String eventID = notification.additionalInfo['eventID'];
      event = await DatabaseService(uid: widget.uid).getEventData(eventID);
    }
    if (mounted) {
      setState(() {
        initialised = true;
      });
    }
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserObj?>(context);
    if (initialised) {
      if (notification.type == getEventType(0)) {
        return NotiListTile(notification: notification,
          icon: Icon(Icons.warning),
          route: () => MaterialPageRoute(
          builder: (context) => EventPage(event: event!))
        );
      } else if (notification.type == getEventType(1)) {
        // If Event is deleted
        return Container();
      } else if (notification.type == getEventType(2)) {
          return NotiListTile(notification: notification,
            icon: Icon(Icons.check),
            route: () => MaterialPageRoute(
              builder: (context) => Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  buildBackgroundImage(),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    // AppBar that is shown on event_page
                    appBar: buildAppBar('User\'s Profile'),
                    body: ProfilePage(profileID: notification.additionalInfo['profileID']),
                  )
                ],
              ),
            ),
          );
      } else {
        return TransparentLoading();
      }
    } else {
      return TransparentLoading();
    }
  }
}

class NotiListTile extends StatelessWidget {
  const NotiListTile({
    Key? key,
    required this.notification,
    required this.icon,
    required this.route,
  }) : super(key: key);

  final NotificationObj notification;
  final Icon icon;
  final Function route;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          color: EVENT_TYPES[notification.type],
          child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            minLeadingWidth: 10,
            dense: true,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: Text(notification.title,
                  style: TEXT_FIELD_HEADING),
            ),
            subtitle: Text(notification.subtitle,
                style: NORMAL),
            trailing: icon,
            onTap: () => Navigator.push(
              context,
              route()),
          ),
        ),
    );
  }
}
