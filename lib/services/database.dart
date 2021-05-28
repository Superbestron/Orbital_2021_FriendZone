import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference to all events
  final CollectionReference eventCollection =
    FirebaseFirestore.instance.collection('events');

  // collection reference to user profiles
  final CollectionReference profileCollection =
  FirebaseFirestore.instance.collection('profiles');

  // TODO: Decide on what info to store about an event
  Future updateEventData(String name, String date, String time
      , int pax, String description, int icon) async {
    return await eventCollection.doc(uid).set({
      'name': name,
      'date': date,
      'time' : time,
      'pax': pax,
      'description': description,
      'icon': icon,
    });
  }

  // TODO: Decide on what info to store about user
  Future updateUserData(String name, int level, String faculty,
      int points, String bio) async {
    return await profileCollection.doc(uid).set({
      'name': name,
      'level': level,
      'faculty': faculty,
      'points': points,
      'bio': bio,
    });
  }

  // brew list from snapshot
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
        name: doc.get('name') ?? '',
        date: doc.get('date') ?? '',
        time: doc.get('time') ?? '',
        pax: doc.get('pax') ?? 1,
        description: doc.get('description') ?? '',
        icon: doc.get('icon') ?? 0,
      );
    }).toList();
  }

  // userData from snapshot
  EventData _eventDataFromSnapshot(DocumentSnapshot snapshot) {
    return EventData(
      uid: uid,
      name: snapshot.get('name'),
      date: snapshot.get('date'),
      time: snapshot.get('time'),
      pax: snapshot.get('pax'),
      description: snapshot.get('description'),
      icon: snapshot.get('icon'),
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

  // get activity doc stream
  Stream<EventData> get eventData {
      return eventCollection.doc(uid).snapshots()
        .map(_eventDataFromSnapshot);
  }
}