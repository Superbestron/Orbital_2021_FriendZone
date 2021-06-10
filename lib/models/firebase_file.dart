import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFile {
  final String location;
  final String url;
  final DocumentReference reference;

  const FirebaseFile({
    required this.location,
    required this.url,
    required this.reference,
  });
}