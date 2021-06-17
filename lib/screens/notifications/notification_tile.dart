import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/edit_event/edit_event.dart';
import 'package:myapp/screens/event/event_page.dart';
import 'package:myapp/services/database.dart';
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
                  builder: (context) => EventPage(event: event),
                )),
            ),
          ),
        )
      : TransparentLoading())
    : TransparentLoading();
  }
}
