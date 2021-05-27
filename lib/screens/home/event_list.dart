import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_tile.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  final String query;
  EventList({required this.query});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final query = widget.query;
    final events = (Provider.of<List<Event>?>(context) ?? []).where(
            (event) => event.name.toLowerCase().contains(query.toLowerCase())
                || event.date.toLowerCase().contains(query.toLowerCase())
                || event.time.toLowerCase().contains(query.toLowerCase())
                || event.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    // print(query);
    // events.forEach((event) {
    //   print(event.name);
    //   print(event.date);
    //   print(event.time);
    //   print(event.pax);
    //   print(event.description);
    //   print(event.icon);
    // });

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventTile(event: events[index]);
      },
    );
  }
}
