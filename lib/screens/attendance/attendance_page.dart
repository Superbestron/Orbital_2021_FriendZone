import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/widgets.dart';
import 'package:provider/provider.dart';

import 'attendance_tile.dart';

class AttendancePage extends StatefulWidget {
  final List attendees;

  AttendancePage({required this.attendees});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool submit = false;
  UserData mock = UserData(
      friendRequests: [],
      notifications: [],
      profileImagePath: '',
      name: '',
      friends: [],
      points: 0,
      bio: '',
      uid: '',
      events: [],
      level: 0,
      faculty: ''
  );
  @override
  Widget build(BuildContext context) {
    List attendees = widget.attendees;
    return StreamProvider<List<UserData>?>.value(
        initialData: List<UserData>.generate(attendees.length, (i) => mock), // prevents null ptr
        value: DatabaseService.users.map((users) =>
            (users.where((user) => attendees.contains(user.uid)).toList())),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          buildBackgroundImage(),
          Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: BackButton(color: Colors.black),
                title: Text(
                  "Mark attendance",
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 100.0,
                elevation: 0.0,
              ),
              body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: attendees.length,
                        itemBuilder: (context, index) {
                          UserData attendee =
                              (Provider.of<List<UserData>?>(context) ??
                                  [])[index];
                          return AttendanceTile(attendee: attendee, submit: submit);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            submit = true;
                            int count = 0;
                            Navigator.popUntil(context, (route) {
                              return count++ == 1;
                            });
                          });
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(1.0)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )))
        ]));
  }
}