import 'package:flutter/material.dart';

// Login Border
var textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: GREEN_1, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
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
List<Image> imageList = [
  Image(image: AssetImage('assets/event_icons/Friends.png'),),
  Image(image: AssetImage('assets/event_icons/Sports.png'),),
  Image(image: AssetImage('assets/event_icons/Study.png'),),
  Image(image: AssetImage('assets/event_icons/food.png'),),
  Image(image: AssetImage('assets/event_icons/Cocktail Glass.png'),),
];

// List of Faculties
List<String> faculties = [
  '',
  'School of Computing',
  'Faculty of Arts and Social Sciences',
  'School of Business',
  'Faculty of Dentistry',
  'Faculty of Engineering',
  'Faculty of Science'
];

// Date/Time Formatting
List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String getDateText(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Select Date';
  } else {
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year - 2000}';
  }
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
Color? revokeAttendance = HexColor.fromHex('FED8B1');

// Different text types
const TEXT_FIELD_HEADING = TextStyle(fontSize: 20);
const BOLDED_NORMAL = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
const NORMAL = TextStyle(fontSize: 16);

const DEFAULT_PROFILE_PIC = AssetImage('assets/default-profile-pic.jpeg');