import 'package:flutter/material.dart';
import 'package:myapp/shared/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  DateTime? _date;
  TimeOfDay? _time;
  int? _pax;
  int _currentValue = 2;

  String getDateText() {
    if (_date == null) {
      return 'Select Date';
    } else {
      return '${_date!.month}/${_date!.day}/${_date!.year}';
    }
  }

  String getTimeText() {
    if (_time == null) {
      return 'Select Time';
    } else {
      final hours = _time!.hour.toString().padLeft(2, '0');
      final minutes = _time!.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  Future pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObj?>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Date:',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(getDateText(),
                            style: TextStyle(color: Colors.black)
                        ),
                        onPressed: () { pickDate(context); },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.brown[200],
                          )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Time:',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(getTimeText(),
                            style: TextStyle(color: Colors.black)
                        ),
                        onPressed: () { pickTime(context); },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown[200],
                        )
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    child: Text("Create",
                        style: TextStyle(color: Colors.black)
                    ),
                    onPressed: () { DatabaseService(uid: user!.uid).createEventData(
                      "name", "date", "time", 2, "desc", 3
                    ); },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[200],
                    )
                ),
              ],
            )

            // ListTile(
            //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            //   leading: Icon(Icons.calendar_today, size: 15),
            //   title: Text('Date', style: TextStyle(fontSize: 15)),
            // ),
            // ListTile(
            //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            //   leading: Icon(Icons.access_time, size: 15),
            //   title: Text('Time', style: TextStyle(fontSize: 15)),
            //   minLeadingWidth: 10.0,
            // ),
            // ListTile(
            //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            //   leading: Icon(Icons.group_rounded, size: 15),
            //   title: Text('Pax', style: TextStyle(fontSize: 15)),
            //   minLeadingWidth: 10.0,
            // ),
          ],
        ),
      ),
    );
  }
}
