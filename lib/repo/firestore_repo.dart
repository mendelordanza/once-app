import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/models/todo_model.dart';

import '../models/user_model.dart';

class FirestoreDatabase {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Create an instance of Firebase Firestore.
  late CollectionReference<Map<String, dynamic>>
      _challenges; // this holds a refernece to the Challenge collection in our firestore.
  late CollectionReference<Map<String, dynamic>>
      _entries; // this holds a refernece to the Challenge collection in our firestore.

  Stream get allChallenges => _firestore
      .collection("challenges")
      .where('challengeMakerId',
          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  Future<UserModel> getUserData(String uid) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(uid).get();
    UserModel data = UserModel.fromJson(docSnapshot.id, docSnapshot.data()!);
    return data;
  }

  //Add a todo
  Future<bool> addTodo(TodoModel todo) async {
    _challenges = _firestore.collection('todos');
    try {
      await _challenges.add(todo.toJson());
      return true; // finally return true
    } catch (e) {
      return Future.error(e); // return error
    }
  }

  addFCM({required String fcmToken}) async {
    var collection = _firestore.collection('users');
    await collection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"fcmToken": fcmToken})
        .then((value) {})
        .catchError((error) => print("Failed to add fcm token: $error"));
  }
}

final firebaseRepoProvider =
    Provider<FirestoreDatabase>((ref) => FirestoreDatabase());
