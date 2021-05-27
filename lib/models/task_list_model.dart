import 'package:hive/hive.dart';

part 'task_list_model.g.dart';

@HiveType(typeId: 0)
class TaskListModel extends HiveObject {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  String taskDateTime;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String completedNote;

  @HiveField(4)
  String completedNoteLatitude;

  @HiveField(5)
  String completedNoteLongitude;

  @HiveField(6)
  String completedNoteLocationName;

/*
  TaskListModel({
    this.taskName,
    this.taskDateTime,
    this.isCompleted = false,

  });*/

  TaskListModel(
  {this.taskName,
      this.taskDateTime,
      this.isCompleted =false ,
      this.completedNote,
      this.completedNoteLatitude,
      this.completedNoteLongitude,
      this.completedNoteLocationName});
}
