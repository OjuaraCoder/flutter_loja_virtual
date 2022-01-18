import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  DocumentReference get firestoreRef => FirebaseFirestore.instance.doc('users/$uid');
  CollectionReference get cartReference => firestoreRef.collection('cart');

  String uid;
  String name;
  String email;
  bool admin = false;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory UserModel.fromDocument(DocumentSnapshot document) {
    return UserModel(
        uid: document.id,
        name: document['email'] as String,
        email: document['name'] as String
    );
  }

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  void cleanUser() {
    uid = '';
    name = '';
    email = '';
  }
}
