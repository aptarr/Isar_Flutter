import 'package:flutter/material.dart';

import 'models/alarm.dart';

class AlarmEdit extends StatefulWidget {
  final Alarm alarm;
  final Function(Alarm, String, TimeOfDay) editAlarm;

  AlarmEdit({required this.alarm, required this.editAlarm});

  @override
  _AlarmEditState createState() => _AlarmEditState();
}

class _AlarmEditState extends State<AlarmEdit> {
  late TextEditingController _descriptionController;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.alarm.description);
    _time = TimeOfDay(hour: widget.alarm.alarmDateTime.hour, minute: widget.alarm.alarmDateTime.minute);
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  // Function to save the edited alarm
  void _saveAlarm() {
    // Call the editAlarm function to save the updated alarm
    widget.editAlarm(widget.alarm, _descriptionController.text, _time);

    // Navigate back to the home screen after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Alarm',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Time', style: TextStyle(color: Colors.white)),
              subtitle: Text('${_time.format(context)}', style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.access_time, color: Colors.white),
              onTap: () => _selectTime(context),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Cancel button
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _saveAlarm, // Save button
                  child: Text('Save Alarm', style: TextStyle(color: Colors.deepPurpleAccent)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
