class Event {

  final String name;
  final String date;
  final String time;
  final int pax;
  final String description;
  final int icon; // probably should change this to enum in the future

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.pax,
    required this.description,
    required this.icon
  });

}
