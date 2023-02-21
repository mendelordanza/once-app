import 'package:flutter/material.dart';
import 'package:once/helper/colors.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String label;

  CustomButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: CustomColors.darkColor,
          padding: EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          minimumSize: Size(0.0, 50.0),
        ),
        child: Text(label),
      ),
    );
  }
}
