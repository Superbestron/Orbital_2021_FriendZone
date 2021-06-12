import 'package:flutter/material.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/home/upcoming_event_tile.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    Iterable<Event> events = (Provider.of<List<Event>?>(context) ?? [])
        .where((event) => event.attendees.contains(user!.uid));

    // Filter the events which have already happened
    List<Event> upcomingEvents = events
        .where((event) => event.dateTime.isAfter(DateTime.now()))
        .toList();

    List<Event> pastEvents = events
        .where((event) => event.dateTime.isBefore(DateTime.now()))
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget> [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan> [
                      TextSpan(text: 'Upcoming', style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: upcomingEvents.length,
              itemBuilder: (context, index) {
                return UpcomingEventTile(event: upcomingEvents[index]);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(
                thickness: 2.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan> [
                      TextSpan(text: 'Past', style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pastEvents.length,
              itemBuilder: (context, index) {
                return UpcomingEventTile(event: pastEvents[index]);
              },
            ),
          ],
        ),
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