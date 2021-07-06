import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_tile.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/constants.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  String query = '';
  // Default index of -1 shows all categories
  int categoryIndex = -1;
  // all icons are not selected by default
  List<bool> _isSelected = [false, false, false, false];

  void selectButton(int index) {
    if (categoryIndex != index) {
      for (int i = 0; i < _isSelected.length; i++) {
        if (i == index) {
          _isSelected[i] = true;
        } else {
          _isSelected[i] = false;
        }
      }
      categoryIndex = index;
    } else {
      _isSelected[index] = false;
      categoryIndex = -1;
    }
  }

  void selectCategory(int index, List<Event> events) {
    if (index != -1) {
      events = events.where((event) => event.icon == index).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = (Provider.of<List<Event>?>(context) ?? []);

    // Filter the events which have already happened
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now()));

    if (categoryIndex != -1) {
      events = events.where((event) => event.icon == categoryIndex).toList();
    }

    events = events.where((event) =>
      event.name.toLowerCase().contains(query.toLowerCase()) ||
      MONTHS[event.dateTime.month - 1]
          .toLowerCase()
          .contains(query.toLowerCase()) ||
      event.dateTime.day.toString().contains(query.toLowerCase()) ||
      event.dateTime.hour.toString().contains(query.toLowerCase()) ||
      event.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: textInputDecoration.copyWith(
                hintText: 'Search Event',
                fillColor: CARD_BACKGROUND,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) async {
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  query = val;
                });
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildElevatedButton(0),
                buildElevatedButton(1),
                buildElevatedButton(2),
                buildElevatedButton(3),
              ],
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventTile(event: events[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildElevatedButton(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectButton(index);
          });
        },
        child: Text(CATEGORIES[index]),
        style: ElevatedButton.styleFrom(
          primary: _isSelected[index] ? selectedColor : ORANGE_1
        )
      ),
    );
  }
}

