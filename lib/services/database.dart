import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/models/event.dart';
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

  // EVENTS
  Future getEventData(String eventID) async {
    DocumentReference ref = eventCollection.doc(eventID);
    var event = await ref.get().then((snapshot) =>
      Event(
        eventID: snapshot.get('eventID'),
        name: snapshot.get('name'),
        dateTime: snapshot.get('dateTime').toDate(),
        pax: snapshot.get('pax'),
        description: snapshot.get('description'),
        icon: snapshot.get('icon'),
        attendees: snapshot.get('attendees'),
      )
    );
    return event;
  }

  Future updateEventData(String name, DateTime dateTime,
      int pax, String description, int icon, String eventID, List<dynamic> attendees) async {
    return await eventCollection.doc(eventID).set({
      'name': name,
      'dateTime': dateTime,
      'pax': pax,
      'description': description,
      'icon': icon,
      'eventID': eventID,
      'attendees': attendees,
    });
  }

  Future createEventData(String name, DateTime dateTime,
      int pax, String description, int icon) async {
    String newDocID = eventCollection.doc().id;
    List<dynamic> attendees = [];
    attendees.add(uid);
    updateEventData(name, dateTime, pax, description, icon, newDocID, attendees);
    return newDocID;
  }

  // Event list from snapshot
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
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
      // uid: uid,
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
    return eventCollection.snapshots()
      .map(_eventListFromSnapshot);
  }

  // get event doc stream
  Stream<Event> getEvent(String eventID){
    return eventCollection.doc(eventID).snapshots()
      .map(_eventFromSnapshot);
  }

  Future addUserToEvent(String eventID, String uid) async {
    Event event = await getEventData(eventID);

    List<dynamic> newAttendees = event.attendees;
    newAttendees.add(uid);
    await updateEventData(event.name, event.dateTime, event.pax,
        event.description, event.icon, eventID, newAttendees);
  }

  Future deleteEvent(String eventID) async {
    await eventCollection.doc(eventID).delete();
  }

  Future removeUserFromEvent(String eventID, String uid) async {
    Event event = await getEventData(eventID);
    event.attendees.remove(uid);
    return await updateEventData(event.name, event.dateTime, event.pax,
      event.description, event.icon, event.eventID, event.attendees);
  }

  // get profile stream
  Stream<UserData> get userData {
    return profileCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  // TODO: Decide on what info to store about user
  Future updateUserData(String profileImagePath, String name, int level, int faculty,
      int points, String bio, List<dynamic> events) async {
    return await profileCollection.doc(uid).set({
      'profileImagePath': profileImagePath,
      'name': name,
      'level': level,
      'faculty': faculty,
      'points': points,
      'bio': bio,
      'events': events,
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
    );
  }

  Future getImageDataFromFirebase(String profileImagePath) async {
    await FirebaseStorage.instance.ref('images/5D637A11-6B11-415C-A97E-DAFA6D7457DD.heic').getDownloadURL();
  }

  // Future uploadImageToFirebase(File image, UserData userData) async {
  //   try {
  //     // Make random image
  //     String imageLocation = 'images/$uid.jpg';
  //
  //     // Upload image to Firebase
  //     await FirebaseStorage.instance.ref(imageLocation).putFile(image);
  //
  //     updateUserData(imageLocation, userData.name, userData.level, userData.faculty,
  //         userData.points, userData.bio, userData.events);
  //   } on FirebaseException catch (e) {
  //     print(e.code);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
