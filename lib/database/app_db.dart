import 'package:flutter_task_manager/utils/app_constants.dart';
import 'package:hive/hive.dart';

class AppDatabase {

Box getSavedTasks(){
  return Hive.box(TASK_LIST_KEY) ;
}

}