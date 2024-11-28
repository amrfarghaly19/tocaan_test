/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:gymjoe/diet_screen/diet_screen.dart';
import 'package:http/http.dart' as http;

// Fitness Test Page
class FitnessTestPage extends StatefulWidget {
  final String Token;

  FitnessTestPage({required this.Token});

  @override
  _FitnessTestPageState createState() => _FitnessTestPageState();
}

class _FitnessTestPageState extends State<FitnessTestPage> {
  // Variables to hold fetched data and loading/error states
  List<FitnessTest> fitnessTests = [];
  bool isLoading = true;
  bool isError = false;

  // Map to hold TextEditingControllers for each exercise by their ID
  Map<int, TextEditingController> exerciseControllers = {};

  @override
  void initState() {
    super.initState();
    fetchFitnessTests();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    exerciseControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  // Function to fetch fitness tests from the API
  Future<void> fetchFitnessTests() async {
    final String url = "${Config.baseURL}/workout/tests";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer ${widget.Token}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          fitnessTests =
              data.map((item) => FitnessTest.fromJson(item)).toList();
          isLoading = false;
        });

        // Initialize controllers for each exercise
        initializeControllers();
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      print("Error fetching fitness tests: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  // Function to initialize TextEditingControllers for each exercise
  void initializeControllers() {
    for (var test in fitnessTests) {
      for (var section in test.sections) {
        for (var exercise in section.exercises) {
          exerciseControllers[exercise.id] = TextEditingController();
        }
      }
    }
  }

  // Function to handle submission of user inputs
  Future<void> submitExerciseData() async {
    // *** Fix 1: Change Map<int, String> to Map<String, String> ***
    Map<String, String> submissionData = {};

    bool allFilled = true;

    exerciseControllers.forEach((id, controller) {
      if (controller.text.trim().isEmpty) {
        allFilled = false;
      }
      // *** Fix 1: Convert ID to String ***
      submissionData[id.toString()] = controller.text.trim();
    });

    if (!allFilled) {
      // Show alert if not all fields are filled



      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black,
          title: Text('Incomplete Submission',style:TextStyle(
            color: Color(0xFFff0336), // "OK" button text color (red)
          ),),
          content: Text('Please fill in all the fields before submitting.',   style: TextStyle(
              color: Colors.white,),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(
                color: Color(0xFFff0336), // "OK" button text color (red)
              ),),
            ),
          ],
        ),
      );
      return;
    }

    // *** Fix 2: Wrap submissionData inside "exercises" key ***
    Map<String, dynamic> requestBody = {
      "exercises": submissionData
    };


    // Show loading indicator during submission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // *** Fix 3: Make submitUrl dynamic based on test ID ***
    if (fitnessTests.isEmpty) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black,
          title: Text('No Test Found', style:TextStyle(
            color: Color(0xFFff0336), // "OK" button text color (red)
          ),
          ),
          content: Text('There is no fitness test to submit data for.', style: TextStyle(
            color: Colors.white,),),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style:TextStyle(
                color: Color(0xFFff0336), // "OK" button text color (red)
              ),),
            ),
          ],
        ),
      );
      return;
    }

    // Assuming you want to submit for the first test; adjust if needed
    final int testId = fitnessTests[0].id;
    final String submitUrl = "${Config.baseURL}/workout/tests/$testId";

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Authorization': "Bearer ${widget.Token}",
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // *** Fix 2: Use wrapped body ***
      );

      Navigator.of(context).pop(); // Remove the loading indicator

      if (response.statusCode == 201) {
        // Show success message


        showDialog(

          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
            ),
            backgroundColor: Colors.black,
            title: Text('Success', style:TextStyle(
              color: Color(0xFFff0336), // "OK" button text color (red)
            ),),
            content:
            Text('Your exercise data has been submitted successfully!', style: TextStyle(
              color: Colors.white,),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Optionally, you can clear the input fields here
                  clearAllInputs();
                },
                child: Text('OK', style:TextStyle(
                  color: Color(0xFFff0336), // "OK" button text color (red)
                ),),
              ),
            ],
          ),
        );
      } else {
        // Show error message with response details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
            ),
            backgroundColor: Colors.black, // Dialog background color
            title: Text(
              'Submission Failed',
              style: TextStyle(
                color: Colors.white, // Title text color
              ),
            ),
            content: Text(
              'Error: ${response.statusCode}\n${response.body}',
              style: TextStyle(
                color: Colors.white, // Content text color
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFff0336), // "OK" button text color (red)
                  ),
                ),
              ),
            ],
          ),
        );

      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove the loading indicator
      // Show error message for exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Submission Error'),
          content: Text('An error occurred while submitting your data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      print("Error submitting data: $e");
    }
  }

  // Function to clear all input fields after successful submission
  void clearAllInputs() {
    exerciseControllers.forEach((id, controller) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Fitness Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
          ? Center(
        child: Text(
          'Failed to load fitness tests.',
          style: TextStyle(color: Color(0xFFff0336), fontSize: 18),
        ),
      )
          : fitnessTests.isEmpty
          ? Center(
        child: Text(
          'No fitness tests available.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: fitnessTests.map((test) {
              return Card(
                elevation: 4,
                color: const Color(0xFF1F1F1F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  textColor: Colors.white,

                  title: Text(
                    test.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  children: test.sections.map((section) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics:
                            NeverScrollableScrollPhysics(),
                            itemCount: section.exercises.length,
                            itemBuilder: (context, index) {
                              var exercise =
                              section.exercises[index];
                              return ExerciseCard(
                                exercise: exercise,
                                controller: exerciseControllers[
                                exercise.id]!,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: isLoading || isError || fitnessTests.isEmpty
          ? null
          : FloatingActionButton.extended(
        onPressed: submitExerciseData,
        label: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFff0336),
      ),
    );
  }
}

// Exercise Card Widget
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;

  ExerciseCard({required this.exercise, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF1F1F1F),
          ),
          child: Padding(
            padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 0, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise Image
                Container(
                  width: 300, // Consider using double.infinity for responsiveness
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(exercise.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Exercise Name
                SizedBox(height: 10),
                Text(
                  exercise.exerciseName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                // Play Video Button
                InkWell(
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(videoUrl: exercise.video),
                      ),
                    );
                    // Implement video playback functionality here
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFff0336), // Red background color
                      borderRadius:
                      BorderRadius.circular(15), // Rounded edges with radius 15
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Play Video",
                            style:
                            TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                // Exercise Comment
                if (exercise.comment.isNotEmpty)
                  Text(
                    exercise.comment,
                    style:
                    TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                SizedBox(height: 10),
                // Input Field
                TextField(
                  controller: controller,
                  style: TextStyle(
                    color: Colors.white, // Sets the input text color to white
                  ),
                  cursorColor: Color(0xFFff0336), // Sets the cursor color to red
                  decoration: InputDecoration(
                  //  labelText: 'Enter your value',
                    labelStyle: TextStyle(
                      color: Colors.white, // Sets the label text color to white
                    ),
                    hintText: '0000',
                    hintStyle: TextStyle(
                      color: Colors.white70, // Sets the hint text color to a lighter white
                    ),
                    filled: true, // If you want a filled background
                    fillColor: Colors.transparent, // Sets the filled color; change if needed
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white, // Sets the border color to white when not focused
                        width: 1.5, // Adjust the border width as desired
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFFff0336), // Sets the border color to red when focused
                        width: 2.0, // Thicker border when focused
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red, // Sets the border color to red on error
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red, // Sets the border color to red when focused and in error
                        width: 2.0,
                      ),
                    ),
                    // Optional: Prefix or Suffix Icons with specific colors
                    // prefixIcon: Icon(Icons.number, color: Colors.white),
                    // suffixIcon: Icon(Icons.check, color: Colors.white),
                  ),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 10),
                Divider(color: Color(0xFFff0336)),
              ],
            ),
          ),
        ));
  }
}

