import 'package:flutter/material.dart';

class Clock extends StatelessWidget {

  DateTime dateTime;

  Clock({ required this.dateTime });

  String timeLeft(Duration duration) {
    int totalMinutes = duration.inMinutes;
    if (totalMinutes < 0) {
      return 'Event has ended!';
    }
    int days = totalMinutes ~/ (60 * 24);
    int hours = (totalMinutes - days * 60 * 24) ~/ 60;
    int minutes = totalMinutes % 60;
    return 'In $days Days $hours Hours $minutes Mins!';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Center(
          child: Text(
            timeLeft(dateTime.difference(DateTime.now())),
            style: TextStyle(
              fontSize: 14,
              color: Colors.cyan[600],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}