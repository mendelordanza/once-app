import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;

import '../services/auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthService, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService;
});

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServiceProvider).authStateChanges());

class AuthService extends StateNotifier<AuthState> {
  AuthService() : super(AuthState.initializing()) {
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _loadCountries();
  }

  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;
  late CountryWithPhoneCode _selectedCountry;
  late String _verificationId;
  List<CountryWithPhoneCode> countries = [];

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  CountryWithPhoneCode get selectedCountry => _selectedCountry;

  String get phoneCode => _selectedCountry.phoneCode;

  Future<void> _loadCountries() async {
    try {
      await FlutterLibphonenumber().init();
      var _countries = CountryManager().countries;
      _countries.sort((a, b) {
        return a.countryName!
            .toLowerCase()
            .compareTo(b.countryName!.toLowerCase());
      });
      countries = _countries;

      final langCode = ui.window.locale.languageCode.toUpperCase();
      _firebaseAuth.setLanguageCode(langCode);

      var filteredCountries =
          countries.where((item) => item.countryCode == langCode);

      if (filteredCountries.length == 0) {
        filteredCountries = countries.where((item) => item.countryCode == 'US');
      }
      if (filteredCountries.length == 0) {
        throw Exception('Unable to find a default country!');
      }
      setCountry(filteredCountries.first);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void setCountry(CountryWithPhoneCode selectedCountry) {
    _selectedCountry = selectedCountry;
    state = AuthState.ready(selectedCountry);
  }

  Future<void> verifyPhone({
    required String inputText,
    required Function() completion,
    required Function(String) error,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: inputText,
      verificationCompleted: (AuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseException e) {
        error(e.code);
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        completion();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        completion();
      },
      timeout: Duration(seconds: 120),
    );
  }

  Future<void> verifyCode({
    required String smsCode,
    required Function() completion,
    required Function(String) error,
  }) async {
    try {
      await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: smsCode),
      );
      completion();
    } on FirebaseAuthException catch (e) {
      error(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUser({
    required Function() navigateToHome,
    required Function() navigateToAddName,
  }) async {
    await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        navigateToHome();
      } else {
        navigateToAddName();
      }
    });
  }

  Future<void> addUser({
    required String name,
    required Function() completion,
    required Function(String) error,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "userId": FirebaseAuth.instance.currentUser?.uid ?? null,
        "name": name,
      }).then((value) {
        completion();
      });
    } on FirebaseAuthException catch (e) {
      error(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
