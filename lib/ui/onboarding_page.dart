import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/helper/colors.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/ui/common/custom_button.dart';

import '../helper/shared_prefs.dart';
import '../services/onboarding_service.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.read(sharedPrefsProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "once",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Focus on the ",
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: CustomColors.darkColor,
                          ),
                        ),
                        TextSpan(
                          text: "one important thing ",
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: CustomColors.darkColor,
                          ),
                        ),
                        TextSpan(
                          text: "that will make your day a good day. ☀️",
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: CustomColors.darkColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              onPressed: () {
                prefs.setFinishedOnboarding(true).then((value) {
                  ref.read(onboardingProvider.notifier).state = true;
                });
              },
              label: "Let's get started",
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingItem extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String image;
  final String description;

  OnboardingItem(this.title, this.titleColor, this.image, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Image.asset(
            image,
            scale: 2.0,
          )),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
