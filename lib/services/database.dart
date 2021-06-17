import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
import 'package:myapp/models/user.dart';

class DatabaseService {
  final String uid;

  //final String eventID;

  DatabaseService({
    required this.uid,
    // required this.eventID
  });

  // collection reference to all events
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // collection reference to all user profiles
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  // collection reference to notifications
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  // storage reference to user's profile images
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImage(File _image1) async {
    String url = '';
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  // EVENTS
  Future getEventData(String eventID) async {
    DocumentReference ref = eventCollection.doc(eventID);
    var event = await ref.get().then((snapshot) => Event(
          location: snapshot.get('location'),
          telegramURL: snapshot.get('telegramURL'),
          eventID: snapshot.get('eventID'),
          name: snapshot.get('name'),
          dateTime: snapshot.get('dateTime').toDate(),
          pax: snapshot.get('pax'),
          description: snapshot.get('description'),
          icon: snapshot.get('icon'),
          attendees: snapshot.get('attendees'),
        ));
    return event;
  }

  Future updateEventData(
      String location,
      String telegramURL,
      String name,
      DateTime dateTime,
      int pax,
      String description,
      int icon,
      String eventID,
      List<dynamic> attendees) async {
    return await eventCollection.doc(eventID).set({
      'location': location,
      'telegramURL': telegramURL,
      'name': name,
      'dateTime': dateTime,
      'pax': pax,
      'description': description,
      'icon': icon,
      'eventID': eventID,
      'attendees': attendees,
    });
  }

  Future createEventData(String location, String telegramURL, String name,
      DateTime dateTime, int pax, String description, int icon) async {
    String newDocID = eventCollection.doc().id;
    List<dynamic> attendees = [];
    attendees.add(uid);
    updateEventData(location, telegramURL, name, dateTime, pax, description,
        icon, newDocID, attendees);
    return newDocID;
  }

  // Event list from snapshot
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
        location: doc.get('location'),
        telegramURL: doc.get('telegramURL'),
        eventID: doc.get('eventID'),
        name: doc.get('name') ?? '',
        dateTime: doc.get('dateTime').toDate(),
        pax: doc.get('pax') ?? 1,
        description: doc.get('description') ?? '',
        icon: doc.get('icon') ?? 0,
        attendees: doc.get('attendees') ?? [],
      );
    }).toList();
  }

  // EventData from snapshot
  Event _eventFromSnapshot(DocumentSnapshot snapshot) {
    return Event(
      location: snapshot.get('location'),
      telegramURL: snapshot.get('telegramURL'),
      eventID: snapshot.get('eventID'),
      name: snapshot.get('name'),
      dateTime: snapshot.get('dateTime').toDate(),
      pax: snapshot.get('pax'),
      description: snapshot.get('description'),
      icon: snapshot.get('icon'),
      attendees: snapshot.get('attendees'),
    );
  }

  // get events stream
  Stream<List<Event>> get events {
    return eventCollection.snapshots().map(_eventListFromSnapshot);
  }

  // get event doc stream
  Stream<Event> getEvent(String eventID) {
    return eventCollection.doc(eventID).snapshots().map(_eventFromSnapshot);
  }

  Future addUserToEvent(String eventID, String uid) async {
    Event event = await getEventData(eventID);

    List<dynamic> newAttendees = event.attendees;
    newAttendees.add(uid);
    await updateEventData(
        event.location,
        event.telegramURL,
        event.name,
        event.dateTime,
        event.pax,
        event.description,
        event.icon,
        eventID,
        newAttendees);
  }

  Future deleteEvent(String eventID) async {
    await eventCollection.doc(eventID).delete();
  }

  Future removeUserFromEvent(String eventID, String uid) async {
    Event event = await getEventData(eventID);
    event.attendees.remove(uid);
    return await updateEventData(
        event.location,
        event.telegramURL,
        event.name,
        event.dateTime,
        event.pax,
        event.description,
        event.icon,
        eventID,
        event.attendees);
  }

  // get profile stream
  Stream<UserData> get userData {
    return profileCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updateUserData(
      String profileImagePath,
      String name,
      int level,
      String faculty,
      int points,
      String bio,
      List<dynamic> events,
      List<dynamic> notifications,
      List<dynamic> friends) async {
    print('Updating User Data');
    return await profileCollection.doc(uid).set({
      'profileImagePath': profileImagePath,
      'name': name,
      'level': level,
      'faculty': faculty,
      'points': points,
      'bio': bio,
      'events': events,
      'notifications': notifications,
      'friends': friends,
    });
  }

  // Maps snapshot of user's data from Firebase back to UserData object
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    // use snapshot.get(field_name) to add other fields easily
    return UserData(
      uid: uid,
      profileImagePath: snapshot.get('profileImagePath'),
      name: snapshot.get('name'),
      level: snapshot.get('level'),
      faculty: snapshot.get('faculty'),
      points: snapshot.get('points'),
      bio: snapshot.get('bio'),
      events: snapshot.get('events'),
      notifications: snapshot.get('notifications'),
      friends: snapshot.get('friends'),
    );
  }

  // assuming all profile images stored in images directory
  Future getImageURLFromFirebase(String profileImagePath) async {
    return await storage.ref(profileImagePath).getDownloadURL();
  }

  Future deleteImageFromFirebase(String profileImagePath) async {
    return await storage.ref().child(profileImagePath).delete();
  }

  // Returns the profile image path
  Future uploadImageToFirebase(File image, UserData userData) async {
    try {
      // Make random image
      String imageLocation = 'images/$uid.jpg';

      // Upload image to Firebase
      await FirebaseStorage.instance.ref(imageLocation).putFile(image);
      return imageLocation;
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future getNameFromUserID(String userID) {
    return profileCollection
        .doc(userID)
        .get()
        .then((snapshot) => snapshot.get('name'));
  }

  Future getUserData(String userID) async {
    DocumentReference ref = profileCollection.doc(userID);
    var user = await ref.get().then((snapshot) => UserData(
          uid: uid,
          profileImagePath: snapshot.get('profileImagePath'),
          name: snapshot.get('name'),
          level: snapshot.get('level'),
          faculty: snapshot.get('faculty'),
          points: snapshot.get('points'),
          bio: snapshot.get('bio'),
          events: snapshot.get('events'),
          notifications: snapshot.get('notifications'),
          friends: snapshot.get('friends'),
        ));
    return user;
  }

  void addRelation(String from, String to) async {
    UserData toUser = await getUserData(to);
    toUser.friends.add(from);
    print(toUser.friends);
    updateUserData(
        toUser.profileImagePath,
        toUser.name,
        toUser.level,
        toUser.faculty,
        toUser.points,
        toUser.bio,
        toUser.events,
        toUser.notifications,
        toUser.friends
    );
  }

  Future getNotificationObj(String notificationID) async {
    DocumentReference ref = notificationsCollection.doc(notificationID);
    var notificationObj = await ref.get().then((snapshot) => NotificationObj(
          title: snapshot.get('title'),
          subtitle: snapshot.get('subtitle'),
          type: snapshot.get('type'),
          additionalInfo: snapshot.get('additionalInfo'),
        ));
    return notificationObj;
  }

  void sendNotificationToUser(String notificationID, String uid) async {
    UserData user = await getUserData(uid);
    List notifications = user.notifications;
    notifications.add(notificationID);
    updateUserData(user.profileImagePath, user.name, user.level, user.faculty,
        user.points, user.bio, user.events, notifications, user.friends);
  }

  // Adds a new notification to database
  void sendNotification(String title, String subtitle, String type,
      Map additionalInfo, List attendees) async {
    String newDocID = notificationsCollection.doc().id;
    notificationsCollection.doc(newDocID).set({
      'title': title,
      'subtitle': subtitle,
      'type': type,
      'additionalInfo': additionalInfo,
    });
    for (String attendee in attendees) {
      sendNotificationToUser(newDocID, attendee);
    }
  }

  void sendFriendNotification(String action, String from, String to) async {
    UserData fromUser = await getUserData(from);
    String title = fromUser.name;
    String subtitle = action;
    String type = "friend_notification";
    Map additionalInfo = {
      'profileID': from,
    };
    String newDocID = notificationsCollection.doc().id;
    notificationsCollection.doc(newDocID).set({
      'title': title,
      'subtitle': subtitle,
      'type': type,
      'additionalInfo': additionalInfo,
    });
    sendNotificationToUser(newDocID, to);
  }

  Future updateNotification(List<dynamic> notifications) async {
    DocumentReference ref = profileCollection.doc(uid);
    UserData user = await ref.get().then((snapshot) => UserData(
      uid: uid,
      profileImagePath: snapshot.get('profileImagePath'),
      name: snapshot.get('name'),
      level: snapshot.get('level'),
      faculty: snapshot.get('faculty'),
      points: snapshot.get('points'),
      bio: snapshot.get('bio'),
      events: snapshot.get('events'),
      notifications: notifications,
      friends: snapshot.get('friends'),
    ));
    return await updateUserData(user.profileImagePath, user.name, user.level,
        user.faculty, user.points, user.bio, user.events, user.notifications,
        user.friends);
  }
}
