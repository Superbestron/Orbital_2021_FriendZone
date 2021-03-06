class Event {

  final String location;
  final String telegramURL;
  final String eventID;
  String name;
  DateTime dateTime;
  int pax;
  String description;
  int icon; // probably should change this to enum in the future
  List<dynamic> attendees;
  bool eventMarked;

  Event({
    required this.location,
    required this.telegramURL,
    required this.eventID,
    required this.name,
    required this.dateTime,
    required this.pax,
    required this.description,
    required this.icon,
    required this.attendees,
    required this.eventMarked,
  });

}
