import 'package:flutter/material.dart';

// Login Border
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

// List of icons
List<Icon> iconList = [
  Icon(Icons.alarm),
];

// Time
const months = ['January', 'February', 'March', 'April',
  'May', 'June', 'July', 'August', 'September', 'October', 'November',
      'December'];

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