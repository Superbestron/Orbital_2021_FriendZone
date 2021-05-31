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

   bool ifPastEvent(Event event, DateTime currDate, TimeOfDay currTime) {
     // [day, month, year]
     List<String> dateArr = event.date.split('-').toList();
     int year = int.parse(dateArr[2]);
     int month = int.parse(dateArr[1]);
     int day = int.parse(dateArr[0]);

     // [minute, hour]
     List<String> timeArr = event.time.split(':').toList();
     int hour = int.parse(timeArr[1]);
     int minute = int.parse(timeArr[0]);

     if (currDate.year > year) {
       return true;
     } else if (currDate.year < year) {
       return false;
     } else {
       if (currDate.month > month) {
         return true;
       } else if (currDate.month < month) {
         return false;
       } else {
         if (currDate.day > day) {
           return true;
         } else if (currDate.day < day) {
           return false;
         } else {
           if (currTime.hour > hour) {
             return true;
           } else if (currTime.hour < hour) {
             return false;
           } else {
             if (currTime.minute > minute) {
               return true;
             } else {
               return false;
             }
           }
         }
       }
     }
   }


  @override
  Widget build(BuildContext context) {

    List<Event> events = (Provider.of<List<Event>?>(context) ?? []).where(
            (event) => event.name.toLowerCase().contains(query.toLowerCase())
                || event.date.toLowerCase().contains(query.toLowerCase())
                || event.time.toLowerCase().contains(query.toLowerCase())
                || event.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    DateTime _currDate = DateTime.now();
    TimeOfDay _currTime = TimeOfDay.now();

    // Filter the events which have already happened
    events.removeWhere((event) => ifPastEvent(event, _currDate, _currTime));

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

