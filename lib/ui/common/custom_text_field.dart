import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String? label;
  TextInputAction? textInputAction;
  String? hintText;
  String? Function(String?)? validator;
  Widget? prefix;

  CustomTextField({
    required this.controller,
    this.label,
    this.textInputAction,
    this.hintText,
    this.validator,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if(label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.emailAddress,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF477EC3), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC62F3A), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC62F3A), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16.0),
            prefix: prefix,
          ),
        ),
      ],
    );
  }
}
