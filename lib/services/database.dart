import 'package:cloud_firestore/cloud_firestore.dart';
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

  // collection reference to user profiles
  final CollectionReference profileCollection =
  FirebaseFirestore.instance.collection('profiles');

  Future getEventData(String eventID) async {
    DocumentReference ref = eventCollection.doc(eventID);
    var event = await ref.get().then((snapshot) =>
      EventData(
          name: snapshot.get('name'),
          date: snapshot.get('date'),
          time: snapshot.get('time'),
          pax: snapshot.get('pax'),
          description: snapshot.get('description'),
          icon: snapshot.get('icon'),
          attendees: [],
      )
    );
    return event;
  }

  // TODO: Decide on what info to store about an event
  Future updateEventData(String name, String date, String time,
      int pax, String description, int icon, String eventID, List<dynamic> attendees) async {
    return await eventCollection.doc(eventID).set({
      'name': name,
      'date': date,
      'time' : time,
      'pax': pax,
      'description': description,
      'icon': icon,
      'eventID': eventID,
      'attendees': attendees,
    });
  }

  Future createEventData(String name, String date, String time,
      int pax, String description, int icon) async {
    String newDocID = eventCollection.doc().id;
    List<dynamic> attendees = [];
    attendees.add(uid);
    return await eventCollection.doc(newDocID).set({
      'name': name,
      'date': date,
      'time' : time,
      'pax': pax,
      'description': description,
      'icon': icon,
      'eventID': newDocID,
      'attendees': attendees,
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

  Future getUserData() async {
    DocumentReference ref = profileCollection.doc(uid);
    UserObj user = await ref.get().then((snapshot) =>
      // use snapshot.get(field_name) to add other fields easily
      UserObj (
        uid: ref.id
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
        date: doc.get('date') ?? '',
        time: doc.get('time') ?? '',
        pax: doc.get('pax') ?? 1,
        description: doc.get('description') ?? '',
        icon: doc.get('icon') ?? 0,
      );
    }).toList();
  }

  // EventData from snapshot
  EventData _eventDataFromSnapshot(DocumentSnapshot snapshot) {
    return EventData(
      // uid: uid,
      // eventID: eventID,
      name: snapshot.get('name'),
      date: snapshot.get('date'),
      time: snapshot.get('time'),
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
  Stream<EventData> eventData(String eventID){
      return eventCollection.doc(eventID).snapshots()
        .map(_eventDataFromSnapshot);
  }

  Future addUserToEvent(String eventID, String uid) async {
    EventData event = await getEventData(eventID);
    List<dynamic> newAttendees = List.from(event.attendees);
    newAttendees.add(uid);
    updateEventData(event.name, event.date, event.time, event.pax, event.description,
    event.icon, eventID, newAttendees);
  }
}
