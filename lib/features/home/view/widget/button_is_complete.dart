import 'package:flutter/material.dart';

class ButtonIsComplete extends StatelessWidget {
  const ButtonIsComplete({
    super.key,
    required this.onPressed,
    required this.isCompleted,
  });

  final void Function()? onPressed;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xff5F33E1), width: 1.0),
        ),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: isCompleted
              ? Color(0xff5F33E1)
              : Color(0xffFFFFFF),
        ),
      ),
    );
  }
}
