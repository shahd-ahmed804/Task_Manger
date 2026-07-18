import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskey_app/core/utils/app_asset.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../view_model/home_state.dart';
import '../widget/item_card_widget.dart';
import '../widget/show_button_sheet_task.dart';
import 'edit_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/task_model.dart';
import 'package:taskey_app/features/home/view_model/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedValue = DateTime.now();
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getTasks(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Image.asset(AppAsset.logo)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: DatePicker(
              DateTime.now().subtract(const Duration(days: 2)),
              height: 100.h,
              initialSelectedDate: DateTime.now(),
              daysCount: 30,
              selectionColor: const Color(0xff5F33E1),
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {
                  _selectedValue = date;
                });
                context.read<HomeCubit>().getTasks(date);
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return _loadingState();
                }

                if (state is HomeError) {
                  return Center(child: Text(state.message));
                }

                if (state is HomeLoaded) {
                  return _listOfTasks(state.pendingTasks, state.completedTasks);
                }

                return const SizedBox();
              },
            ),
          ),
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
      context.read<HomeCubit>().refresh();
    });
  }

  Widget _loadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _listOfTasks(
    List<TaskModel> pendingTasks,
    List<TaskModel> completedTasks,
  ) {
    if (pendingTasks.isEmpty && completedTasks.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 80.h),
            _emptyState(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          ...pendingTasks.map(
            (task) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ItemCardWidget(
                task: task,
                title: task.title ?? '',
                dateTime: task.selectedDate ?? DateTime.now(),
                priority: task.priorityIndex ?? 1,
                isCompleted: task.isCompleted ?? false,
                onPressed: () => onCompletedButton(task),
                onDelete: () => onDeleteButton(task),
                onEdit: () => onEdit(task),
              ),
            ),
          ),

          if (completedTasks.isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 0, top: 20.h, bottom: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Completed',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
            ),

          ...completedTasks.map(
            (task) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ItemCardWidget(
                task: task,
                title: task.title ?? '',
                dateTime: task.selectedDate ?? DateTime.now(),
                priority: task.priorityIndex ?? 1,
                isCompleted: task.isCompleted ?? false,
                onPressed: () => onCompletedButton(task),
                onDelete: () => onDeleteButton(task),
                onEdit: () => onEdit(task),
              ),
            ),
          ),

          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      children: [
        Image.asset(AppAsset.emptyImage),
        SizedBox(height: 10.h),
        Text(
          'What do you want to do today?',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff58585E),
          ),
        ),
      ],
    );
  }

  Future<void> onCompletedButton(TaskModel task) async {
    await context.read<HomeCubit>().toggleComplete(task);
  }

  void onEdit(TaskModel task) {
    Navigator.of(context).pushNamed(EditScreen.routeName, arguments: task).then(
      (_) {
        context.read<HomeCubit>().refresh();
      },
    );
  }

  Future<void> onDeleteButton(TaskModel task) async {
    AppDialog.showLoading(context);

    await context.read<HomeCubit>().deleteTask(task);

    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().refresh();
  }
}
