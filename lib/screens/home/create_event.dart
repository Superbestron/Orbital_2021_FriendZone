import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  String _name = '';
  DateTime? _date;
  String _dateString = '';
  TimeOfDay? _time;
  String _timeString = '';
  int _pax = 2;
  String _description = '';
  int _icon = 1;

  final _formKey = GlobalKey<FormState>();

  String getDateText() {
    if (_date == null) {
      return 'Select Date';
    } else {
      _dateString = '${_date!.day}-${_date!.month}-${_date!.year}';
      return _dateString;
    }
  }

  String getTimeText() {
    if (_time == null) {
      return 'Select Time';
    } else {
      final hours = _time!.hour.toString().padLeft(2, '0');
      final minutes = _time!.minute.toString().padLeft(2, '0');
      _timeString = '$hours:$minutes';
      return _timeString;
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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Event Name'),
                  validator: (val) => val!.isEmpty ? 'Enter an event name' : null,
                  onChanged: (val) => setState(() { _name = val; }),
                ),
              ),
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
                                primary: ORANGE_1,
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
                            primary: ORANGE_1,
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Event Description'),
                  validator: (val) => val!.isEmpty ? 'Enter an event description' : null,
                  onChanged: (val) => setState(() { _description = val; }),
                  maxLines: 8,
                ),
              ),
              ElevatedButton(
                child: Text('Create Event'),
                onPressed: () async {
                  // TODO: Validate that date and time are set by the user
                  if (_formKey.currentState!.validate()) {
                    await DatabaseService(uid: user!.uid).createEventData(
                      _name, _dateString, _timeString,
                      _pax, _description, _icon,
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        content: Text('You have successfully created an event!'))
                    );
                  }
                }
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
      ),
    );
  }
}
