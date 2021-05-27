import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:flutter_task_manager/ui/home_page.dart';
import 'package:flutter_task_manager/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await _configureLocalTimeZone();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskListModelAdapter());
  runApp(MyApp());
}

Future<void> _configureLocalTimeZone() async {
  try {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    print(currentTimeZone);
    //tz.setLocalLocation(tz.getLocation('Africa'));
    var locationAsPerTimeZone = tz.getLocation(currentTimeZone);
    tz.setLocalLocation(locationAsPerTimeZone);
  } catch (e) {
    print(e.toString());
    const String fallback = 'Europe/Brussels';
    tz.setLocalLocation(tz.getLocation(fallback));
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: FutureBuilder(
          future: Hive.openBox(TASK_LIST_KEY),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else
                return HomePage();
            } else {
              return Scaffold();
            }
          }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.close();
    super.dispose();
  }
}