// Data Models

// FitnessTestResponse Model
class FitnessTestResponse {
  final List<FitnessTest> data;

  FitnessTestResponse({required this.data});

  factory FitnessTestResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<FitnessTest> fitnessTests =
    dataList.map((test) => FitnessTest.fromJson(test)).toList();
    return FitnessTestResponse(data: fitnessTests);
  }
}

// FitnessTest Model
class FitnessTest {
  final int id;
  final String title;
  final int scheduleDays;
  final List<Section> sections;
  final DateTime createdAt;
  final DateTime updatedAt;

  FitnessTest({
    required this.id,
    required this.title,
    required this.scheduleDays,
    required this.sections,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FitnessTest.fromJson(Map<String, dynamic> json) {
    var sectionsList = json['sections'] as List;
    List<Section> sections =
    sectionsList.map((section) => Section.fromJson(section)).toList();

    return FitnessTest(
      id: json['id'],
      title: json['title'],
      scheduleDays: json['schedule_days'],
      sections: sections,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// Section Model
class Section {
  final String title;
  final String? description;
  final List<Exercise> exercises;

  Section({
    required this.title,
    this.description,
    required this.exercises,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['exercises'] as List;
    List<Exercise> exercises =
    exercisesList.map((ex) => Exercise.fromJson(ex)).toList();

    return Section(
      title: json['title'],
      description: json['description'],
      exercises: exercises,
    );
  }
}

// Exercise Model
class Exercise {
  final int id;
  final String exerciseName;
  final String? exerciseDescription;
  final String comment;
  final String image;
  final String video;

  Exercise({
    required this.id,
    required this.exerciseName,
    this.exerciseDescription,
    required this.comment,
    required this.image,
    required this.video,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      exerciseName: json['exercise_name'],
      exerciseDescription: json['exercise_description'],
      comment: json['comment'],
      image: json['image'],
      video: json['video'],
    );
  }
}
*/


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:gymjoe/diet_screen/diet_screen.dart';
import 'package:http/http.dart' as http;

// Fitness Test Page
class FitnessTestPage extends StatefulWidget {
  final String Token;

  FitnessTestPage({required this.Token});

  @override
  _FitnessTestPageState createState() => _FitnessTestPageState();
}

class _FitnessTestPageState extends State<FitnessTestPage> {
  // Variables to hold fetched data and loading/error states
  List<FitnessTest> fitnessTests = [];
  bool isLoading = true;
  bool isError = false;

  // Test Reports Variables
  TestReportsResponse? testReports;
  bool isReportsLoading = true;
  bool isReportsError = false;
  Map<String, List<TestResult>> testResultsByDate = {};

  // Map to hold TextEditingControllers for each exercise by their ID
  Map<int, TextEditingController> exerciseControllers = {};

  @override
  void initState() {
    super.initState();
    fetchFitnessTests();
    fetchTestReports(); // Fetch test reports as well
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    exerciseControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  // Function to fetch fitness tests from the API
  Future<void> fetchFitnessTests() async {
    final String url = "${Config.baseURL}/workout/tests";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer ${widget.Token}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          fitnessTests =
              data.map((item) => FitnessTest.fromJson(item)).toList();
          isLoading = false;
        });

        // Initialize controllers for each exercise
        initializeControllers();
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      print("Error fetching fitness tests: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  // Function to fetch test reports from the API
  Future<void> fetchTestReports() async {
    final String url = "${Config.baseURL}/workout/test-reports";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer ${widget.Token}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        TestReportsResponse reports = TestReportsResponse.fromJson(jsonResponse);

        // Process data to group test results by date
        Map<String, List<TestResult>> groupedData = {};

        for (var date in reports.dates) {
          groupedData[date] = [];
          reports.data.forEach((testName, dateValues) {
            String value = dateValues[date] ?? 'N/A';
            groupedData[date]!.add(TestResult(testName: testName, value: value));
          });
        }

        setState(() {
          testReports = reports;
          isReportsLoading = false;
          testResultsByDate = groupedData;
        });
      } else {
        print("Error fetching test reports: ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          isReportsLoading = false;
          isReportsError = true;
        });
      }
    } catch (e) {
      print("Error fetching test reports: $e");
      setState(() {
        isReportsLoading = false;
        isReportsError = true;
      });
    }
  }

  // Function to initialize TextEditingControllers for each exercise
  void initializeControllers() {
    for (var test in fitnessTests) {
      for (var section in test.sections) {
        for (var exercise in section.exercises) {
          exerciseControllers[exercise.id] = TextEditingController();
        }
      }
    }
  }

  // Function to handle submission of user inputs
  Future<void> submitExerciseData() async {
    // Change Map<int, String> to Map<String, String>
    Map<String, String> submissionData = {};

    bool allFilled = true;

    exerciseControllers.forEach((id, controller) {
      if (controller.text.trim().isEmpty) {
        allFilled = false;
      }
      // Convert ID to String
      submissionData[id.toString()] = controller.text.trim();
    });

    if (!allFilled) {
      // Show alert if not all fields are filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black,
          title: Text(
            'Incomplete Submission',
            style: TextStyle(
              color: Color(0xFFff0336), // "OK" button text color (red)
            ),
          ),
          content: Text(
            'Please fill in all the fields before submitting.',
            style: TextStyle(
              color: Colors.white, // Content text color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336), // "OK" button text color (red)
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Wrap submissionData inside "exercises" key
    Map<String, dynamic> requestBody = {
      "exercises": submissionData
    };

    // Show loading indicator during submission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: Color(0xFFff0336))),
    );

    // Make submitUrl dynamic based on test ID
    if (fitnessTests.isEmpty) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black,
          title: Text(
            'No Test Found',
            style: TextStyle(
              color: Color(0xFFff0336), // "OK" button text color (red)
            ),
          ),
          content: Text(
            'There is no fitness test to submit data for.',
            style: TextStyle(
              color: Colors.white, // Content text color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336), // "OK" button text color (red)
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Assuming you want to submit for the first test; adjust if needed
    final int testId = fitnessTests[0].id;
    final String submitUrl = "${Config.baseURL}/workout/tests/$testId";

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Authorization': "Bearer ${widget.Token}",
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Use wrapped body
      );

      Navigator.of(context).pop(); // Remove the loading indicator

      if (response.statusCode == 201) {
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Success',
              style: TextStyle(
                color: Color(0xFFff0336), // Title text color (red)
              ),
            ),
            content: Text(
              'Your exercise data has been submitted successfully!',
              style: TextStyle(
                color: Colors.white, // Content text color
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear input fields
                  clearAllInputs();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFff0336), // "OK" button text color (red)
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Show error message with response details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
            ),
            backgroundColor: Colors.black, // Dialog background color
            title: Text(
              'Submission Failed',
              style: TextStyle(
                color: Colors.white, // Title text color
              ),
            ),
            content: Text(
              'Error: ${response.statusCode}\n${response.body}',
              style: TextStyle(
                color: Colors.white, // Content text color
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFff0336), // "OK" button text color (red)
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove the loading indicator
      // Show error message for exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Submission Error',
            style: TextStyle(
              color: Colors.white, // Title text color
            ),
          ),
          backgroundColor: Colors.black,
          content: Text(
            'An error occurred while submitting your data.',
            style: TextStyle(
              color: Colors.white, // Content text color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336), // "OK" button text color (red)
                ),
              ),
            ),
          ],
        ),
      );
      print("Error submitting data: $e");
    }
  }

  // Function to clear all input fields after successful submission
  void clearAllInputs() {
    exerciseControllers.forEach((id, controller) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Fitness Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
          ? Center(
        child: Text(
          'Failed to load fitness tests.',
          style:
          TextStyle(color: Color(0xFFff0336), fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Existing Fitness Tests Section
              ...fitnessTests.map((test) {
                return Card(
                  elevation: 4,
                  color: const Color(0xFF1F1F1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    title: Text(
                      test.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    children: test.sections.map((section) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                              NeverScrollableScrollPhysics(),
                              itemCount: section.exercises.length,
                              itemBuilder: (context, index) {
                                var exercise =
                                section.exercises[index];
                                return ExerciseCard(
                                  exercise: exercise,
                                  controller:
                                  exerciseControllers[
                                  exercise.id]!,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),

              SizedBox(height: 30), // Spacer before Test Reports

              // Test Reports Section
              Text(
                'Test Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              isReportsLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFff0336),
                ),
              )
                  : isReportsError
                  ? Center(
                child: Text(
                  'Failed to load test reports.',
                  style: TextStyle(
                      color: Color(0xFFff0336),
                      fontSize: 18),
                ),
              )
                  : testReports == null ||
                  testReports!.data.isEmpty
                  ? Center(
                child: Text(
                  'No test reports available.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18),
                ),
              )
                  : Column(
                children:
                testResultsByDate.entries.map((entry) {
                  String date = entry.key;
                  List<TestResult> results =
                      entry.value;
                  return Card(
                    elevation: 4,
                    color: const Color(0xFF1F1F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: 10),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      title: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      children: results.map((result) {
                        return ListTile(
                          title: Text(
                            result.testName,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            result.value,
                            style: TextStyle(
                              color:
                              Color(0xFFff0336),
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
      isLoading || isError || fitnessTests.isEmpty
          ? null
          : FloatingActionButton.extended(
        onPressed: submitExerciseData,
        label: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFff0336),
      ),
    );
  }
}

// Exercise Card Widget
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;

  ExerciseCard({required this.exercise, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1F1F1F),
        ),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 0, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Image
              Container(
                width: double.infinity, // Responsive width
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(exercise.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Exercise Name
              SizedBox(height: 10),
              Text(
                exercise.exerciseName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              SizedBox(height: 6),
              // Play Video Button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(videoUrl: exercise.video),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFff0336), // Red background color
                    borderRadius:
                    BorderRadius.circular(15), // Rounded edges with radius 15
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Play Video",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6),
              // Exercise Comment
              if (exercise.comment.isNotEmpty)
                Text(
                  exercise.comment,
                  style:
                  TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              SizedBox(height: 10),
              // Input Field
              TextField(
                controller: controller,
                style: TextStyle(
                  color: Colors.white, // Sets the input text color to white
                ),
                cursorColor: Color(0xFFff0336), // Sets the cursor color to red
                decoration: InputDecoration(
                  labelText: 'Enter your value',
                  labelStyle: TextStyle(
                    color: Colors.white, // Sets the label text color to white
                  ),
                  hintText: '0000',
                  hintStyle: TextStyle(
                    color: Colors.white70, // Sets the hint text color to a lighter white
                  ),
                  filled: true, // If you want a filled background
                  fillColor: Colors.transparent, // Sets the filled color; change if needed
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white, // Sets the border color to white when not focused
                      width: 1.5, // Adjust the border width as desired
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFFff0336), // Sets the border color to red when focused
                      width: 2.0, // Thicker border when focused
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Sets the border color to red on error
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Sets the border color to red when focused and in error
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10),
              Divider(color: Color(0xFFff0336)),
            ],
          ),
        ),
      ),
    );
  }
}

// TestReportsResponse Model
class TestReportsResponse {
  final List<String> dates;
  final Map<String, Map<String, String>> data;

  TestReportsResponse({required this.dates, required this.data});

  factory TestReportsResponse.fromJson(Map<String, dynamic> json) {
    // Parse the list of dates
    var datesList = List<String>.from(json['dates']);

    // Initialize an empty map to hold the processed data
    Map<String, Map<String, String>> dataMap = {};

    // Iterate over each key-value pair in the 'data' map
    json['data'].forEach((testName, dateValues) {
      // Initialize a map to hold test results for each date
      Map<String, String> resultsMap = {};

      // Check if 'dateValues' is indeed a map
      if (dateValues is Map<String, dynamic>) {
        dateValues.forEach((date, value) {
          // Convert each value to a string, regardless of its original type
          resultsMap[date] = value.toString();
        });
      }

      // Assign the processed results map to the corresponding test name
      dataMap[testName] = resultsMap;
    });

    return TestReportsResponse(
      dates: datesList,
      data: dataMap,
    );
  }
}

// TestResult Model to represent individual test results
class TestResult {
  final String testName;
  final String value;

  TestResult({required this.testName, required this.value});
}

// FitnessTestResponse Model
class FitnessTestResponse {
  final List<FitnessTest> data;

  FitnessTestResponse({required this.data});

  factory FitnessTestResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<FitnessTest> fitnessTests =
    dataList.map((test) => FitnessTest.fromJson(test)).toList();
    return FitnessTestResponse(data: fitnessTests);
  }
}

// FitnessTest Model
class FitnessTest {
  final int id;
  final String title;
  final int scheduleDays;
  final List<Section> sections;
  final DateTime createdAt;
  final DateTime updatedAt;

  FitnessTest({
    required this.id,
    required this.title,
    required this.scheduleDays,
    required this.sections,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FitnessTest.fromJson(Map<String, dynamic> json) {
    var sectionsList = json['sections'] as List;
    List<Section> sections =
    sectionsList.map((section) => Section.fromJson(section)).toList();

    return FitnessTest(
      id: json['id'],
      title: json['title'],
      scheduleDays: json['schedule_days'],
      sections: sections,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// Section Model
class Section {
  final String title;
  final String? description;
  final List<Exercise> exercises;

  Section({
    required this.title,
    this.description,
    required this.exercises,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['exercises'] as List;
    List<Exercise> exercises =
    exercisesList.map((ex) => Exercise.fromJson(ex)).toList();

    return Section(
      title: json['title'],
      description: json['description'],
      exercises: exercises,
    );
  }
}

// Exercise Model
class Exercise {
  final int id;
  final String exerciseName;
  final String? exerciseDescription;
  final String comment;
  final String image;
  final String video;

  Exercise({
    required this.id,
    required this.exerciseName,
    this.exerciseDescription,
    required this.comment,
    required this.image,
    required this.video,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      exerciseName: json['exercise_name'],
      exerciseDescription: json['exercise_description'],
      comment: json['comment'],
      image: json['image'],
      video: json['video'],
    );
  }
}

