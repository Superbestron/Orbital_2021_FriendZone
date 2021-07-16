import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/auth.dart';
import 'package:rxdart/rxdart.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final AuthService auth = AuthService(auth: mockFirebaseAuth);

  setUp(() {});
  tearDown(() {});

  test('emit occurs', () async {
    expectLater(auth.auth.authStateChanges(), emitsInOrder([_mockUser]));
  });

  // test('create account', () async {
  //   when(
  //     mockFirebaseAuth.createUserWithEmailAndPassword(
  //       email: 'test@gmail.com', password: '123456'),
  //   ).thenAnswer((realInvocation) => null);
  //
  //   expect(await auth.registerWithEmailAndPassword('test@gmail.com', '123456', 'test'), '');
  // });

  test('create account exception', () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@gmail.com', password: '123456'),
    ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(code: 'You screwed up'));

    expect(await auth.registerWithEmailAndPassword('test@gmail.com', '123456', 'test'),
      'You screwed up');
  });

  test('sign in', () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@gmail.com', password: '123456'),
    ).thenAnswer((realInvocation) => auth.auth.signInAnonymously());

    expect(await auth.signInWithEmailAndPassword('test@gmail.com', '123456'), '');
  });

  test('sign in exception', () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@gmail.com', password: '123456'),
    ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(code: 'You screwed up'));

    expect(await auth.signInWithEmailAndPassword('test@gmail.com', '123456'),
        'You screwed up');
  });

  test('sign out', () async {
    when(mockFirebaseAuth.signOut())
      .thenAnswer((realInvocation) => auth.auth.signInAnonymously());

    expect(await auth.signOut(), '');
  });

  test('sign out exception', () async {
    when(mockFirebaseAuth.signOut())
      .thenAnswer((realInvocation) =>
        throw FirebaseAuthException(code: 'You screwed up'));

    expect(await auth.signOut(), 'You screwed up');
  });
}