import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:flutter_task_manager/services/local_notification_handler/localNotificationsHandler.dart';
import 'package:flutter_task_manager/ui/add_tasks/add_task_page.dart';
import 'package:flutter_task_manager/ui/completed_tasks/completed_tasks_page.dart';
import 'package:flutter_task_manager/utils/app_constants.dart';
import 'package:flutter_task_manager/utils/baseClass.dart';
import 'package:flutter_task_manager/utils/user_current_location.dart';
import 'package:flutter_task_manager/widgets/form_input.dart';
import 'package:flutter_task_manager/widgets/rounded_edge_button.dart';
import 'package:flutter_task_manager/widgets/task_widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseClass {
  final taskBox = Hive.box(TASK_LIST_KEY);

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode focusNode = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              pushToNextScreen(
                  context: context, destination: CompletedTaskPage());
            },
            icon: Icon(Icons.check_circle),
          ),
          IconButton(
            onPressed: () {
              pushToNextScreen(
                  context: context, destination: AddTaskPage(false, null, -1));
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box(TASK_LIST_KEY).listenable(),
          builder: (context, box, widget) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: taskBox.length,
              itemBuilder: (BuildContext context, int index) {
                final taskModel = taskBox.get(index) as TaskListModel;
                return !taskModel.isCompleted
                    ? TaskWidget(
                        tasks: taskModel,
                        onEditClick: (TaskListModel taskListModel) {
                          pushToNextScreenWithAnimation(
                              context: context,
                              destination:
                                  AddTaskPage(true, taskListModel, index));
                        },
                        onCompletedClick: (TaskListModel taskListModel) async {
                          LocationData locationData =
                              await UserCurrentLocation().getUserLocation();
                          if (locationData != null) {
                            _completeTaskBottomSheet(
                                context, taskListModel, index, locationData);
                          }
                        },
                        isTrailing: true,
                      )
                    : Container();
              },
            );
          }),
    );
  }

  void _completeTaskBottomSheet(BuildContext context,
      TaskListModel taskListModel, int index, LocationData locationData) {
    showModalBottomSheet<dynamic>(
        barrierColor: Colors.grey.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        elevation: 15,
        builder: (BuildContext bc) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                child: Wrap(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.redAccent.withOpacity(0.8),
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 30),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: FormInput(
                                  label: "Special Note",
                                  textEditingController: _textEditingController,
                                  focusNode: focusNode,
                                  textFieldHeight: 0,
                                  maxLine: 3,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              Container(
                                height: 20,
                              ),
                              RoundedEdgeButton(
                                  height: 45,
                                  textColor: Colors.white,
                                  color: Colors.redAccent,
                                  text: "Mark Completed",
                                  textFontSize: 14,
                                  buttonRadius: 4,
                                  onPressed: (value) async {
                                    TaskListModel mData = TaskListModel(
                                      taskName: taskListModel.taskName,
                                      taskDateTime: taskListModel.taskDateTime,
                                      isCompleted: true,
                                      completedNote:
                                          _textEditingController.text.trim(),
                                      completedNoteLatitude:
                                          locationData.latitude.toString(),
                                      completedNoteLongitude:
                                          locationData.longitude.toString(),
                                      completedNoteLocationName: "",
                                    );
                                    taskBox.put(index, mData);

                                    popToPreviousScreen(context: context);
                                  },
                                  context: context)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
