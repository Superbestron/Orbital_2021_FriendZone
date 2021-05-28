import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/shared/constants.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  final List<String> sugars = ['0', '1', '2', '3', '4'];
  // final _formKey = GlobalKey<FormState>();

  // form values
  String? _currentName;
  String? _currentDate;
  String? _currentTime;
  int? _pax;
  String? _currentDescription;
  int? _icon;

  @override
  Widget build(BuildContext context) {

    // Still need this to listen for user's uid
    final user = Provider.of<UserObj?>(context);

    return StreamBuilder<EventData>(
        stream: DatabaseService(uid: user!.uid).activityData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            EventData activityData = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: <Widget> [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    leading: Icon(Icons.calendar_today, size: 15),
                    title: Text('${activityData.date}', style: TextStyle(fontSize: 15)),
                    minLeadingWidth: 10.0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    leading: Icon(Icons.access_time, size: 15),
                    title: Text('${activityData.time}', style: TextStyle(fontSize: 15)),
                    minLeadingWidth: 10.0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    leading: Icon(Icons.group_rounded, size: 15),
                    title: Text('${activityData.pax}', style: TextStyle(fontSize: 15)),
                    minLeadingWidth: 10.0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    // Right now I'm just gonna hard code this thing.
                    title: Text('Initiated by Tze Henn', style: TextStyle(fontSize: 15)),
                    minLeadingWidth: 10.0,
                  ),
                  Row(
                    children: <Widget> [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.brown[200],
                            ),
                            onPressed: (){}, // Link to Telegram
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(),
                              leading: Icon(Icons.message, size: 15.0),
                              minLeadingWidth: 5.0,
                              title: Text('Join Telegram', style: TextStyle(fontSize: 12)),
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.brown[200],
                              ),
                            onPressed: (){}, // Confirm to join event
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(),
                                leading: Icon(Icons.message, size: 15.0),
                                minLeadingWidth: 5.0,
                                title: Text('Confirm Attendance', style: TextStyle(fontSize: 12)),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    child: Text(activityData.description),
                  )
                ],
              )
            );
          } else {
            return Loading();
          }
        }
    );
  }
}
