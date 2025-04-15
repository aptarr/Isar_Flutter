import 'package:flutter/material.dart';
import 'package:isar_local_db/alarm_home.dart';
import 'package:isar_local_db/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setup();
  runApp(MyApp());
}

Future<void> _setup() async {
  await DatabaseService.setup();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp is at the top of the widget tree
      home: AlarmHome(), // Set MyHomePage as the initial page
    );
  }
}
