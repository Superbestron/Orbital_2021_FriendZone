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

    List<Event> events = (Provider.of<List<Event>?>(context) ?? []).where(
            (event) => event.name.toLowerCase().contains(query.toLowerCase())
                || months[event.dateTime.month - 1].toLowerCase().contains(query.toLowerCase())
                || event.dateTime.day.toString().contains(query.toLowerCase())
                || event.dateTime.hour.toString().contains(query.toLowerCase())
                || event.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    // Filter the events which have already happened
    events.removeWhere((event) => event.dateTime.isBefore(DateTime.now()));

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: textInputDecoration.copyWith(
                hintText: 'Search Event by Name',
                fillColor: CARD_BACKGROUND,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() { query = val; }),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
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

// For reference

// class BrewList extends StatefulWidget {
//   @override
//   _BrewListState createState() => _BrewListState();
// }
//
// class _BrewListState extends State<BrewList> {
//   @override
//   Widget build(BuildContext context) {
//
//     final brews = Provider.of<List<Brew>?>(context) ?? [];
//     brews.forEach((brew) {
//       print(brew.name);
//       print(brew.sugars);
//       print(brew.strength);
//     });
//
//     return ListView.builder(
//       itemCount: brews.length,
//       itemBuilder: (context, index) {
//         return BrewTile(brew: brews[index]);
//       },
//     );
//   }
// }

