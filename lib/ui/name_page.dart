import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repo/firebase_auth_repo.dart';
import 'common/custom_button.dart';
import 'common/custom_text_field.dart';
import 'common/platform_progress_indicator.dart';

class NamePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<NamePage> createState() => _NamePageState();
}

class _NamePageState extends ConsumerState<NamePage> {
  final nameTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      "Once last thing\nWhat's your name?",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: CustomTextField(
                        controller: nameTextController,
                        textInputType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          if (value.endsWith("error")) {
                            return 'Error. Please try again';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isLoading)
                CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        ref.read(authServiceProvider).addUser(
                              name: nameTextController.text,
                              completion: () {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.pop(context);
                              },
                              error: (error) {
                                var realName = "";
                                if (error is String) {
                                  realName = nameTextController.text;
                                  nameTextController.text =
                                      "${nameTextController.text}error";
                                  formKey.currentState!.validate();
                                  nameTextController.text = realName;
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            );
                      }
                    },
                    label: "Continue")
              else
                Center(child: PlatformProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
