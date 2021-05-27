import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:flutter_task_manager/services/local_notification_handler/localNotificationsHandler.dart';
import 'package:flutter_task_manager/utils/app_constants.dart';
import 'package:flutter_task_manager/utils/baseClass.dart';
import 'package:flutter_task_manager/widgets/form_input.dart';
import 'package:flutter_task_manager/widgets/rounded_edge_button.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AddTaskPage extends StatefulWidget {
  final bool isEdit ;
  final TaskListModel taskListModel ;
  final int index ;

  AddTaskPage(this.isEdit,this.taskListModel,this.index);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> with BaseClass{

  String _selectedDateTime ;
  final FocusNode _taskNode = FocusNode();

  final TextEditingController _taskController = TextEditingController();

  final FocusNode _taskTimeNode = FocusNode();

  final TextEditingController _taskTimeController = TextEditingController();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEdit){
      print(widget.index);
      _taskController.text = widget.taskListModel.taskName;
      _taskTimeController.text =widget.taskListModel.taskDateTime;
      _selectedDateTime = _taskTimeController.text.trim();
    }

  }
  @override
  Widget build(BuildContext context) {
    NotificationService notificationService = Get.put(NotificationService());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(widget.isEdit?'Edit task':'Add task'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          children: [
            FormInput(
                label: 'Task Name',
                textEditingController: _taskController,
                focusNode: _taskNode,
                maxLine: 8),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _showDatePicker(context);
              },
              child: FormInput(
                label: 'Task Date and Time',
                textEditingController: _taskTimeController,
                focusNode: _taskTimeNode,
                isEnabled: false,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            RoundedEdgeButton(
                height: 56,
                buttonRadius: 15,
                color: Colors.redAccent,
                textColor: Colors.white,
                text: widget.isEdit?'Edit Task':'Add Task',
                onPressed: (value) {
                  if(_taskController.text.trim().isEmpty){
                    Get.snackbar("ERROR", "Task name cannot be empty",backgroundColor: Colors.amber);

                  }
                  else if(_taskTimeController.text.trim().isEmpty){
                    Get.snackbar("ERROR", "Task date and time cannot be empty",backgroundColor: Colors.amber);
                    return ;
                  }
                  else {

                    if(widget.isEdit){
                      widget.taskListModel.taskName = _taskController.text.trim();
                      widget.taskListModel.taskDateTime = _selectedDateTime;
                      widget.taskListModel.isCompleted = false;

                      print(widget.taskListModel.taskName);
                      print(widget.taskListModel.taskDateTime);
                      print(widget.taskListModel.isCompleted);
                      final taskBox = Hive.box(TASK_LIST_KEY);
                      taskBox.putAt(widget.index,widget.taskListModel);
                    }
                    else{
                      TaskListModel taskListModel = TaskListModel(
                        taskName: _taskController.text.trim(),
                        taskDateTime: _selectedDateTime,
                        isCompleted: false,
                      );
                      final taskBox = Hive.box(TASK_LIST_KEY);
                      taskBox.add(taskListModel);
                    }
                    notificationService.scheduledZonedNotification();
                    popToPreviousScreen(context: context);
                  }


                  //print(_taskController.text);
                },
                context: context),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        minuteInterval: 1,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        minimumDate: DateTime.now().subtract(Duration(days: 1)),
                        onDateTimeChanged: (val) {
                          if(mounted) {
                            setState(() {
                              _selectedDateTime = val.toString();
                              _taskTimeController.text = changeDateTimeFormat(_selectedDateTime);
                            });
                          }
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      popToPreviousScreen(context: context);
                    }
                  )
                ],
              ),
            ));
  }
}
