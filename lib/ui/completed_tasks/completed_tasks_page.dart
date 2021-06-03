import 'package:flutter/material.dart';
import 'package:flutter_task_manager/database/app_db.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:flutter_task_manager/utils/app_constants.dart';
import 'package:flutter_task_manager/widgets/task_widget.dart';
import 'package:hive/hive.dart';

class CompletedTaskPage extends StatelessWidget {
  //final Box taskBox = Hive.box(TASK_LIST_KEY);
  final AppDatabase _appDatabase = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Completed Tasks"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _appDatabase.getSavedTasks.length,
        itemBuilder: (BuildContext context, int index) {
          final taskModel = _appDatabase.getSavedTasks.get(index) as TaskListModel;
          return taskModel.isCompleted
              ? _getCompletedTasksWidget(taskModel)
              : Container();
        },
      ),
    );
  }

  Widget _getCompletedTasksWidget(TaskListModel taskModel) {
    return TaskWidget(
      tasks: taskModel,
      onEditClick: (TaskListModel taskListModel) {},
      onCompletedClick: (TaskListModel taskListModel) {},
      isTrailing: false,
      isCompletedScreen: true,
    );
  }
}
