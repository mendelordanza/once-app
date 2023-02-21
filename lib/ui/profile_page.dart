import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:once/repo/firebase_auth_repo.dart';

import '../helper/shared_prefs.dart';
import '../services/profile_service.dart';
import 'common/platform_progress_indicator.dart';
import 'common/user_avatar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String _currentTime = "";

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final prefs = ref.read(sharedPrefsProvider);
    final currentNotifTime = prefs.getNotifDateTime();
    final time = DateTime.fromMillisecondsSinceEpoch(
      currentNotifTime ?? DateTime.now().millisecondsSinceEpoch,
    );
    _currentTime = DateFormat("hh:mm a").format(time);
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
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(builder: (context, ref, _) {
                  return ref.watch(profileAsyncController).when(
                    data: (data) {
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                UserAvatar(
                                  firstName: data.name,
                                  height: 100,
                                  width: 100,
                                  onClick: () {
                                    //TODO navigate to edit picture
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${data.name}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, stacktrace) {
                      return Text("No user found.");
                    },
                    loading: () {
                      return Center(
                        child: PlatformProgressIndicator(),
                      );
                    },
                  );
                }),
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
                    label: " Logout",
                  ),
                ),
              ],
            )),
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
              text: "$label",
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
