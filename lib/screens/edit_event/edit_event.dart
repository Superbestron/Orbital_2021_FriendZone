import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/database.dart';
import 'package:myapp/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/models/event.dart';

class EditEvent extends StatefulWidget {
  final Event event;

  EditEvent({required this.event});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  List<bool> _isSelected = [false, false, false, false, false];
  String _name = '';
  String _telegramURL = '';
  late DateTime _dateTime;
  late TimeOfDay _time;
  int _pax = 2;
  int _currPax = 2;
  String _description = '';
  int _icon = 0;
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
  
  List<dynamic> eventAttendeesExceptInitiator(List<dynamic> eventAttendees) {
    eventAttendees.removeAt(0);
    return eventAttendees;
  }

  String _getTimeText() {
    final hours = _time.hour.toString().padLeft(2, '0');
    final minutes = _time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      // So that initiator won't change to an abrupt date (2 days in advance from now)
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
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
      initialTime: _time,
    );

    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  void initState() {
    Event event = widget.event;
    _name = event.name;
    _description = event.description;
    _telegramURL = event.telegramURL;
    _dateTime = event.dateTime;
    _time = TimeOfDay.fromDateTime(event.dateTime);
    _icon = event.icon;
    _isSelected[_icon] = true;
    _pax = event.pax;
    _currPax = event.attendees.length == 1 ? 2 : event.attendees.length;
    _location = event.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    final user = Provider.of<UserObj?>(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: BackButton(color: Colors.black),
            title: Text(
              "Edit Event",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                child: IMAGE_LIST[_icon],
              ),
            ],
            toolbarHeight: 75.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _name,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Event Name'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an event name' : null,
                        onChanged: (val) => setState(() {
                          _name = val;
                        }),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Select Date:',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: Text(getDateText(_dateTime),
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    pickDate(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: ORANGE_1,
                                    elevation: 10.0,
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Select Time:',
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: Text(_getTimeText(),
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    pickTime(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: ORANGE_1,
                                    elevation: 10.0,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _description,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Event Description'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an event description' : null,
                        onChanged: (val) => setState(() {
                          _description = val;
                        }),
                        maxLines: 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _telegramURL,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Telegram chat URL'),
                        onChanged: (val) => setState(() {
                          _telegramURL = val;
                        }),
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
                              // min is current pax while max is 10
                              items: List.generate(9 - _currPax + 2, (index) => index++)
                                  .map((x) => x + _currPax)
                                  .map((pax) {
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
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildExpanded(0),
                              buildExpanded(1),
                              buildExpanded(2),
                              buildExpanded(3),
                              buildExpanded(4),
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                              backgroundColor: ORANGE_1,
                              tooltip: 'Delete Event',
                              child: Icon(Icons.delete),
                              onPressed: () async {
                                String _uid = user!.uid;
                                DatabaseService db = DatabaseService(uid: _uid);
                                await db.deleteEvent(event.eventID);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: BACKGROUND_COLOR,
                                  content:
                                      Text('Successfully deleted an event!'),
                                  action: SnackBarAction(
                                    label: 'Dismiss',
                                    onPressed: () async {},
                                  ),
                                ));
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              }),
                        ),
                        Expanded(
                          child: FloatingActionButton(
                              backgroundColor: ORANGE_1,
                              tooltip: 'Edit Event',
                              child: Icon(Icons.check),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _dateTime = DateTime(
                                      _dateTime.year,
                                      _dateTime.month,
                                      _dateTime.day,
                                      _time.hour,
                                      _time.minute);
                                  String _uid = user!.uid;
                                  DatabaseService db =
                                      DatabaseService(uid: _uid);
                                  db.updateEventData(
                                      _location,
                                      _telegramURL,
                                      _name,
                                      _dateTime,
                                      _pax,
                                      _description,
                                      _icon,
                                      event.eventID,
                                      event.attendees);
                                  db.sendNotification(event.name,
                                    "Event details has been changed",
                                     "event_change",
                                    {'eventID':event.eventID},
                                    eventAttendeesExceptInitiator(event.attendees),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: BACKGROUND_COLOR,
                                    content:
                                        Text('Successfully edited an event!'),
                                    action: SnackBarAction(
                                      label: 'Dismiss',
                                      onPressed: () async {},
                                    ),
                                  ));
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ),
      ],
    );
  }

  Expanded buildExpanded(int number) {
    return Expanded(
      child: TextButton(
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
    );
  }
}
