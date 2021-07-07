import 'package:flutter/material.dart';

// Login Border
var textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: GREEN_1, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ORANGE_1, width: 2.0),
  ),
);

var boxDecoration = BoxDecoration(
  border: Border.all(
    color: GREEN_1,
    width: 2.0
  ),
  borderRadius: BorderRadius.all(Radius.circular(20))
);

// TODO: Update Icons here
// List of icons
const List<Image> IMAGE_LIST = [
  Image(image: AssetImage('assets/event_icons/Friends.png')),
  Image(image: AssetImage('assets/event_icons/Sports.png')),
  Image(image: AssetImage('assets/event_icons/Study.png')),
  Image(image: AssetImage('assets/event_icons/food.png')),
  // Image(image: AssetImage('assets/event_icons/Cocktail Glass.png')),
];

const List<String> CATEGORIES = [
  'Social', 'Sports', 'Study', 'Food'
  // , 'Others'
];


// List of Faculties
const List<String> FACULTIES = [
  '',
  'School of Computing',
  'Faculty of Arts and Social Sciences',
  'School of Business',
  'Faculty of Dentistry',
  'Faculty of Engineering',
  'Faculty of Science'
];

// Date/Time Formatting
const List<String> MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

// TYPES OF NOTIFICATIONS
const Map<String, Color> NOTIFICATION_TYPES =
  {'event_change': Colors.amber,
  'event_deleted': Colors.redAccent,
  'friend_notification': Colors.greenAccent};

String getNotificationType(int index) {
  return NOTIFICATION_TYPES.keys.elementAt(index);
}

String getDateText(DateTime dateTime) {
  return '${dateTime.day} ${MONTHS[dateTime.month - 1]} ${dateTime.year - 2000}';
}

String getTimeText(DateTime dateTime) {
  final hours = dateTime.hour.toString().padLeft(2, '0');
  final minutes = dateTime.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

// constants for colors

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

// ignore: non_constant_identifier_names
Color BACKGROUND_COLOR = HexColor.fromHex('FDFDFD');
// ignore: non_constant_identifier_names
Color GREEN_1 = HexColor.fromHex('BFE1D7');
// ignore: non_constant_identifier_names
Color ORANGE_1 = HexColor.fromHex('E1B58F');
// ignore: non_constant_identifier_names
Color CARD_BACKGROUND = HexColor.fromHex('F8F8F8');
Color? greyedOut = Colors.grey[400];
Color? selectedColor = HexColor.fromHex('E08956');

// Different text types
const BOLDED_HEADING = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TEXT_FIELD_HEADING = TextStyle(fontSize: 20);
const BOLDED_NORMAL = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
const NORMAL = TextStyle(fontSize: 16);

// locations for selection
const List LOCATIONS = [
  ["Others", null, null],
  ["Dean's Office, FASS", 1.294312, 103.771062],
  ["Faculty of Engineering", 1.299187, 103.771312],
  ["NUS Alumni Relations", 1.293312, 103.773687],
  ["NUS Biological Sciences", 1.295562, 103.778688],
  ["NUS Business School", 1.292562, 103.774187],
  ["NUS Department of Chemistry", 1.296562, 103.778937],
  ["NUS Department of Chinese Studies", 1.295937, 103.772063],
  ["NUS Enterprise", 1.292438, 103.775688],
  ["NUS Environmental Research Institute", 1.299688, 103.772063],
  ["NUS Information Technology", 1.297563, 103.772562],
  ["NUS Office of Student Affairs", 1.298563, 103.774812],
  ["NUS School of Computing", 1.294812, 103.773687],
  ["Utown", 1.305438, 103.773062],
  ["Utown Aud 1", 1.303937, 103.773438],
  ["Yale-NUS college", 1.306938, 103.771812],
  ["Yusof Ishak House", 1.298563, 103.774937]
];

const DEFAULT_PROFILE_PIC = AssetImage('assets/default-profile-pic.jpeg');
