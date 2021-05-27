import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:flutter_task_manager/utils/baseClass.dart';

class TaskWidget extends StatelessWidget with BaseClass {
  final TaskListModel tasks;

  final bool isTrailing;
  final Function onEditClick;
  final Function onCompletedClick;
  final bool isCompletedScreen;

  const TaskWidget({
    @required this.tasks,
    this.isTrailing = false,
    @required this.onEditClick,
    @required this.onCompletedClick,
    this.isCompletedScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
              value: tasks.isCompleted,
              activeColor: Colors.redAccent,
              checkColor: Colors.white,
              onChanged: (value) {
                onCompletedClick(tasks);
              }),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tasks.taskName),
                SizedBox(
                  height: 8,
                ),
                Text(tasks.taskDateTime != null
                    ? changeDateTimeFormat(tasks.taskDateTime)
                    : ""),
                SizedBox(
                  height: 8,
                ),
                isCompletedScreen
                    ? Text(
                        'Note - ${tasks.completedNote}\n\nLatitude ${tasks.completedNoteLatitude}\nLongitude ${tasks.completedNoteLongitude}')
                    : Container(),
              ],
            ),
          ),
          isTrailing
              ? TextButton(
                  onPressed: () {
                    onEditClick(tasks);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
