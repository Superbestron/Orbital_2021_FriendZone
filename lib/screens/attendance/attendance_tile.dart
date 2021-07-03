import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/shared/constants.dart';

class AttendanceTile extends StatefulWidget {
  final UserData attendee;

  AttendanceTile({required this.attendee});

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  bool _attendance = true;

  @override
  Widget build(BuildContext context) {
    UserData attendee = widget.attendee;
    return Card(
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      color: CARD_BACKGROUND,
      child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          minLeadingWidth: 10,
          // dense: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(attendee.name, style: TEXT_FIELD_HEADING),
          ),
          subtitle: Text('Level ${attendee.level}', style: NORMAL),
          trailing: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Radio<bool>(
                        onChanged: (bool? value) {
                          setState(() {
                            _attendance = value!;
                          });
                        }, groupValue: _attendance,
                        value: true,
                      ),
                      Text("Present")
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        onChanged: (bool? value) {
                          setState(() {
                            _attendance = value!;
                          });
                        }, groupValue: _attendance,
                        value: false,
                      ),
                      Text("Absent")
                    ]
                  )
                ],
              )
          )
      ),
    );
  }
}
