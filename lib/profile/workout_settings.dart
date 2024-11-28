
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../configre/globale_variables.dart';

class WorkoutSettings extends StatefulWidget {
  final String Token;
  WorkoutSettings({required this.Token});

  @override
  _WorkoutSettingsState createState() => _WorkoutSettingsState();
}

class _WorkoutSettingsState extends State<WorkoutSettings> {
  TimeOfDay? wakeUpTime;
  TimeOfDay? sleepTime;
  TimeOfDay? gymTime;
  TimeOfDay? startWorkTime;
  TimeOfDay? endWorkTime;
  int exerciseDays = 3;

  String photo = '';
  String name = '';
  String code = '';

  // Selected keys for dropdowns

  String? selectedGoalKey;
  int selectedFitnessLevelIndex = 0; // Default fitness level


  // Fitness Levels
  final List<Map<String, String>> fitnessLevels = [
    {"key": "sendentary", "name": "Sedentary"},
    {"key": "beginner", "name": "Beginner"},
    {"key": "intermediate", "name": "Intermediate"},
    {"key": "advanced", "name": "Advanced"},
    {"key": "elite", "name": "Elite"},
  ];

  // Goals without Images
  final List<Map<String, String>> goals = [
    {"key": "weight_loss", "name": "Weight Loss"},
    {"key": "muscle_gain", "name": "Muscle Gain / Hypertrophy"},
    {"key": "improved_endurance", "name": "Improved Endurance / Stamina"},
    {"key": "strength_building", "name": "Strength Building"},
    {"key": "flexibility_and_mobility", "name": "Flexibility and Mobility"},
    {"key": "athletic_performance", "name": "Athletic Performance"},
    {"key": "general_fitness_and_health", "name": "General Fitness and Health"},
    {"key": "stress_relief_and_mental_wellbeing", "name": "Stress Relief and Mental Wellbeing"},
    {"key": "body_recomposition", "name": "Body Recomposition"},
    {"key": "rehabilitation", "name": "Rehabilitation / Injury Prevention"},
  ];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final url = Uri.parse('${Config.baseURL}/profile/get-data');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        setState(() {
          photo = data['avatar'] ?? '';
          name = data['name'] ?? '';
          code = data['code'] ?? '';
          wakeUpTime = _parseTimeOfDay(data['wakeup_time']);
          sleepTime = _parseTimeOfDay(data['sleep_time']);
          gymTime = _parseTimeOfDay(data['workout_time']);
          startWorkTime = _parseTimeOfDay(data['work_start_time']);
          endWorkTime = _parseTimeOfDay(data['work_end_time']);
          exerciseDays = data['exercise_days'] ?? 3;

          // Set initial fitness level index
          final fitnessLevelKey = data['fitness_level'];
          selectedFitnessLevelIndex = fitnessLevels.indexWhere(
                  (level) => level["key"]?.toLowerCase() == fitnessLevelKey.toLowerCase());
          if (selectedFitnessLevelIndex == -1) {
            selectedFitnessLevelIndex = 0; // Default to first level if not found
          }

          // Set initial goal key
          final goalKey = data['goal'];
          selectedGoalKey = goals.firstWhere(
                (goal) => goal["name"]?.toLowerCase() == goalKey.toLowerCase(),
            orElse: () => goals[0], // Default to the first goal if not found
          )["key"];

        });
      } else {
        print('Failed to load profile data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> submitSchedule() async {
    final url = Uri.parse('${Config.baseURL}/settings/workout');

    final payload = {
      "workout_time": gymTime != null ? _formatTimeOfDay(gymTime!) : "00:00:00",
      "wakeup_time": wakeUpTime != null ? _formatTimeOfDay(wakeUpTime!) : "00:00:00",
      "sleep_time": sleepTime != null ? _formatTimeOfDay(sleepTime!) : "00:00:00",
      "work_start_time": startWorkTime != null ? _formatTimeOfDay(startWorkTime!) : "00:00:00",
      "work_end_time": endWorkTime != null ? _formatTimeOfDay(endWorkTime!) : "00:00:00",
      "fitness_level": "${fitnessLevels[selectedFitnessLevelIndex]["key"]}", // Replace with actual value
      "goal": "${goals.firstWhere((g) => g["key"] == selectedGoalKey)["key"]}",      // Replace with actual value
      "exercise_days": exerciseDays,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final responseBody = response.body;

      try {
        final jsonResponse = jsonDecode(responseBody);
        print('Response (JSON): $jsonResponse');
      } catch (e) {
        print('Response (Non-JSON): $responseBody');
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schedule updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        print('Failed to update schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating schedule: $e');
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  TimeOfDay? _parseTimeOfDay(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
        title: Text("Schedule",style: TextStyle(color: Colors.white,),),

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            _buildTimeField("What time do you usually go to the gym?", gymTime, (picked) {
              setState(() => gymTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you usually wake up?", wakeUpTime, (picked) {
              setState(() => wakeUpTime = picked);
            }),
            SizedBox(height: 20),
            _buildTimeField("What time do you usually sleep?", sleepTime, (picked) {
              setState(() => sleepTime = picked);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for Fitness Levels
                Text(
                  'Select Fitness Level',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fitnessLevels[selectedFitnessLevelIndex]["name"]!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    sliderTheme: SliderTheme.of(context).copyWith(
                      activeTrackColor: Color(0xFFff0336),
                      thumbColor: Color(0xFFff0336),
                      overlayColor: Color(0xFFff0336).withOpacity(0.2),
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      valueIndicatorColor: Color(0xFFff0336),
                    ),
                  ),
                  child: Slider(
                    value: selectedFitnessLevelIndex.toDouble(),
                    min: 0,
                    max: (fitnessLevels.length - 1).toDouble(),
                    divisions: fitnessLevels.length - 1,
                    label: fitnessLevels[selectedFitnessLevelIndex]["name"],
                    onChanged: (double value) {
                      setState(() {
                        selectedFitnessLevelIndex = value.toInt();
                      });
                    },
                  ),
                ),



                SizedBox(height: 20),



                // Goals Grid
                Text(
                  'Select Your Goal:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    showGoalsBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff0336),
                  ),
                  child: Text(
                    selectedGoalKey != null?
                    '${goals.firstWhere((g) => g["key"] == selectedGoalKey)["name"]}':
                    'Select Goal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: 30),


              ],
            ),


            SizedBox(height: 0),
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
              items: List.generate(6, (index) => index + 2).map((day) {
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
                onPressed: submitSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff0336),
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
  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  void showGoalsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGoalKey = goal["key"];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedGoalKey == goal["key"]
                                ? Color(0xFFff0336)
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            goal["name"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}


