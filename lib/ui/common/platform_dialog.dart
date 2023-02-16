import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:once/ui/common/platform_progress_indicator.dart';

class PlatformDialog extends StatelessWidget {
  final String label;

  PlatformDialog(this.label);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label),
              PlatformProgressIndicator(),
            ],
          ),
        ),
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(label),
        content: Center(child: PlatformProgressIndicator()),
      );
    }
  }
}
