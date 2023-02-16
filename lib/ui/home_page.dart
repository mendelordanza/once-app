import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:home_widget/home_widget.dart';
import 'package:once/helper/colors.dart';
import 'package:once/helper/shared_prefs.dart';
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
          HomeWidget.getWidgetData<String>('_counter',
                  defaultValue: 'Default Message')
              .then((value) => textController.text = value ?? ""),
        ]);
      } else {
        final data = await WidgetKit.getItem(
            '_counter', 'group.G53UVF44L3.com.ralphordanza.once');
        setState(() {
          textController.text = data as String;
        });
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

  @override
  void initState() {
    if (Platform.isAndroid) {
      HomeWidget.setAppGroupId('group.G53UVF44L3.com.ralphordanza.once');
      HomeWidget.registerBackgroundCallback(backgroundCallback);
    }
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.read(sharedPrefsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("once"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
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
                "What is one thing you want to accomplish that will make today a good day?",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: CustomColors.darkColor,
                ),
              ),
              CustomButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      updateText(textController.text);
                    } else {
                      WidgetKit.setItem('_counter', textController.text,
                          'group.G53UVF44L3.com.ralphordanza.once');
                      WidgetKit.reloadAllTimelines();
                    }
                  },
                  label: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
