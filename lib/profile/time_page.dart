import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {

  final String Token;
  SchedulePage({required this.Token});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  TimeOfDay? wakeUpTime;
  TimeOfDay? sleepTime;
  TimeOfDay? gymTime;
  TimeOfDay? startWorkTime;
  TimeOfDay? endWorkTime;
  int exerciseDays = 4;

  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Schedule"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTimeField("What time do you usually wake up?", wakeUpTime, (picked) {
              setState(() => wakeUpTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you usually sleep?", sleepTime, (picked) {
              setState(() => sleepTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you usually go to the gym?", gymTime, (picked) {
              setState(() => gymTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you start work?", startWorkTime, (picked) {
              setState(() => startWorkTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you end work?", endWorkTime, (picked) {
              setState(() => endWorkTime = picked);
            }),
            SizedBox(height: 20),
            Text("How many days a week can you exercise?", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: exerciseDays,
              dropdownColor: Color(0xFF1F1F1F),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              items: List.generate(7, (index) => index + 1).map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(day.toString(), style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  exerciseDays = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement save action here
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff0336),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TimeOfDay? time, Function(TimeOfDay) onTimeSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickTime(context, time, onTimeSelected),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null ? time.format(context) : "--:--",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
