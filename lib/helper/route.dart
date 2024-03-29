import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:once/helper/route_strings.dart';
import 'package:once/ui/add_as_widget_page.dart';
import 'package:once/ui/code_page.dart';
import 'package:once/ui/name_page.dart';
import 'package:once/ui/profile_page.dart';

import '../ui/countries_page.dart';
import '../ui/landing_page.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteStrings.landing:
        return _navigate(builder: (_) => LandingPage());
      case RouteStrings.code:
        if (args is String) {
          return _navigate(
            builder: (_) => CodePage(args),
          );
        } else {
          return _errorRoute();
        }
      case RouteStrings.countries:
        return _navigate(builder: (_) => CountriesPage());
      case RouteStrings.addAsWidget:
        return _navigate(builder: (_) => AddAsWidgetPage());
      case RouteStrings.name:
        return _navigate(builder: (_) => NamePage());
      case RouteStrings.profile:
        return _navigate(builder: (_) => ProfilePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic>? _navigate({required WidgetBuilder builder}) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(builder: builder);
    } else {
      return CupertinoPageRoute(builder: builder);
    }
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Text("Something went wrong."),
        ),
      ),
    );
  }
}
