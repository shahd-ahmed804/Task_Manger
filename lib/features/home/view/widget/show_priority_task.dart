import 'package:flutter/material.dart';
import 'package:taskey_app/core/utils/app_asset.dart';

class ShowPriorityTask extends StatelessWidget {
  const ShowPriorityTask({
    super.key,
    required this.priority,
  });

  final int priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xff24252C)),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(right: 10, bottom: 4),
      child: Row(
        spacing: 5,
        children: [
          Image.asset(AppAsset.flagIcon),
          Text(
            priority.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff24252C),
            ),
          ),
        ],
      ),
    );
  }
}
