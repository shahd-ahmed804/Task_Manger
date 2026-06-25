import 'package:flutter/material.dart';
import 'package:taskey_app/auth/widgets/text_form_feild_widget.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/core/network/result_firebase.dart';
import 'package:taskey_app/core/utils/app_asset.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import 'package:taskey_app/core/utils/valditor.dart';
import 'package:taskey_app/home/data/firebase/firebase_task.dart';
import 'package:taskey_app/home/data/model/task_model.dart';
import 'package:taskey_app/home/widget/buttom_is_complete.dart';
import 'package:taskey_app/home/widget/priority_widget.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = 'EditScreen';
  final TaskModel task;
  const EditScreen({super.key, required this.task});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late int selectedPriority;
  late bool isComplete;
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    selectedDate = widget.task.selectedDate ?? DateTime.now();
    selectedPriority = widget.task.priorityIndex ?? 1;
    isComplete = widget.task.isCompleted ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xffE1E0E3),
                ),
                padding: EdgeInsets.all(9),
                child: Icon(Icons.close, color: Color(0xffFC0C0C)),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 11,
              children: [
                ButtomIsComplete(
                  onPressed: () {
                    isComplete = !isComplete;
                    setState(() {});
                  },
                  isCompleted: isComplete,
                ),
                Column(
                  spacing: 18,
                  children: [
                    Text(
                      titleController.text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff24252C),
                      ),
                    ),
                    Text(
                      descriptionController.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6E6A7C),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _showEditTitleDescriptionDialog(),
                  child: Icon(Icons.edit),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Image.asset(AppAsset.timerIcon),
                Text(
                  'Task Time:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff24252C),
                  ),
                ),

                Spacer(),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      firstDate: DateTime.now(),
                      lastDate: now.add(Duration(days: 30)),
                      initialDate: selectedDate,
                      context: context,
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffE1E0E3)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _formateDate(selectedDate) == _formateDate(now)
                          ? 'Today'
                          : _formateDate(selectedDate) ==
                                _formateDate(now.add(Duration(days: 1)))
                          ? 'Tomorrow'
                          : _formateDate(selectedDate),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Image.asset(AppAsset.flagIcon),
                Text(
                  'Task Priority:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff24252C),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PriorityWidget(
                        initialPriority: selectedPriority,
                        onTap: (index) {
                          selectedPriority = index;
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Color(0xffE1E0E3)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: selectedPriority == 1
                        ? Text('Default')
                        : Row(
                            spacing: 5,
                            children: [
                              Image.asset(AppAsset.flagIcon),
                              Text(selectedPriority.toString()),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () =>
                  AppDialog.showMessageAccespt(context,widget.task, onDeleteButtom,),
              //  AppDialog.showMessageAccespt(context, onDelete),
              child: Row(
                spacing: 8,
                children: [
                  Image.asset(AppAsset.trachIcon),
                  Text(
                    'Delete Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFF5454),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 28),
        child: MaterialButton(
          onPressed: () {
            _updateTask();
            Navigator.of(context).pop();
          },
          color: themeColor,
          minWidth: double.infinity,
          height: 48,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  void onDeleteButtom() async {
    AppDialog.showLoading(context);
    final result = await FirebaseTask.deleteTask(widget.task);
    Navigator.of(context).pop();
    if (result is SuccessFB) {
      Navigator.of(context).pop();
    } else if (result is ErrorFB) {
      AppDialog.showError(context, error: result.messageError);
    }
    Navigator.of(context).pop();
  }

  String _formateDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditTitleDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final taskName = TextEditingController(text: titleController.text);
        final description = TextEditingController(
          text: descriptionController.text,
        );

        return AlertDialog(
          title: Text('Edit Task Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormFieldWidget(
                controller: taskName,
                hintText: 'Enter task name',
                validator: Validator.validateName,
              ),
              SizedBox(height: 10),
              TextFormFieldWidget(
                controller: description,
                hintText: 'Description',
                validator: Validator.validateName,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                titleController.text = taskName.text;
                descriptionController.text = description.text;
                setState(() {});

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateTask() async {
    final updatedTask = TaskModel(
      id: widget.task.id,
      title: titleController.text,
      description: descriptionController.text,
      selectedDate: selectedDate,
      priorityIndex: selectedPriority,
      isCompleted: isComplete,
    );

    AppDialog.showLoading(context);
    final result = await FirebaseTask.updateTask(updatedTask);
    Navigator.of(context).pop();
    if (result is SuccessFB) {
    } else if (result is ErrorFB) {
      AppDialog.showError(context, error: result.messageError);
    }
  }
}
