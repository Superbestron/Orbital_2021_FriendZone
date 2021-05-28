import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/screens/home/event_page.dart';
import 'package:myapp/shared/constants.dart';

class EventTile extends StatelessWidget {

  final Event event;
  EventTile({ required this.event });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        color: CARD_BACKGROUND,
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          minLeadingWidth: 10,
          dense: true,
          // Event Icon
          trailing: Image(
            image: AssetImage('assets/event_icons/food.png'),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),

          // TODO: Formatting of event

          title: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
            child: Text(event.name, style: TextStyle(fontSize: 18)),
          ),
          subtitle: Column(
            children: [
              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Icon(Icons.calendar_today, size: 15),
                title: Text('${event.date}', style: TextStyle(fontSize: 15)),
                minLeadingWidth: 10.0,
              ),
              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Icon(Icons.access_time, size: 15),
                title: Text('${event.time}', style: TextStyle(fontSize: 15)),
                minLeadingWidth: 10.0,
              ),
              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                leading: Icon(Icons.group_rounded, size: 15),
                title: Text('${event.pax}', style: TextStyle(fontSize: 15)),
                minLeadingWidth: 10.0,
              ),
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stack(
                  children: <Widget> [
                    SvgPicture.asset(
                    'assets/background.svg',
                      fit: BoxFit.cover,
                    ),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        leading: BackButton(color: Colors.black),
                        title: Text(event.name, style: TextStyle(color: Colors.black)),
                        actions: <Widget> [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 35.0,
                            ),
                          ),
                        ],
                        toolbarHeight: 100.0,
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                      ),
                      body: Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                        child: EventPage(),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}

// For reference

// import 'package:flutter/material.dart';
// import 'package:myapp/models/event.dart';

//
// class BrewTile extends StatelessWidget {
//
//   final Event event;
//   BrewTile({ required this.brew });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 8.0),
//       child: Card(
//         margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 25.0,
//             backgroundColor: Colors.brown[brew.strength],
//             // backgroundImage: AssetImage('assets/...png'),
//           ),
//           title: Text(brew.name),
//           subtitle: Text('Takes ${brew.sugars} sugar(s)'),
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Scaffold(
//                 appBar: AppBar(
//                   leading: BackButton(),
//                 ),
//                 body: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
//                   child: EventPage(),
//                 ),
//               ),
//             )
//           ),
//         ),
//       ),
//     );
//   }
// }
