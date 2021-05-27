// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskListModelAdapter extends TypeAdapter<TaskListModel> {
  @override
  final int typeId = 0;

  @override
  TaskListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskListModel(
      taskName: fields[0] as String,
      taskDateTime: fields[1] as String,
      isCompleted: fields[2] as bool,
      completedNote: fields[3] as String,
      completedNoteLatitude: fields[4] as String,
      completedNoteLongitude: fields[5] as String,
      completedNoteLocationName: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskListModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskName)
      ..writeByte(1)
      ..write(obj.taskDateTime)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.completedNote)
      ..writeByte(4)
      ..write(obj.completedNoteLatitude)
      ..writeByte(5)
      ..write(obj.completedNoteLongitude)
      ..writeByte(6)
      ..write(obj.completedNoteLocationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
