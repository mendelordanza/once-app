import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/repo/firebase_auth_repo.dart';
import 'package:once/ui/common/custom_button.dart';
import 'package:once/ui/common/custom_text_field.dart';
import 'package:once/ui/common/platform_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/country_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final numberTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _openVerification(
      BuildContext context, String phoneNumber) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(
      RouteStrings.code,
      arguments: phoneNumber,
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryCode = ref.watch(selectedCountryProvider);
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
                    Form(
                      key: formKey,
                      child: CustomTextField(
                        controller: numberTextController,
                        textInputType: TextInputType.emailAddress,
                        prefix: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RouteStrings.countries);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "+${countryCode?.phoneCode}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Number is required';
                          }
                          if (value.endsWith("invalid-phone-number")) {
                            return 'Invalid phone number';
                          }
                          if (value.endsWith("error")) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "By tapping Continue, you are agreeing to our ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        TextSpan(
                          text: "Terms of Service",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl(
                                  "https://absorbed-spleen-fff.notion.site/Once-App-Terms-and-Conditions-2bb6c9bd2083464789055b1eff987b1c");
                            },
                        ),
                        const TextSpan(
                          text: " and ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Nunito',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl(
                                  "https://absorbed-spleen-fff.notion.site/Once-App-Privacy-Policy-6885ea59b4d84f2ba963af7f48d56e62");
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!_isLoading)
                    CustomButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            ref.read(authServiceProvider).verifyPhone(
                                  inputText:
                                      "+${countryCode?.phoneCode}${numberTextController.text}",
                                  completion: () {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _openVerification(
                                      context,
                                      "+${countryCode?.phoneCode}${numberTextController.text}",
                                    );
                                  },
                                  error: (error) {
                                    var realNumber = "";
                                    if (error is String) {
                                      realNumber = numberTextController.text;
                                      if (error
                                          .contains("invalid-phone-number")) {
                                        numberTextController.text =
                                            "${numberTextController.text}invalid-phone-number";
                                      } else {
                                        numberTextController.text =
                                            "${numberTextController.text}error";
                                      }
                                      formKey.currentState!.validate();
                                      numberTextController.text = realNumber;
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
