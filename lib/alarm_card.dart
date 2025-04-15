import 'package:flutter/material.dart';
import 'package:isar_local_db/alarm_edit.dart';
import 'package:intl/intl.dart';

import 'models/alarm.dart'; // For formatting date and time

class AlarmCard extends StatelessWidget {
  final List<Alarm> alarms;
  final Function(Alarm) onDelete;
  final Function(Alarm, String, TimeOfDay) onEdit;
  final Function(Alarm) onActive;

  AlarmCard({required this.alarms, required this.onDelete, required this.onEdit, required this.onActive});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alarm',
              style: TextStyle(
                // fontFamily: ,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                // fontFamily: ,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: alarms.map((alarm){
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D2F41),
                      borderRadius: BorderRadius.all(Radius.circular(24))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    alarm.description ?? "",
                                    style: TextStyle(
                                      // fontFamily: ,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    )
                                ),
                                Text(
                                    "${alarm.alarmDateTime.hour}:${alarm.alarmDateTime.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      // fontFamily: ,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 40,
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // _editAlarm(context, alarm);
                                    // Navigate to AlarmAdd page when the button is pressed
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AlarmEdit(
                                          alarm: alarm,
                                          editAlarm: onEdit,
                                        ),
                                      ),
                                    );
                                  },
                                  label: Text(''),
                                  icon: Icon(Icons.edit, size: 25),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    onDelete(alarm); // Delete the alarm
                                  },
                                  label: Text(''),
                                  icon: Icon(Icons.delete, size: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Switch(
                            value: alarm.isActive,
                            onChanged: (bool value) {
                              onActive(alarm);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
