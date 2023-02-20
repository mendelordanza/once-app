import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:once/repo/firebase_auth_repo.dart';

import '../helper/shared_prefs.dart';

class ProfilePage extends ConsumerWidget {
  // Future<void> _launchUrl(String url) async {
  //   final Uri _url = Uri.parse(url);
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: 'Nunito'),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {

                        },
                        child: SettingItem(
                            icon: "assets/icons/ic_airplane.svg",
                            label: "Remind me to add a new task every..."),
                      ),
                      TextButton(
                        onPressed: () {

                        },
                        child: SettingItem(
                            icon: "assets/icons/ic_airplane.svg",
                            label: "Feature requests"),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final prefs = ref.read(sharedPrefsProvider);
                      await auth.signOut().then((value) async {
                        prefs.clear();
                        FirebaseMessaging.instance.deleteToken();
                        Navigator.pop(context);
                      });
                    },
                    child: SettingItem(
                      icon: "assets/icons/ic_logout.svg",
                      label: "Logout",
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String icon;
  final String label;

  SettingItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: SvgPicture.asset(
                icon,
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(
              text: "   $label",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito',
                color: Color(0xFF3F3F3F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
