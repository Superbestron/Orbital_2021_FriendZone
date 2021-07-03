import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user.dart';

import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserObj? _userFromFirebaseUser(User? user) {
    if (user == null) {
      print('User is currently signed out!');
      return null;
    } else {
      print('User is signed in!');
      return UserObj(uid: user.uid);
    }
  }

  // auth change user stream
  Stream<UserObj?> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
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
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        return 'Email is invalid.';
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

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('', fullName, 1, '', 0, '', [], [], [], []);
      return '';

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.code;
      }
    } catch (e) {
      print(e.toString());
      return 'Unknown Error';
    }
  }

  Future sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    return await user!.sendEmailVerification();
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

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}