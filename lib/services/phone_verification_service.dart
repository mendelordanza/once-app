import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/repo/firebase_auth_repo.dart';

final signInPhoneModelProvider =
    StateNotifierProvider.autoDispose<SignInPhoneModel, AsyncValue<String>>(
        (ref) {
  return SignInPhoneModel(
    ref: ref,
  );
});

class SignInPhoneModel extends StateNotifier<AsyncValue<String>> {
  SignInPhoneModel({
    required this.ref,
  }) : super(const AsyncLoading());

  final Ref ref;

  Future<void> verifyPhone({required String number}) async {
    state = AsyncLoading();
    try {
      ref.read(firebaseAuthRepoProvider).verifyPhoneNumber(
          number: number,
          completion: (verificationId) {
            state = AsyncData(verificationId);
          });
    } catch (e) {
      state = AsyncData("");
    }
  }
}
