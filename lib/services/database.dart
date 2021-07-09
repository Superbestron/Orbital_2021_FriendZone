import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/models/event.dart';
import 'package:myapp/models/notifications.dart';
import 'package:myapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  static const MAX_DAY_FOR_PASTS_EVENTS = 30;
  static const MAX_DAY_FOR_NOTIFICATIONS = 30;

  DatabaseService({
    required this.uid,
  });

  // collection reference to all events
  static final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // collection reference to all user profiles
  static final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  // collection reference to notifications
  static final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  // storage reference to user's profile images
  static final FirebaseStorage storage = FirebaseStorage.instance;

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
  static Future getEventData(String eventID) async {
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
          eventMarked: snapshot.get('eventMarked'),
        ));
    return event;
  }

  static Future updateEventData(
      String location,
      String telegramURL,
      String name,
      DateTime dateTime,
      int pax,
      String description,
      int icon,
      String eventID,
      List<dynamic> attendees,
      bool eventMarked) async {
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
      'eventMarked': eventMarked,
    });
  }

  Future createEventData(String location, String telegramURL, String name,
      DateTime dateTime, int pax, String description, int icon) async {
    String newDocID = eventCollection.doc().id;
    List<dynamic> attendees = [];
    attendees.add(uid);
    updateEventData(location, telegramURL, name, dateTime, pax, description,
        icon, newDocID, attendees, false);
    print("Creating Event...");
    return newDocID;
  }

  // Event list from snapshot
  static List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
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
        eventMarked: doc.get('eventMarked') ?? false,
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
      eventMarked: snapshot.get('eventMarked'),
    );
  }

  // get events stream
  static Stream<List<Event>> get events {
    return eventCollection.orderBy('dateTime').snapshots().map(_eventListFromSnapshot);
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
        newAttendees,
        event.eventMarked,
    );
  }

  static Future deleteEvent(String eventID) async {
    print('Deleting event: $eventID');
    await eventCollection.doc(eventID).delete();
  }

  // Delete past events which are more than 30 days old
  static Future deleteOldEvents(List<Event> pastEvents) async {
    List<Event> list = pastEvents;
    while (list.isNotEmpty && DateTime
        .now()
        .difference(list[list.length - 1].dateTime)
        .inDays > MAX_DAY_FOR_PASTS_EVENTS) {
      Event event = list[list.length - 1];
      list.removeLast();
      deleteEvent(event.eventID);
      event.attendees.forEach((attendee) async {
        UserData user = await getUserData(attendee);
        user.events.removeWhere((eventID) => eventID == event.eventID);
        updateUserDataWithID(
            user.uid,
            user.profileImagePath,
            user.name,
            user.level,
            user.faculty,
            user.points,
            user.bio,
            user.events,
            user.notifications,
            user.friendRequests,
            user.friends);
      });
    }
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
        event.attendees,
        event.eventMarked);
  }

  // user data stream
  static Stream<List<UserData>> get users {
    return profileCollection.snapshots().map(_mapUserDataFromSnapshot);
  }

  // get profile stream
  Stream<UserData> get userData {
    return profileCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  static Future updateUserDataWithID(
      String uid,
      String profileImagePath,
      String name,
      int level,
      String faculty,
      int points,
      String bio,
      List<dynamic> events,
      List<dynamic> notifications,
      List<dynamic> friendRequests,
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
      'friendRequests': friendRequests,
      'friends': friends
    });
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
      List<dynamic> friendRequests,
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
      'friendRequests': friendRequests,
      'friends': friends
    });
  }
  static List<UserData> _mapUserDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          uid: doc.id,
          profileImagePath: doc.get('profileImagePath'),
          name: doc.get('name'),
          level: doc.get('level'),
          faculty: doc.get('faculty'),
          points: doc.get('points'),
          bio: doc.get('bio'),
          events: doc.get('events'),
          notifications: doc.get('notifications'),
          friendRequests: doc.get('friendRequests'),
          friends: doc.get('friends')
      );
    }).toList();
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
      friendRequests: snapshot.get('friendRequests'),
      friends: snapshot.get('friends')
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

  static Future getNameFromUserID(String userID) async {
    return await profileCollection
        .doc(userID)
        .get()
        .then((snapshot) => snapshot.get('name'));
  }

  // Get a random user's data based on userID
  static Future<UserData> getUserData(String userID) async {
    DocumentReference ref = profileCollection.doc(userID);
    var user = await ref.get().then((snapshot) => UserData(
          uid: userID,
          profileImagePath: snapshot.get('profileImagePath'),
          name: snapshot.get('name'),
          level: snapshot.get('level'),
          faculty: snapshot.get('faculty'),
          points: snapshot.get('points'),
          bio: snapshot.get('bio'),
          events: snapshot.get('events'),
          notifications: snapshot.get('notifications'),
          friendRequests: snapshot.get('friendRequests'),
          friends: snapshot.get('friends')
        ));
    return user;
  }

  Future acceptFriend(String friendUID) async {
    UserData myData = await getUserData(uid);
    UserData friendData = await getUserData(friendUID);
    myData.friends.add(friendUID);
    myData.friendRequests.remove(friendUID);
    friendData.friends.add(uid);
    print('Adding friend link between $uid and $friendUID...');
    await updateUserData(
        myData.profileImagePath,
        myData.name,
        myData.level,
        myData.faculty,
        myData.points,
        myData.bio,
        myData.events,
        myData.notifications,
        myData.friendRequests,
        myData.friends
    );
    await DatabaseService(uid: friendUID)
        .updateUserData(friendData.profileImagePath, friendData.name,
        friendData.level, friendData.faculty, friendData.points, friendData.bio,
        friendData.events, friendData.notifications, friendData.friendRequests,
        friendData.friends);
  }

  Future addFriend(String friendUID) async {
    UserData friendData = await getUserData(friendUID);
    friendData.friendRequests.add(uid);
    print('Adding friend $friendUID...');
    await DatabaseService(uid: friendUID)
        .updateUserData(friendData.profileImagePath, friendData.name,
        friendData.level, friendData.faculty, friendData.points, friendData.bio,
        friendData.events, friendData.notifications, friendData.friendRequests,
        friendData.friends);
  }


  /// Notifications
  static Future getNotificationObj(String notificationID) async {
    DocumentReference ref = notificationsCollection.doc(notificationID);
    var notificationObj = await ref.get().then((snapshot) => NotificationObj(
          title: snapshot.get('title'),
          subtitle: snapshot.get('subtitle'),
          type: snapshot.get('type'),
          additionalInfo: snapshot.get('additionalInfo'),
          expireAt: snapshot.get('expireAt').toDate(),
          subscribed: snapshot.get('subscribed')
        ));
    return notificationObj;
  }

  // Main mechanism to send notification to user
  Future sendNotificationToUser(String notificationID, String otherUserID,
      bool friendAccepted) async {
    print('Sending Notification to: $otherUserID');
    UserData otherUser = await getUserData(otherUserID);
    List notifications = otherUser.notifications;
    notifications.add(notificationID);
    await DatabaseService(uid: otherUserID)
        .updateUserData(otherUser.profileImagePath, otherUser.name, otherUser.level,
        otherUser.faculty, otherUser.points, otherUser.bio, otherUser.events,
        notifications, otherUser.friendRequests, otherUser.friends);
  }

  // Adds a new event notification to database
  Future sendEventNotification(String title, String subtitle, String type,
      DateTime eventTime, Map additionalInfo, List<dynamic> attendees) async {
    if (attendees.isEmpty) return;
    String newDocID = notificationsCollection.doc().id;
    await notificationsCollection.doc(newDocID).set({
      'title': title,
      'subtitle': subtitle,
      'type': type,
      'additionalInfo': additionalInfo,
      'expireAt': eventTime,
      'subscribed': attendees
    });
    for (String attendee in attendees) {
      sendNotificationToUser(newDocID, attendee, false);
    }
  }

  // Adds a new friend notification to database
  Future sendFriendNotification(String action, String from, String to) async {
    UserData fromUser = await getUserData(from);
    bool friendAccepted = false;
    if (action == "Accepted your friend request!") {
      friendAccepted = true;
    }
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
      'expireAt': DateTime(2025), // WILL NOT EXPIRE
      'subscribed': [to]
    });
    sendNotificationToUser(newDocID, to, friendAccepted);
  }

  // Update notification settings on user's side only
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
      friendRequests: snapshot.get('friendRequests'),
      friends: snapshot.get('friends')
    ));
    await updateUserData(user.profileImagePath, user.name, user.level,
        user.faculty, user.points, user.bio, user.events, user.notifications,
        user.friendRequests, user.friends);
  }

  static Future deleteNotifications(List<dynamic> notificationIDs) async {
    List<dynamic> list = notificationIDs;
    while (list.isNotEmpty) {
      dynamic notificationID = list[list.length - 1];
      NotificationObj notification = await getNotificationObj(notificationID);
       if (notification.expireAt.isBefore(DateTime.now())) {
         print('Deleting notification: $notificationID');
         await notificationsCollection.doc(notificationID).delete();
         notification.subscribed.forEach((subscriber) async {
            UserData user = await getUserData(subscriber);
            user.notifications.removeWhere((id) => id == notificationID);
            await updateUserDataWithID(
                user.uid,
                user.profileImagePath,
                user.name,
                user.level,
                user.faculty,
                user.points,
                user.bio,
                user.events,
                user.notifications,
                user.friendRequests,
                user.friends);
         });
         list.removeLast();
      }
    }
  }

  // ONLY for notifications of type 'friend_notification'
  static Future makeNotificationExpire(dynamic notificationID, bool toExpire) async {
    NotificationObj notification = await getNotificationObj(notificationID);
    if (notification.type != 'friend_notification') {
      return;
    }
    print('here');
    notificationsCollection.doc(notificationID).set({
      'title': notification.title,
      'subtitle': notification.subtitle,
      'type': notification.type,
      'additionalInfo': notification.additionalInfo,
      'expireAt': toExpire
        ? DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour + 1) // Give 1h buffer before being deleted
        : DateTime(2025),
      'subscribed': notification.subscribed
    });
  }

  static Future<bool> isAttendanceMarked(String eventID) async {
    return getEventData(eventID).then((event) => event.eventMarked);
  }

  static Future<bool> userDidAttend(String uid, String eventID) async {
    UserData user = await getUserData(uid);
    return user.events.contains(eventID);
  }

  static void addEventToProfile(String uid, String eventID) async {
    UserData user = await getUserData(uid);
    if (!await userDidAttend(uid, eventID)) {
      List events = user.events;
      events.add(eventID);
      updateUserDataWithID(uid, user.profileImagePath, user.name,
          user.level, user.faculty, user.points, user.bio, events,
          user.notifications, user.friendRequests, user.friends);
    }
  }

  static void removeEventFromProfile(String uid, String eventID) async {
    UserData user = await getUserData(uid);
    if (await userDidAttend(uid, eventID)) {
      List events = user.events;
      events.remove(eventID);
      updateUserDataWithID(uid, user.profileImagePath, user.name,
      user.level, user.faculty, user.points, user.bio, events,
      user.notifications, user.friendRequests, user.friends);
    }
  }

  static void setEventAttendanceMarked(String eventID) async {
    Event event = await getEventData(eventID);
    updateEventData(event.location, event.telegramURL, event.name,
        event.dateTime, event.pax, event.description, event.icon,
        eventID, event.attendees, true);
  }

  static void markAttendance(String uid, String eventID, bool attendance, int add, int minus) async {
    if (await isAttendanceMarked(eventID)) {
      if (await userDidAttend(uid, eventID) && !attendance) {
        // recorded as attended initially but now absent
        addPointsToUser(uid, minus-add);
        removeEventFromProfile(uid, eventID);
      }
      if (!await userDidAttend(uid, eventID) && attendance) {
        // recorded as absent initially but now attended
        addPointsToUser(uid, add-minus);
        addEventToProfile(uid, eventID);
      }
    } else {
      setEventAttendanceMarked(eventID);
      // first time marking attendance
      addPointsToUser(uid, attendance ? add : minus);
      // set attendance to marked
      if (attendance) {
        addEventToProfile(uid, eventID);
      }
    }
  }

  static Future addPointsToUser(String uid, int points) async {
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
        notifications: snapshot.get('notifications'),
        friendRequests: snapshot.get('friendRequests'),
        friends: snapshot.get('friends')
    ));
    points = user.points + points;
    return await updateUserDataWithID(user.uid, user.profileImagePath, user.name, pointsToLevel(points),
        user.faculty,points, user.bio, user.events, user.notifications,
        user.friendRequests, user.friends);
  }

  static int pointsToLevel(int points) {
    // using cube root because bijectivity
    return 1 + pow(points, 1/3).floor();
  }

  Future saveDeviceToken() async {
    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      DocumentReference tokenRef = profileCollection
        .doc(uid)
        .collection('tokens')
        .doc(fcmToken);

      await tokenRef.set({
        'token': fcmToken
      });
    }
  }
}
