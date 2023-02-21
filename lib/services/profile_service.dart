import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/repo/firestore_repo.dart';

import '../helper/shared_prefs.dart';
import '../models/user_model.dart';

final profileAsyncController = StateNotifierProvider.autoDispose<
    ProfileAsyncNotifier,
    AsyncValue<UserModel>>((ref) => ProfileAsyncNotifier(ref));

class ProfileAsyncNotifier extends StateNotifier<AsyncValue<UserModel>> {
  ProfileAsyncNotifier(this.ref) : super(AsyncLoading()) {
    _init();
  }

  final Ref ref;

  void _init() async {
    state = AsyncLoading();
    final userData = await ref
        .read(firebaseRepoProvider)
        .getUserData(FirebaseAuth.instance.currentUser!.uid);

    //Save prefs
    ref.read(sharedPrefsProvider).setFirstName(userData.name);

    state = AsyncData(userData);
  }
}

final userDataProvider =
FutureProvider.autoDispose.family<UserModel, String>((ref, uid) async {
  return ref.read(firebaseRepoProvider).getUserData(uid);
});