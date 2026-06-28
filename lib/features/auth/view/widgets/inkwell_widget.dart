import 'package:flutter/material.dart';
import 'package:taskey_app/const.dart';

class InKWellWidget extends StatelessWidget {
  const InKWellWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.routePath,
  });
  final String title;
  final String subTitle;
  final String routePath;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(routePath);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: themeColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
