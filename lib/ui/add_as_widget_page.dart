import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Item {
  final String icon;
  final String description;

  Item(this.icon, this.description);
}

class AddAsWidgetPage extends StatelessWidget {
  final list = [
    Item("assets/images/Widget1.svg", "Hold down on any app to edit Home Screen"),
    Item("assets/images/Widget2.svg",
        "Tap the add button on the upper left corner"),
    Item("assets/images/Widget3.svg", "Search or look for Once app"),
    Item("assets/images/Widget4.svg", "Add Once as a widget"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
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
            children: [
              Text(
                "Add as widget",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return PageItem(item);
                  },
                  itemCount: list.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final Item item;

  PageItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SvgPicture.asset(item.icon),
        )),
        Text(
          item.description,
          style: TextStyle(
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
