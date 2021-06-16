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

class AttendeeTile extends StatefulWidget {
  final String attendeeID;

  AttendeeTile({required this.attendeeID});

  @override
  _AttendeeTileState createState() => _AttendeeTileState();
}

class _AttendeeTileState extends State<AttendeeTile> {

  bool initialised = false;
  late UserData attendee;

  void getAttendee() async {

    attendee = await DatabaseService(uid: widget.attendeeID)
        .getUserData(widget.attendeeID);
    setState(() {
      initialised = true;
    });
  }

  @override
  void initState() {
    getAttendee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initialised
    ? Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 0.0),
        color: CARD_BACKGROUND,
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          minLeadingWidth: 10,
          dense: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            child: Text(attendee.name,
                style: TextStyle(fontSize: 18)),
          ),
          subtitle: Text(attendee.faculty,
              style: TextStyle(fontSize: 18)),
          onTap: () => {}
        ),
      ),
    ) : TransparentLoading();
  }
}
