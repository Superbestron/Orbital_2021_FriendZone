import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  // 1st Icon is selected by default
  List<bool> _isSelected = [true, false, false, false, false];
  String _name = '';
  String _telegramURL = '';
  DateTime? _dateTime;
  TimeOfDay? _time;
  int _pax = 2;
  String _description = '';
  int _icon = 1;
  List<int> numbers = List.generate(25, (index) => index++);

  final _formKey = GlobalKey<FormState>();

  void selectButton(int index) {
    for (int i = 0; i < _isSelected.length; i++) {
      if (i == index) {
        _isSelected[i] = true;
      } else {
        _isSelected[i] = false;
      }
    }
  }

  String _getTimeText() {
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
        firstDate: DateTime.now(),
        lastDate: DateTime(
          DateTime.now().year + 1,
          DateTime.now().month,
          DateTime.now().day
        ),
    );

    if (newDate != null) {
      setState(() {
        _dateTime = newDate;
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
        body: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
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
                          child: Text(getDateText(_dateTime),
                              style: TextStyle(color: Colors.black)
                          ),
                          onPressed: () { pickDate(context); },
                            style: ElevatedButton.styleFrom(
                              primary: ORANGE_1,
                              elevation: 10.0,
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
                          child: Text(_getTimeText(),
                              style: TextStyle(color: Colors.black)
                          ),
                          onPressed: () { pickTime(context); },
                          style: ElevatedButton.styleFrom(
                            primary: ORANGE_1,
                            elevation: 10.0,
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
                  maxLines: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Telegram chat URL'),
                  validator: (val) => val!.isEmpty ? 'Enter a telegram chat URL' : null,
                  onChanged: (val) => setState(() { _telegramURL = val; }),
                ),
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Choose your event icon: '),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:() {
                          setState(() {
                            selectButton(0);
                            _icon = 0;
                          });
                        },
                        child: imageList[0],
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: _isSelected[0] ? GREEN_1 : Colors.transparent,
                            width: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:() {
                          setState(() {
                            selectButton(1);
                            _icon = 1;
                          });
                        },
                        child: imageList[1],
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: _isSelected[1] ? GREEN_1 : Colors.transparent,
                            width: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:() {
                          setState(() {
                            selectButton(2);
                            _icon = 2;
                          });
                        },
                        child: imageList[2],
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: _isSelected[2] ? GREEN_1 : Colors.transparent,
                            width: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:() {
                          setState(() {
                            selectButton(3);
                            _icon = 3;
                          });
                        },
                        child: imageList[3],
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: _isSelected[3] ? GREEN_1 : Colors.transparent,
                            width: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:() {
                          setState(() {
                            selectButton(4);
                            _icon = 4;
                          });
                        },
                        child: imageList[4],
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            color: _isSelected[4] ? GREEN_1 : Colors.transparent,
                            width: 2),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Pax: '),
                  DropdownButton(
                    value: _pax,
                    items: numbers.map((x) => x + 2).map((pax) {
                      return DropdownMenuItem(
                          value: pax,
                          child: Text('$pax'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      return setState(() { _pax = int.parse(val.toString()); });
                    }
                  ),
                  SizedBox(width: 50.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      backgroundColor: ORANGE_1,
                      tooltip: 'Create Event',
                      child: Icon(Icons.add),
                      onPressed: () async {
                        // TODO: Validate that date and time are set by the user
                        if (_formKey.currentState!.validate()) {
                          _dateTime = DateTime(_dateTime!.year, _dateTime!.month, _dateTime!.day,
                              _time!.hour, _time!.minute);
                          String _uid = user!.uid;
                          DatabaseService db = DatabaseService(uid: _uid);
                          String eventID = await db.createEventData(
                            _telegramURL,
                            _uid, _name, _dateTime!,
                            _pax, _description, _icon,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: BACKGROUND_COLOR,
                              content: Text('Successfully created an event!'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () async {
                                  await db.deleteEvent(eventID);
                                },
                              ),
                            )
                          );
                        }
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
