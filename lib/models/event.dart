class Event {

  final String eventID;
  String name;
  DateTime dateTime;
  int pax;
  String description;
  int icon; // probably should change this to enum in the future

  Event({
    required this.eventID,
    required this.name,
    required this.dateTime,
    required this.pax,
    required this.description,
    required this.icon,
  });

}


// Separate class from Event to uniquely identify an event
// TODO: Decide on a unique identifier for an event, right now its by uid

class EventData {

  //final String uid;
  String name;
  DateTime dateTime;
  int pax;
  String description;
  int icon; // probably should change this to enum in the future
  List<dynamic> attendees;

  EventData({
    // required this.uid,
    required this.name,
    required this.dateTime,
    required this.pax,
    required this.description,
    required this.icon,
    required this.attendees,
  });

}