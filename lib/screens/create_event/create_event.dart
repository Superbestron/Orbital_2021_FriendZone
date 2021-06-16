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
  DateTime _dateTime =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);
  TimeOfDay _time = TimeOfDay.now();
  int _pax = 2;
  String _description = '';
  int _icon = 0;
  List<int> numbers = List.generate(9, (index) => index++);

  String _location = LOCATIONS[0][0];

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
    final hours = _time.hour.toString().padLeft(2, '0');
    final minutes = _time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
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
                      title: Text('Select Date:',
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
                      title: Text('Select Time:',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 45.0),
                      child: Text('Pax: ', style: NORMAL),
                    ),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text('Location: ', style: NORMAL),
                    ),
                    DropdownButton(
                        itemHeight: kMinInteractiveDimension,
                        isDense: true,
                        value: _location,
                        items: LOCATIONS.map((location) {
                          return DropdownMenuItem(
                            value: location[0],
                            child: SizedBox(
                              child: Text('${location[0]}',
                                  overflow: TextOverflow.visible
                              ),
                              width: 230,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          return setState(() {
                            _location = val.toString();
                          });
                        }
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 0, 8),
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
                        child: IMAGE_LIST[0],
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
                        child: IMAGE_LIST[1],
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
                        child: IMAGE_LIST[2],
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
                        child: IMAGE_LIST[3],
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
                        child: IMAGE_LIST[4],
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  backgroundColor: ORANGE_1,
                  tooltip: 'Create Event',
                  child: Icon(Icons.add),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _dateTime = DateTime(_dateTime.year, _dateTime.month,
                          _dateTime.day, _time.hour, _time.minute);
                      String _uid = user!.uid;
                      DatabaseService db = DatabaseService(uid: _uid);
                      String eventID = await db.createEventData(
                        _location, _telegramURL,
                        _name, _dateTime,
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
                      Navigator.pop(context);
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
