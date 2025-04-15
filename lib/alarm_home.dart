import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_local_db/alarm_add.dart';
import 'package:isar_local_db/alarm_card.dart';
import 'package:isar_local_db/models/alarm.dart';
import 'package:isar_local_db/services/database_service.dart';

class AlarmHome extends StatefulWidget {
  @override
  _AlarmHomeState createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final isarAlarms = await DatabaseService.db.alarms.where().findAll();
    setState(() {
      alarms = isarAlarms;
    });
  }

  void addAlarm(Alarm newAlarm) {
    setState(() {
      alarms.add(newAlarm);
    });
  }

  void deleteAlarm(Alarm alarmToDelete) async {
    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.alarms.delete(alarmToDelete.id);
    });
    loadAlarms(); // refresh list after delete
  }

  void editAlarm(Alarm alarmToEdit, String newDescription, TimeOfDay newTime) async {
    final updatedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      newTime.hour,
      newTime.minute,
    );

    alarmToEdit.alarmDateTime  = updatedTime;
    alarmToEdit.description = newDescription;

    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.alarms.put(alarmToEdit);
    });

    loadAlarms(); // refresh after edit
  }

  void activeAlarm(Alarm alarmToToggle) async {
    alarmToToggle.isActive = !alarmToToggle.isActive;

    await DatabaseService.db.writeTxn(() async {
      await DatabaseService.db.alarms.put(alarmToToggle);
    });

    loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlarmCard(
        alarms: alarms,
        onDelete: deleteAlarm,
        onEdit: editAlarm,
        onActive: activeAlarm,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmAdd(addAlarm: addAlarm),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
