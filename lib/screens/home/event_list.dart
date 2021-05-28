import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_tile.dart';
import 'package:provider/provider.dart';
import 'package:myapp/shared/constants.dart';


class EventList extends StatefulWidget {
  final String query;
  EventList({required this.query});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  String query = '';

  @override
  Widget build(BuildContext context) {

    List<Event> events = (Provider.of<List<Event>?>(context) ?? []).where(
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
          itemCount: events.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Search Event by Name',
                        fillColor: CARD_BACKGROUND,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) => setState(() { query = val; }),
                    ),
                  );
            } else {
              return EventTile(event: events[index - 1]);
            }
          },


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

