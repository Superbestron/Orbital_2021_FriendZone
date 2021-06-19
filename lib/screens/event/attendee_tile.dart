import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/profile/profile_page.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/loading_transparent.dart';
import 'package:myapp/shared/widgets.dart';
import 'package:provider/provider.dart';

class AttendeeTile extends StatefulWidget {
  final UserData attendee;

  AttendeeTile({required this.attendee});

  @override
  _AttendeeTileState createState() => _AttendeeTileState();
}

class _AttendeeTileState extends State<AttendeeTile> {
  bool initialised = false;
  late ImageProvider _profileImage;

  void getAttendee() async {
    DatabaseService dbService = DatabaseService(uid: widget.attendee.uid);
    if (mounted) {
      await dbService
          .getImageURLFromFirebase(widget.attendee.profileImagePath)
          .then((url) =>
          setState(() {
            _profileImage = NetworkImage(url);
          }));
      setState(() {
        initialised = true;
      });
    }
  }

  @override
  void initState() {
    getAttendee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    String uid = user!.uid;
    return initialised
      ? Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: CARD_BACKGROUND,
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          minLeadingWidth: 10,
          // dense: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.attendee.name, style: TEXT_FIELD_HEADING),
          ),
          subtitle: Text('Level ${widget.attendee.level}', style: NORMAL),
          trailing: CircleAvatar(
            backgroundImage: ResizeImage(_profileImage, width: 20),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                Stack(fit: StackFit.expand, children: <Widget>[
                  buildBackgroundImage(),
                  Scaffold(
                    // AppBar that is shown on event_page
                    appBar: buildAppBar('User\'s Profile'),
                    body: ProfilePage(profileID: widget.attendee.uid == uid ? "" : widget.attendee.uid))
              ]),
            ),
          ),
        ),
      )
    : TransparentLoading();
  }
}
