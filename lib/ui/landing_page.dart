import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:once/repo/firebase_auth_repo.dart';

import '../helper/shared_prefs.dart';
import '../models/push_notification_model.dart';
import '../repo/firestore_repo.dart';
import '../services/onboarding_service.dart';
import 'common/platform_progress_indicator.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'onboarding_page.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class LandingPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  PushNotificationModel? _notificationInfo;

  void requestAndRegisterNotification() async {
    final database = ref.read(firebaseRepoProvider);
    FirebaseMessaging.instance.requestPermission();

    // 2. Instantiate Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    NotificationSettings settingsStatus =
        await _messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settingsStatus.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _messaging.getToken();
      print("The token is " + token!);

      //Subscribe to topic
      _messaging.subscribeToTopic("challenges");

      //Save FCM to db
      database.addFCM(fcmToken: token);

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // final challengeData = jsonDecode(message.data["challenge"]);
        // if (message.data["type"] == notif_expired_challenge) {
        //   //Foreground notif
        //   floatingDialog(
        //     message: message,
        //     onClick: () => {
        //       Navigator.popAndPushNamed(
        //         context,
        //         message.data["screen"],
        //         arguments: ChallengeModel(
        //           id: message.data["challengeId"],
        //           challengeMakerId: challengeData["challengeMakerId"],
        //           firstName: challengeData["firstName"],
        //           lastName: challengeData["lastName"],
        //           description: challengeData["description"],
        //           reward: challengeData["reward"],
        //           isExpired: challengeData["isExpired"],
        //         ),
        //       ),
        //     },
        //   );
        // } else if ((message.data["type"] == notif_new_challenge ||
        //     message.data["type"] == notif_challenge_winner) &&
        //     challengeData["challengeMakerId"] !=
        //         FirebaseAuth.instance.currentUser!.uid) {
        //   //Foreground notif
        //   floatingDialog(
        //     message: message,
        //     onClick: () => {
        //       Navigator.popAndPushNamed(
        //         context,
        //         message.data["screen"],
        //         arguments: ChallengeModel(
        //           id: message.data["challengeId"],
        //           challengeMakerId: challengeData["challengeMakerId"],
        //           firstName: challengeData["firstName"],
        //           lastName: challengeData["lastName"],
        //           description: challengeData["description"],
        //           reward: challengeData["reward"],
        //           isExpired: challengeData["isExpired"],
        //         ),
        //       )
        //     },
        //   );
        // }

        // Parse the message received
        PushNotificationModel notification = PushNotificationModel(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          print("NOTIF ${_notificationInfo!.title!}");
          // showSimpleNotification(
          //   Text(_notificationInfo!.title!),
          //   leading: NotificationBadge(totalNotifications: _totalNotifications),
          //   subtitle: Text(_notificationInfo!.body!),
          //   background: Colors.cyan.shade700,
          //   duration: Duration(seconds: 2),
          // );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<bool?> finishedOnboarding() async {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getFinishedOnboarding();
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        requestAndRegisterNotification();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);
    final isFinishedOnboarding = ref.watch(onboardingProvider);
    if (isFinishedOnboarding) {
      return authState.when(
          data: (data) {
            if (data != null) {
              return HomePage();
            }
            return LoginPage();
          },
          loading: () => PlatformProgressIndicator(),
          error: (e, trace) => Text("Something went wrong."));
    } else {
      return OnboardingPage();
    }
  }
}
