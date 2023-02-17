import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/services/sign_in_state.dart';

import '../repo/firebase_auth_repo.dart';

final signInVerificationModelProvider =
    StateNotifierProvider.autoDispose<SignInVerificationModel, SignInState>(
        (ref) {
  final authService = ref.watch(authServiceProvider);
  return SignInVerificationModel(
    authService: authService,
  );
});

final countdownProvider = StreamProvider.autoDispose<int>((ref) {
  final signInVerificationModel =
      ref.watch(signInVerificationModelProvider.notifier);
  return signInVerificationModel.countdown.stream;
});

final delayBeforeUserCanRequestNewCode = 30;

class SignInVerificationModel extends StateNotifier<SignInState> {
  SignInVerificationModel({
    required this.authService,
  }) : super(const SignInState.notValid()) {
    _startTimer();
  }

  final AuthService authService;

  late Timer _timer;
  StreamController<int> countdown = StreamController<int>();
  late int _countdown;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown = delayBeforeUserCanRequestNewCode;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_countdown == 0) {
          timer.cancel();
        } else {
          _countdown--;
          countdown.add(_countdown);
        }
      },
    );
  }

  void resendCode(String inputText) {
    state = SignInState.loading();
    try {
      authService.verifyPhone(
        inputText: inputText,
        completion: () {
          state = SignInState.canSubmit();
          _startTimer();
        },
        error: (error) {
          if (error == "invalid-number") {
            state = SignInState.error("Invalid number");
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      state = SignInState.error(e.message ?? "Something went wrong");
    }
  }

  Future<void> verifyCode(String smsCode) async {
    state = SignInState.loading();
    try {
      await authService.verifyCode(
          smsCode: smsCode,
          completion: () {
            state = SignInState.success();
          },
          error: (error) {
            if (error == "invalid-verification-code") {
              state = SignInState.error("Invalid verification code!");
            } else {
              state = SignInState.error("Error. Please try again");
            }
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        state = SignInState.error("Invalid verification code!");
      } else {
        state = SignInState.error(e.message ?? "");
      }
    }
  }
}
