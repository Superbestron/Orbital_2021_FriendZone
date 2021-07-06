import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {

  final Function jumpToPage;

  CreateEvent({ required this.jumpToPage });

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
        initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Event Name',
                      prefixIcon: Icon(Icons.event),
                    ),
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
                          style: BOLDED_NORMAL
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text(getDateText(_dateTime)),
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
                          style: BOLDED_NORMAL
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text(_getTimeText()),
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
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Telegram chat URL',
                      prefixIcon: Icon(Icons.message)
                    ),
                    validator: (val) => val!.isNotEmpty && !val.startsWith('t.me/joinchat/')
                      ? 'Link should start with t.me/joinchat/ or be blank'
                      : null,
                    onChanged: (val) => setState(() { _telegramURL = val; }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
                  child: Row(
                    children: [
                      Text('Pax: ', style: BOLDED_NORMAL),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButton(
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 7.5, 10, 2.5),
                  child: Text('Location: ', style: BOLDED_NORMAL),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2.5, 10, 20),
                  child: DropdownButton(
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
                            width: 270,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        return setState(() {
                          _location = val.toString();
                        });
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
                  child: Text('Choose your event category: ', style: BOLDED_NORMAL),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildExpanded(0),
                    buildExpanded(1),
                    buildExpanded(2),
                    buildExpanded(3),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: FloatingActionButton(
                    backgroundColor: ORANGE_1,
                    tooltip: 'Create Event',
                    child: Icon(Icons.add, color: Colors.white),
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
                        _formKey.currentState!.reset();
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
                        // Go Back to Home Screen
                        widget.jumpToPage(0);
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildExpanded(int number) {
    return Expanded(
      child: Column(
        children: [
          TextButton(
            onPressed:() {
              setState(() {
                selectButton(number);
                _icon = number;
              });
            },
            child: IMAGE_LIST[number],
            style: TextButton.styleFrom(
              side: BorderSide(
                color: _isSelected[number] ? GREEN_1 : Colors.transparent,
                width: 2),
            ),
          ),
          Text(CATEGORIES[number], style: NORMAL)
        ],
      ),
    );
  }
}
