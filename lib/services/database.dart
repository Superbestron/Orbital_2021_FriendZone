import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/user.dart';
import 'package:flutter/material.dart';

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

  // collection reference to user profiles
  final CollectionReference profileCollection =
  FirebaseFirestore.instance.collection('profiles');

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

  // TODO: Decide on what info to store about an event
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
    await eventCollection.doc(newDocID).set({
      'name': name,
      'dateTime': dateTime,
      'pax': pax,
      'description': description,
      'icon': icon,
      'eventID': newDocID,
      'attendees': attendees,
    });
    return newDocID;
  }

  // TODO: Decide on what info to store about user
  Future updateUserData(Image profileImage, String name, int level, int faculty,
      int points, String bio, List<Event> events) async {
    return await profileCollection.doc(uid).set({
      'profileImage': profileImage,
      'name': name,
      'level': level,
      'faculty': faculty,
      'points': points,
      'bio': bio,
      'events' : events,
    });
  }

  Future getUserData() async {
    DocumentReference ref = profileCollection.doc(uid);
    UserData user = await ref.get().then((snapshot) =>
      // use snapshot.get(field_name) to add other fields easily
      UserData (
        uid: ref.id,
        profileImage: snapshot.get('profileImage'),
        name: snapshot.get('name'),
        level: snapshot.get('level'),
        faculty: snapshot.get('faculty'),
        points: snapshot.get('points'),
        bio: snapshot.get('bio'),
        events: snapshot.get('icon'),
      )
    );
    return user;
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

  // // get brews stream
  // Stream<List<Brew>> get brews {
  //   return eventCollection.snapshots()
  //     .map(_brewListFromSnapshot);
  // }

  // // get user doc stream
  // Stream<UserData> get userData {
  //   return eventCollection.doc(uid).snapshots()
  //     .map(_userDataFromSnapshot);
  // }

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
}
