import 'package:isar/isar.dart';

part 'alarm.g.dart';

@Collection()
class Alarm {
  Id id = Isar.autoIncrement;
  DateTime alarmDateTime = DateTime.now();
  String? description;
  bool isActive = true;

  Alarm updateAlarm(DateTime alarmDateTime, {String? description, bool isActive = true}){
    final updated = Alarm()
      ..alarmDateTime = alarmDateTime
      ..description = description
      ..isActive = isActive
      ..id = id;
    return updated;
  }
}

