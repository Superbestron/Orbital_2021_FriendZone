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

  @override
  Widget build(BuildContext context) {
    List<Event> events = (Provider.of<List<Event>?>(context) ?? [])
        .where((event) =>
            event.name.toLowerCase().contains(query.toLowerCase()) ||
            MONTHS[event.dateTime.month - 1]
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            event.dateTime.day.toString().contains(query.toLowerCase()) ||
            event.dateTime.hour.toString().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Filter the events which have already happened
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now()));

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintText: 'Search Event',
                fillColor: CARD_BACKGROUND,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() {
                query = val;
              }),
            ),
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
    );
  }
}

