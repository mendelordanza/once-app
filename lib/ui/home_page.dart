import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:once/helper/colors.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/helper/shared_prefs.dart';
import 'package:once/repo/firebase_auth_repo.dart';
import 'package:once/ui/common/custom_button.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final textController = TextEditingController();

  Future<void> backgroundCallback(Uri? uri) async {
    await HomeWidget.saveWidgetData<String>('_counter', textController.text);
    await HomeWidget.updateWidget(
        //this must the class name used in .Kt
        name: 'HomeWidgetExampleProvider',
        iOSName: 'OnceWidgetExtension');
  }

  _loadData() async {
    try {
      if (Platform.isAndroid) {
        Future.wait([
          HomeWidget.getWidgetData<String>('_counter', defaultValue: '')
              .then((value) => textController.text = value ?? ""),
        ]);
      } else {
        final data = await WidgetKit.getItem(
            '_counter', 'group.G53UVF44L3.com.ralphordanza.once');
        if (data != null) {
          setState(() {
            textController.text = data as String;
          });
        }
      }
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  updateText(String newText) async {
    try {
      await HomeWidget.saveWidgetData<String>('_counter', newText);
      await HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'OnceWidgetExtension');
    } on PlatformException catch (exception) {
      print('Error Updating Widget. $exception');
    }
  }

  _setUserId() async {
    //SET USER ID
    await FirebaseAnalytics.instance
        .setUserId(id: FirebaseAuth.instance.currentUser?.uid);
  }

  @override
  void initState() {
    if (Platform.isAndroid) {
      HomeWidget.setAppGroupId('group.G53UVF44L3.com.ralphordanza.once');
      HomeWidget.registerBackgroundCallback(backgroundCallback);
    }
    _loadData();
    _setUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider);
    final prefs = ref.read(sharedPrefsProvider);
    final currentDate = DateFormat("MMM dd, yyyy").format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text("Once"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // auth.signOut().then((value) {
              //   prefs.clear();
              // });
              Navigator.pushNamed(context, RouteStrings.profile);
            },
            icon: SvgPicture.asset("assets/icons/ic_person.svg"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24.0,
            0.0,
            24.0,
            24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "What is the one thing you need to accomplish that will make today a good day?",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                currentDate,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "eg. write the 1st chapter of my book"),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: CustomColors.darkColor,
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteStrings.addAsWidget);
                },
                child: Text(
                  "How to add widget",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: CustomColors.backgroundColor,
                  side: BorderSide(width: 1.0),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(0.0, 50.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      updateText(textController.text);
                    } else {
                      WidgetKit.setItem('_counter', textController.text,
                          'group.G53UVF44L3.com.ralphordanza.once');
                      WidgetKit.reloadAllTimelines();
                    }

                    Flushbar(
                      message: "Task saved!",
                      margin: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      duration: Duration(seconds: 2),
                    ).show(context);

                    //LOG EVENT
                    await FirebaseAnalytics.instance
                        .logEvent(name: "added_task");
                  },
                  label: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
