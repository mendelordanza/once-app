import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthRepoProvider =
    Provider<FirebaseAuthRepo>((ref) => FirebaseAuthRepo());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(firebaseAuthRepoProvider).authStateChange;
});

class FirebaseAuthRepo {
  // For Authentication related functions you need an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => _auth.authStateChanges();

  verifyPhoneNumber(
      {required String number, required Function(String) completion}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (Platform.isAndroid) {
          await _auth.signInWithCredential(credential);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        completion(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  signInWithCredential({
    required String verificationId,
    required String phoneNumber,
    required String code,
    required Function(UserCredential credential) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      final credential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code),
      );
      addUser(
        uid: credential.user!.uid,
        number: phoneNumber,
      );
      onSuccess(credential);
    } on FirebaseAuthException catch (e) {
      onError(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // addUser(
      //   uid: credential.user!.uid,
      //   email: email,
      //   firstName: firstName,
      //   lastName: lastName,
      // );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error("weak-password");
        // return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return Future.error("email-already-in-use");
        //return "The account already exists for that email. Please use a different email";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser({
    required String uid,
    required String number,
  }) {
    CollectionReference users = _firestore.collection('users');
    return users
        .doc(uid)
        .set({
          'number': number,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error("user-not-found");
      } else if (e.code == 'wrong-password') {
        return Future.error("wrong-password");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    return await _auth.signOut();
  }
}
