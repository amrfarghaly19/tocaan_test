/*


import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataPage extends StatefulWidget {
  final String Token;

  DataPage({Key? key, required this.Token}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<DataResponse> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<DataResponse> fetchData() async {
    final uri = Uri.parse("${Config.baseURL}/workout/activities");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.Token}',
    };
    final body = json.encode({
      // Replace with your actual JSON body parameters if needed
      // 'key1': 'value1',
      // 'key2': 'value2',
    });

    final request = http.Request('GET', uri)
      ..headers.addAll(headers);
    //  ..body = body; // Include body if your API expects it with GET

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      final responseBody = await streamedResponse.stream.bytesToString();
      return DataResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,

        title: Text(
          'Activity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: FutureBuilder<DataResponse>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data, show a loading spinner
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display it
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            // If the data is empty, display a message
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // If data is fetched successfully, display it
            // Sort the data by day_num in ascending order
            List<DataItem> sortedData = List.from(snapshot.data!.data);
            sortedData.sort((a, b) => a.dayNum.compareTo(b.dayNum));

            return ListView.builder(
              itemCount: sortedData.length,
              itemBuilder: (context, index) {
                final item = sortedData[index];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.type.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.broken_image,
                          color: Colors.red,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        );
                      },
                    ),
                    title: Text(
                      item.type.typeName,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day Number: ${item.dayNum}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Feedback: ${item.feedback}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Created At: ${formatDate(item.createdAt)}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper method to format DateTime
  String formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}:${_twoDigits(date.second)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}




class DataResponse {
  final List<DataItem> data;

  DataResponse({required this.data});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      data: (json['data'] as List)
          .map((item) => DataItem.fromJson(item))
          .toList(),
    );
  }
}

class DataItem {
  final int id;
  final TypeDetail type;
  final int? plan;
  final int dayNum;
  final String feedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  DataItem({
    required this.id,
    required this.type,
    this.plan,
    required this.dayNum,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      id: json['id'],
      type: TypeDetail.fromJson(json['type']),
      plan: json['plan'],
      dayNum: json['day_num'],
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class TypeDetail {
  final int id;
  final String typeName;
  final String image;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  TypeDetail({
    required this.id,
    required this.typeName,
    required this.image,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    return TypeDetail(
      id: json['id'],
      typeName: json['type_name'],
      image: json['image'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configre/globale_variables.dart'; // Ensure this path is correct

class CalendarScreen extends StatefulWidget {
  final String Token; // Assuming you need to pass the Token for API calls

  const CalendarScreen({Key? key, required this.Token}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example data map: DateTime -> List of Strings
  // Replace this with your actual data structure
  Map<String, dynamic> _dataMap = {};

  @override
  void initState() {
    super.initState();
    _fetchDataForMonth(_focusedDay);
  }

  Future<void> _fetchDataForMonth(DateTime month) async {
    String formattedMonth = DateFormat('yyyy-MM').format(month);
    var url = Uri.parse("${Config.baseURL}/data?month=$formattedMonth");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _dataMap = responseData['data']; // Adjust based on your API response
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // Fetch data for the selected day
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    var dataForDay = _dataMap[formattedDate] ?? 'No data available for this day.';

    // Show popup with the data
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Data for ${DateFormat('dd MMM yyyy').format(selectedDay)}',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            dataForDay.toString(),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Format DateTime to "yyyy-MM-dd HH:mm:ss"
  String _formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

*/
/*  Future<void> _showSatisfactionSurvey() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) {
        return SatisfactionSurvey(
          Token: widget.Token,
          selectedDate: _selectedDay ?? DateTime.now(),
        );
      },
    );
  }*//*


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Workout Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(

                color: Colors.transparent, // Transparent background
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2), // White border
              ),
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.white),
              todayTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchDataForMonth(focusedDay);
            },

           // calendarBackground: Colors.black,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed:(){
              // _selectedDay != null ? _showSatisfactionSurvey : null,
            },
            child: Text("Give Feedback"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

*/



// calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configre/globale_variables.dart'; // Ensure this path is correct

class CalendarScreen extends StatefulWidget {
  final String Token; // Token for API authentication

  const CalendarScreen({Key? key, required this.Token}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map to hold activities for each date
  Map<DateTime, List<Activity>> _dataMap = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _fetchDataForMonth(_focusedDay);
  }

  /// Fetches activities for the specified month from the API
  Future<void> _fetchDataForMonth(DateTime month) async {
    String formattedMonth = DateFormat('yyyy-MM').format(month);
    var url = Uri.parse("${Config.baseURL}/workout/activities?month=$formattedMonth");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<Activity> activities = (responseData['data'] as List)
            .map((item) => Activity.fromJson(item))
            .toList();

        // Clear previous data for the month
        _dataMap.clear();

        // Organize activities by their creation date
        for (var activity in activities) {
          DateTime date = DateTime(activity.createdAt.year, activity.createdAt.month, activity.createdAt.day);
          if (_dataMap.containsKey(date)) {
            _dataMap[date]!.add(activity);
          } else {
            _dataMap[date] = [activity];
          }
        }

        setState(() {});
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  /// Handles day selection on the calendar
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // Normalize the selected day to remove time components
    DateTime dateKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    List<Activity> activitiesForDay = _dataMap[dateKey] ?? [];

    if (activitiesForDay.isEmpty) {
      // Show a message if there's no data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available for this day.')),
      );
      return;
    }

    // Show bottom modal sheet with the activities
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          // Adjust height as needed
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activities for ${DateFormat('dd MMM yyyy').format(selectedDay)}',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.white54),
              Expanded(
                child: ListView.builder(
                  itemCount: activitiesForDay.length,
                  itemBuilder: (context, index) {
                    final activity = activitiesForDay[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          activity.image,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                      title: Text(
                        activity.typeName,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Feedback: ${activity.feedback}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      // Optionally, add more details or actions
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

  /// Builds markers for a specific day on the calendar
  List<Widget> _buildMarkers(DateTime date, List<Activity> activities) {
    return activities.map((activity) {
      return Container(
        width: 7,
        height: 7,
        margin: EdgeInsets.symmetric(horizontal: 0.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.greenAccent,
        ),
      );
    }).toList();
  }
  String selectedLanguage = '';

  Future<void> _loadSelectedLanguage() async {
    final savedLanguage = await AppLocalization.getLanguage();
    if (mounted) {
      setState(() {
        selectedLanguage = savedLanguage ?? 'en';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Workout Calendar'.tr(context),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
locale: selectedLanguage,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.white),
              todayTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchDataForMonth(focusedDay);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                DateTime dateKey = DateTime(date.year, date.month, date.day);
                if (_dataMap.containsKey(dateKey)) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildMarkers(date, _dataMap[dateKey]!),
                  );
                }
                return SizedBox();
              },
            ),
            // Customize other styles as needed
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedDay != null) {
                // Implement feedback functionality here if needed
                // For example, navigate to a feedback screen or show another modal
                // _showSatisfactionSurvey();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a date first.')),
                );
              }
            },
            child: Text("Give Feedback"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





// models/activity.dart

class Activity {
  final int id;
  final int typeId;
  final String typeName;
  final String image;
  final String slug;
  final DateTime typeCreatedAt;
  final DateTime typeUpdatedAt;
  final int? plan;
  final int dayNum;
  final String feedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.typeId,
    required this.typeName,
    required this.image,
    required this.slug,
    required this.typeCreatedAt,
    required this.typeUpdatedAt,
    this.plan,
    required this.dayNum,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      typeId: json['type']['id'],
      typeName: json['type']['type_name'],
      image: json['type']['image'],
      slug: json['type']['slug'],
      typeCreatedAt: DateTime.parse(json['type']['created_at']),
      typeUpdatedAt: DateTime.parse(json['type']['updated_at']),
      plan: json['plan'],
      dayNum: json['day_num'],
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
