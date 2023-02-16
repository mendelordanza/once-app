import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/services/phone_verification_service.dart';
import 'package:once/ui/common/custom_button.dart';
import 'package:once/ui/common/custom_text_field.dart';

import '../repo/firebase_auth_repo.dart';
import '../services/sign_in_state.dart';

class LoginPage extends ConsumerWidget {
  final numberTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "What's your number?",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: numberTextController,
                      label: "Number",
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "By tapping Continue, you are agreeing to our Terms of Service and Privacy Policy",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onPressed: () {
                        ref.read(firebaseAuthRepoProvider).verifyPhoneNumber(
                              number: numberTextController.text,
                              completion: (verificationId) {
                                Navigator.pushNamed(
                                  context,
                                  RouteStrings.code,
                                  arguments: verificationId,
                                );
                              },
                            );
                      },
                      label: "Continue")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
