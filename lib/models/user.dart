import 'package:flutter/material.dart';

class UserObj {

  final String uid;

  UserObj({ required this.uid });

}

// // TODO: See what info to store for a user like level, bio, etc.
class UserData {

  final String uid;
  Image profileImage;
  String name;
  int level;
  // Provide a list of options for users to choose from
  int faculty;
  int points;
  String bio;
  // Just need to store eventIDs of the events the user is participating
  List<String> events;

  UserData({
    required this.uid,
    required this.profileImage,
    required this.name,
    required this.level,
    required this.faculty,
    required this.points,
    required this.bio,
    required this.events,
  });

}
