class UserObj {

  final String uid;

  UserObj({ required this.uid });

}

class UserData {

  final String uid;
  String profileImagePath;
  String name;
  int level;
  // Provide a list of options for users to choose from
  String faculty;
  int points;
  String bio;
  // Just need to store eventIDs of the events the user is participating
  List<dynamic> events;
  List<dynamic> notifications;
  /// Not really friends. This is list of friend request received
  /// If both parties have each other on their own respective list, then they are friends
  List<dynamic> friends;
  int friendCount;

  UserData({
    required this.uid,
    required this.profileImagePath,
    required this.name,
    required this.level,
    required this.faculty,
    required this.points,
    required this.bio,
    required this.events,
    required this.notifications,
    required this.friends,
    required this.friendCount
  });

}
