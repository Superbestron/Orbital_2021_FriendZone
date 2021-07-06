import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user.dart';

import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserObj? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    } else {
      return UserObj(uid: user.uid);
    }
  }

  // auth change user stream
  Stream<UserObj?> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
  }

  String get userUid {
    return _auth.currentUser!.uid;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('${_auth.currentUser!.displayName} has signed in!');
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        return 'Email is invalid.';
      } else if (e.code == 'network-request-failed') {
        return 'Could not connect to server.';
      } else {
        return e.code;
      }
    } catch (e) {
      print(e.toString());
      return 'Unknown Error';
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String fullName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      user.updateProfile(displayName: fullName);

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('', fullName, 1, '', 0, '', [], [], [], []);
      return '';

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'network-request-failed') {
        return 'Could not connect to server.';
      } else {
        return e.code;
      }
    } catch (e) {
      print(e.toString());
      return 'Unknown Error';
    }
  }

  Future updateDisplayName(String displayName) async {
    await _auth.currentUser!.updateProfile(displayName: displayName);
    print(_auth.currentUser!.displayName);
  }

  Future sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      return await user!.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  // check if email is verified
  bool checkEmailVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.emailVerified;
  }

  String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.email!;
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      print('${_auth.currentUser!.displayName} has signed out!');
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}