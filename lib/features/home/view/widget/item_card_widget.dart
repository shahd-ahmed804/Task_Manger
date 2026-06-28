import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import 'package:taskey_app/features/home/view/widget/show_priority_task.dart';

import '../../data/model/task_model.dart';
import 'button_is_complete.dart';


class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({
    super.key,
    required this.task,
    this.onPressed,
    this.onDelete,
    this.onEdit,
    required this.title,
    required this.dateTime,
    required this.priority,
    required this.isCompleted,
  });
  final String title;
  final DateTime dateTime;
  final int priority;
  final bool isCompleted;
  final TaskModel task;
  final void Function()? onPressed;
  final void Function()? onDelete;
  final void Function()? onEdit;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                AppDialog.showMessageAccespt(context, task, onDelete),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) => onEdit?.call(),
            backgroundColor: Color(0xff5F33E1),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff6A6E7C)),
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFFFFFF),
        ),
        child: Row(
          spacing: 16,
          children: [
            ButtonIsComplete(onPressed: onPressed, isCompleted: isCompleted),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff24252C),
                  ),
                ),
                Text(
                  _formateDate(dateTime),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6E6A7C),
                  ),
                ),
              ],
            ),
            Spacer(),
            ShowPriorityTask(priority: priority),
          ],
        ),
      ),
    );
  }

  String _formateDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
