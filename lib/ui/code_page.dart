import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/repo/firebase_auth_repo.dart';
import 'package:once/ui/common/custom_button.dart';
import 'package:pinput/pinput.dart';

class CodePage extends ConsumerWidget {
  final String verificationId;
  final pinTextController = TextEditingController();

  CodePage({
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enter 6 digit code"),
                    Pinput(
                      controller: pinTextController,
                      length: 6,
                      onCompleted: (pin) => print(pin),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () {
                  ref.read(firebaseAuthRepoProvider).signInWithCredential(
                        phoneNumber: "+639123456789",
                        verificationId: verificationId,
                        code: pinTextController.text,
                        onSuccess: (credential) {
                          Navigator.pop(context);
                        },
                        onError: (error) {
                          print("ERROR $error");
                        },
                      );
                  print(pinTextController.text);
                },
                label: "Submit",
              )
            ],
          ),
        ),
      ),
    );
  }
}
