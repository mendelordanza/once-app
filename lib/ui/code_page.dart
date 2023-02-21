import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/services/verification_service.dart';
import 'package:once/ui/common/custom_button.dart';
import 'package:once/ui/common/platform_progress_indicator.dart';

import '../repo/firebase_auth_repo.dart';
import 'common/custom_text_field.dart';

class CodePage extends ConsumerStatefulWidget {
  final String phoneNumber;

  CodePage(this.phoneNumber);

  @override
  ConsumerState<CodePage> createState() => _CodePageState();
}

class _CodePageState extends ConsumerState<CodePage> {
  final pinTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final countdown = ref.watch(countdownProvider).value ?? 30;
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
                    Text(
                      "Verify your number",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller: pinTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Code is required';
                          }
                          if (value.endsWith("invalid-code")) {
                            return 'Invalid code';
                          }
                          if (value.endsWith("error")) {
                            return 'Error. Please try again';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text("Enter 6-digit code sent to ${widget.phoneNumber}"),
                    if (countdown == 0)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Didn't receive the code? "),
                            TextSpan(text: "Resend Code"),
                          ],
                        ),
                      )
                    else
                      Text("$countdown"),
                  ],
                ),
              ),
              if (!_isLoading)
                CustomButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    ref.read(authServiceProvider).verifyCode(
                          smsCode: pinTextController.text,
                          completion: () {
                            setState(() {
                              _isLoading = false;
                            });
                            ref.read(authServiceProvider).getUser(
                                navigateToHome: () {
                              Navigator.pop(context);
                            }, navigateToAddName: () {
                              Navigator.popAndPushNamed(
                                  context, RouteStrings.name);
                            });
                          },
                          error: (error) {
                            var realCode = "";
                            if (error is String) {
                              realCode = pinTextController.text;
                              if (error.contains("invalid-code")) {
                                pinTextController.text =
                                    "${pinTextController.text}invalid-code";
                              } else {
                                pinTextController.text =
                                    "${pinTextController.text}error";
                              }
                              _formKey.currentState!.validate();
                              pinTextController.text = realCode;
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        );
                    print(pinTextController.text);
                  },
                  label: "Submit",
                )
              else
                Center(
                  child: PlatformProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
