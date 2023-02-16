import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserAvatar extends StatelessWidget {
  final double height;
  final double width;
  final String? avatarUrl;
  final String firstName;
  final String lastName;
  final Function()? onClick;

  UserAvatar({
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.width,
    this.avatarUrl,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (avatarUrl != null)
          ? Container(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  avatarUrl!,
                  fit: BoxFit.fill,
                  errorBuilder: (context, _, stacktrace) {
                    return Center(
                      child: SvgPicture.asset("assets/icons/ic_media.svg"),
                    );
                  },
                ),
              ),
            )
          : Container(
              width: width,
              height: height,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "${firstName[0]}${lastName[0]}",
                  style: TextStyle(
                    fontSize: width / 2,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito',
                    color: Color(0xFF3F3F3F),
                  ),
                ),
              ),
            ),
    );
  }
}
