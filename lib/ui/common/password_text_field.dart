import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  TextInputAction? textInputAction;
  String? Function(String?)? validator;

  PasswordField(
      {required this.controller, this.textInputAction, this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Password",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        SizedBox(
          height: 80,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: isPasswordHidden,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
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
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
                icon: SvgPicture.asset(
                  isPasswordHidden
                      ? 'assets/icons/ic_eye.svg'
                      : 'assets/icons/ic_closed_eye.svg',
                  height: 13.42,
                  width: 18.43,
                  fit: BoxFit.scaleDown,
                ),
              ),
              contentPadding: EdgeInsets.all(16.0),
            ),
          ),
        ),
      ],
    );
  }
}
