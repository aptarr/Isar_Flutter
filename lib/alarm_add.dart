import 'package:flutter/material.dart';
import 'package:isar_local_db/services/database_service.dart';

import 'models/alarm.dart';

class AlarmAdd extends StatefulWidget {
  final Function(Alarm) addAlarm;

  AlarmAdd({required this.addAlarm});

  @override
  _AlarmAddState createState() => _AlarmAddState();
}

class _AlarmAddState extends State<AlarmAdd> {
  // Controllers to hold input values
  TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();

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

  // Function to save the alarm
  Future<void> _saveAlarm() async {
    // Create the DateTime object using the selected time
    DateTime alarmDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _time.hour,
      _time.minute,
    );

    // Get the description or set a default value
    String description = _descriptionController.text;

    // Create a new Alarm object
    Alarm newAlarm = Alarm();

    newAlarm = newAlarm.updateAlarm(alarmDateTime, description: description);

    await DatabaseService.db.writeTxn(() async {
      DatabaseService.db.alarms.put(newAlarm);
    });

    // Add the new alarm to the list
    widget.addAlarm(newAlarm);

    // Print the alarm details for demonstration purposes
    print('Alarm set for: $alarmDateTime with description: $description');

    // Navigate back to the home screen (or previous screen)
    Navigator.pop(context);
  }

  // Function to cancel the operation (for now, just pop the screen)
  void _cancel() {
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
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 10),
              // Set the margin here
              child: Text(
                'Add New Alarm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Time Picker
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D2F41),
                borderRadius: BorderRadius.circular(10),
                // Set the radius for rounded corners
                border: Border.all(
                  width: 1,
                ), // Optional: Border color and width
              ),
              margin: EdgeInsets.only(top: 30, bottom: 10),
              child: ListTile(
                title: Text(
                  'Time',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                subtitle: Text(
                  '${_time.format(context)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 40,
                ),
                onTap: () => _selectTime(context),
              ),
            ),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2, // border width
                  ),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),

            // Buttons (Save and Cancel)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: _cancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: Colors.deepPurpleAccent,
                          width: 2, // border width
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Space between the buttons
                  // Save Button
                  ElevatedButton(
                    onPressed: _saveAlarm,
                    child: Text(
                      'Save Alarm',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White color for Save
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
