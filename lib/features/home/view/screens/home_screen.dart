import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:taskey_app/core/network/result_firebase.dart';
import 'package:taskey_app/core/utils/app_asset.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import '../../data/firebase/firebase_task.dart';
import '../../data/model/task_model.dart';
import '../widget/item_card_widget.dart';
import '../widget/show_button_sheet_task.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<TaskModel> pendingTasks = [];
  List<TaskModel> completedTasks = [];
  DateTime _selectedValue = DateTime.now();
  @override
  void initState() {
    isLoading = true;
    super.initState();
    getTask(_selectedValue);
  }
  void getTask(DateTime date) async {
    final result = await FirebaseTask.getTasks(date);
    switch (result) {
      case SuccessFB<List<TaskModel>>():
        final allTasks = result.data ?? [];
        pendingTasks = allTasks
            .where((task) => task.isCompleted == false)
            .toList();

        completedTasks = allTasks
            .where((task) => task.isCompleted == true)
            .toList();
      case ErrorFB<List<TaskModel>>():
        AppDialog.showError(context, error: result.messageError);
    }
    if (!mounted) return;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppAsset.logo),
      ),
      body: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DatePicker(
              DateTime.now().subtract(Duration(days: 2)),
              height: 100,
              initialSelectedDate: DateTime.now(),
              daysCount: 30,
              selectionColor: Color(0xff5F33E1),
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                _selectedValue = date;
                getTask(date);
                setState(() {});
              },
            ),
          ),
          isLoading ? _loadingState() : _listOfTasks(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xff24252C),
        onPressed: _onPressedAddTask,
        child: Icon(Icons.add, color: Color(0xff5F33E1)),
      ),
    );
  }

  void _onPressedAddTask() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ShowButtonSheetTask(),
    ).whenComplete(() {
      getTask(_selectedValue);
    });
  }

  Widget _loadingState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }

  Widget _listOfTasks() {
    return Expanded(
      child: pendingTasks.isEmpty && completedTasks.isEmpty
          ? _emptyState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) {
                    final task = pendingTasks[index];
                    return ItemCardWidget(
                      task: task,
                      title: pendingTasks[index].title ?? ' ',
                      dateTime:
                          pendingTasks[index].selectedDate ?? DateTime.now(),
                      priority: pendingTasks[index].priorityIndex ?? 1,
                      isCompleted: pendingTasks[index].isCompleted ?? false,
                      onPressed: () => onCompletedButton(index, pendingTasks),
                      onDelete: () => onDeleteButton(index, pendingTasks),
                      onEdit: () => onEdit(task),
                    );
                  },
                  itemCount: pendingTasks.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 16),
                ),
                Container(
                  margin: EdgeInsets.only(left: 21, top: 20, bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff24252C),
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return ItemCardWidget(
                      task: task,
                      title: completedTasks[index].title ?? ' ',
                      dateTime:
                          completedTasks[index].selectedDate ?? DateTime.now(),
                      priority: completedTasks[index].priorityIndex ?? 1,
                      isCompleted: completedTasks[index].isCompleted ?? false,
                      onPressed: () => onCompletedButton(index, completedTasks),
                      onDelete: () => onDeleteButton(index, completedTasks),
                      onEdit: () => onEdit(task),
                    );
                  },
                  itemCount: completedTasks.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 16),
                ),
              ],
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        spacing: 10,
        children: [
          SizedBox(height: 90),
          Image.asset(AppAsset.emptyImage),
          Text(
            'What do you want to do today?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff58585E),
            ),
          ),
        ],
      ),
    );
  }

  void onCompletedButton(int index, List<TaskModel> listOfTask) async {
    final taskToUpdate = listOfTask[index];
    final isCurrentlyCompleted = taskToUpdate.isCompleted!;
    taskToUpdate.isCompleted = !isCurrentlyCompleted;
    listOfTask.removeAt(index);
    if (taskToUpdate.isCompleted == true) {
      completedTasks.add(taskToUpdate);
    } else {
      pendingTasks.add(taskToUpdate);
    }
    setState(() {});
    await FirebaseTask.updateIsCompleted(taskToUpdate);
  }

  void onDeleteButton(int index, List<TaskModel> listOfTask) async {
    await FirebaseTask.deleteTask(listOfTask[index]);
    Navigator.of(context).pop();
    getTask(_selectedValue);
  }

  void onEdit(TaskModel task) {
    Navigator.of(context)
        .pushNamed(EditScreen.routeName, arguments: task)
        .then((_) => getTask(_selectedValue));
  }
}
