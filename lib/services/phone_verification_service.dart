import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/services/sign_in_state.dart';

import '../repo/firebase_auth_repo.dart';

final signInPhoneModelProvider =
    StateNotifierProvider.autoDispose<SignInPhoneModel, SignInState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SignInPhoneModel(
    authService: authService,
  );
});

class SignInPhoneModel extends StateNotifier<SignInState> {
  SignInPhoneModel({
    required this.authService,
  }) : super(const SignInState.notValid());

  AuthService authService;

  Future<void> verifyPhone(String inputText) async {
    state = SignInState.loading();
    try {
      authService.verifyPhone(
        inputText: inputText,
        completion: () {
          state = SignInState.success();
        },
        error: (error) {
          state = SignInState.error(error);
        },
      );
    } catch (e) {
      state = SignInState.error(e.toString());
    }
  }
}
