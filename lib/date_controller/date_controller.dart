import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateController extends GetxController {
  var _selectedDateTime = ''.obs;

  void setDateTime(String dateTime) {
    _selectedDateTime.value = dateTime;
  }

  String get getDateTime => changeDateTimeFormat(_selectedDateTime.value);

  String changeDateTimeFormat(String dateTime) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(dateTime));
  }
}
