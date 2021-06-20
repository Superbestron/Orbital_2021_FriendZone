import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/models/event.dart';

import 'constants.dart';

ListTile buildEventDetailsListTile(Event event, Icon icon, Text text) {
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
    leading: icon,
    title: text,
    minLeadingWidth: 10.0,
  );
}

SvgPicture buildBackgroundImage() {
  return SvgPicture.asset(
    'assets/background.svg',
    fit: BoxFit.cover,
    clipBehavior: Clip.hardEdge,
  );
}

AppBar buildAppBar(String text) {
  return AppBar(
    centerTitle: true,
    leading: BackButton(color: Colors.black),
    title: Text(
      text,
      style: TextStyle(color: Colors.black),
    ),
    toolbarHeight: 100.0,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
  );
}


// card template
Card buildCard(BuildContext context) {
  return Card(
    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
    color: CARD_BACKGROUND,
    child: ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      minLeadingWidth: 10,
      dense: true,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
        // child: Text(event.name, style: TextStyle(fontSize: 18)),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              // children: [
              //   buildEventDetailsListTile(event,
              //       Icon(Icons.calendar_today, size: 15),
              //       Text('${getDateText(event.dateTime)}', style: NORMAL)
              //   ),
              //   buildEventDetailsListTile(event,
              //       Icon(Icons.access_time, size: 15),
              //       Text('${getTimeText(event.dateTime)}', style: NORMAL)
              //   ),
              //   buildEventDetailsListTile(event,
              //       Icon(Icons.group_rounded, size: 15),
              //       Text('${event.attendees.length} / ${event.pax}', style: NORMAL)
              //   ),
              // ],
            ),
          ),
          Expanded(
            child: Column(
              // children: <Widget>[
              //   IMAGE_LIST[event.icon],
              //   if (isNotiPage)
              //     Clock(dateTime: event.dateTime).build(context)
              // ],
            ),
          ),
        ],
      ),
    ),
  );
}