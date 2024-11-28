/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../configre/globale_variables.dart';


// Fitbit Authentication Service
class FitbitAuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  // Replace these with your Fitbit app credentials
  final String _clientId = '23PR55';
  final String _redirectUrl = 'myapp://callback';
  final String _clientSecret = 'd7208e4d8f13ca0d2a1b51b794f0dfec';

  // Fitbit OAuth endpoints
  final String _authorizationEndpoint = 'https://www.fitbit.com/oauth2/authorize';
  final String _tokenEndpoint = 'https://api.fitbit.com/oauth2/token';

  // Define the scopes you need
  final List<String> _scopes = [
    'activity',
    'heartrate',
    'sleep',
    'profile',
  ];

  // Authenticate and obtain tokens
  Future<Map<String, dynamic>?> authenticate() async {
    try {
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          scopes: _scopes,
          // Additional parameters if needed
        ),
      );

      if (result != null) {
        String accessToken = result.accessToken!;
        String refreshToken = result.refreshToken!;

        // Optionally, fetch user profile
        final profile = await fetchUserProfile(accessToken);

        return {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'profile': profile,
        };
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
    return null;
  }

  // Fetch user profile
  Future<Map<String, dynamic>?> fetchUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/profile.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch user profile: ${response.statusCode}');
    }
    return null;
  }

  // Refresh access token
  Future<Map<String, dynamic>?> refreshAccessToken(String refreshToken) async {
    try {
      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          _clientId,
          _redirectUrl,
          refreshToken: refreshToken,
          grantType: 'refresh_token',
          clientSecret: _clientSecret,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
        ),
      );

      if (result != null) {
        String newAccessToken = result.accessToken!;
        String newRefreshToken = result.refreshToken ?? refreshToken;

        return {
          'access_token': newAccessToken,
          'refresh_token': newRefreshToken,
        };
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return null;
  }
}

// Fitbit Login Page
class FitbitLoginPage extends StatefulWidget {
  @override
  _FitbitLoginPageState createState() => _FitbitLoginPageState();
}

class _FitbitLoginPageState extends State<FitbitLoginPage> {
  final FitbitAuthService _authService = FitbitAuthService();

  void _login() async {
    final authData = await _authService.authenticate();
    if (authData != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            accessToken: authData['access_token'],
            refreshToken: authData['refresh_token'],
            profile: authData['profile'],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Black background
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Fitbit Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFff0336), // Red background color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded edges
            ),
          ),
          child: Text(
            'Login with Fitbit',
            style: TextStyle(
              color: Colors.white, // White text color
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Page to Display Fitbit Data and Fitness Tests
class DashboardPage extends StatefulWidget {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic>? profile;

  DashboardPage({
    required this.accessToken,
    required this.refreshToken,
    this.profile,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late FitbitApiService _apiService;
  Map<String, dynamic>? _stepsData;
  Map<String, dynamic>? _sleepData;
  Map<String, dynamic>? _heartRateData;
  bool _isLoading = true;
  bool _isError = false;

  // Fitness Tests Variables
  List<FitnessTest> fitnessTests = [];
  Map<int, TextEditingController> exerciseControllers = {};

  @override
  void initState() {
    super.initState();
    _apiService = FitbitApiService(accessToken: widget.accessToken);
    fetchFitbitData();
    fetchFitnessTests(); // Assuming FitnessTest data is fetched from another API
  }

  // Fetch Fitbit Data
  Future<void> fetchFitbitData() async {
    String today = DateTime.now().toIso8601String().split('T').first; // YYYY-MM-DD

    try {
      final steps = await _apiService.fetchSteps(today);
      final sleep = await _apiService.fetchSleep(today);
      final heartRate = await _apiService.fetchHeartRate(today);

      setState(() {
        _stepsData = steps;
        _sleepData = sleep;
        _heartRateData = heartRate;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Fitbit data: $e');
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  // Fetch Fitness Tests from Your API
  Future<void> fetchFitnessTests() async {
    final String url = "${Config.baseURL}/workout/tests";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer ${widget.accessToken}", // Assuming accessToken works
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          fitnessTests =
              data.map((item) => FitnessTest.fromJson(item)).toList();
        });

        // Initialize controllers for each exercise
        initializeControllers();
      } else {
        print("Error fetching fitness tests: ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          _isError = true;
        });
      }
    } catch (e) {
      print("Error fetching fitness tests: $e");
      setState(() {
        _isError = true;
      });
    }
  }

  // Initialize TextEditingControllers for each exercise
  void initializeControllers() {
    for (var test in fitnessTests) {
      for (var section in test.sections) {
        for (var exercise in section.exercises) {
          exerciseControllers[exercise.id] = TextEditingController();
        }
      }
    }
  }

  // Handle Submission of Exercise Data
  Future<void> submitExerciseData() async {
    // Change Map<int, String> to Map<String, String>
    Map<String, String> submissionData = {};

    bool allFilled = true;

    exerciseControllers.forEach((id, controller) {
      if (controller.text.trim().isEmpty) {
        allFilled = false;
      }
      submissionData[id.toString()] = controller.text.trim();
    });

    if (!allFilled) {
      // Show customized AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black, // Dialog background color
          title: Text(
            'Incomplete Submission',
            style: TextStyle(
              color: Colors.white, // Title text color
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
      builder: (context) => Center(child: CircularProgressIndicator(color: Color(0xFFff0336))),
    );

    // Make submitUrl dynamic based on test ID
    if (fitnessTests.isEmpty) {
      Navigator.of(context).pop(); // Remove loading indicator
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.black,
          title: Text(
            'No Test Found',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            'There is no fitness test to submit data for.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336),
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
          'Authorization': "Bearer ${widget.accessToken}",
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      Navigator.of(context).pop(); // Remove the loading indicator

      if (response.statusCode == 200) {
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Success',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Your exercise data has been submitted successfully!',
              style: TextStyle(
                color: Colors.white,
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
                    color: Color(0xFFff0336),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Show error message with customized AlertDialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Submission Failed',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Error: ${response.statusCode}\n${response.body}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFff0336),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove the loading indicator
      // Show error message with customized AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.black,
          title: Text(
            'Submission Error',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            'An error occurred while submitting your data.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336),
                ),
              ),
            ),
          ],
        ),
      );
      print("Error submitting data: $e");
    }
  }

  // Clear all input fields
  void clearAllInputs() {
    exerciseControllers.forEach((id, controller) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Black background
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFff0336)))
          : _isError
          ? Center(
        child: Text(
          'Failed to load data.',
          style: TextStyle(color: Color(0xFFff0336), fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // Display Fitbit Data
              if (_stepsData != null)
                DataCard(
                  title: 'Steps Today',
                  value: _stepsData!['activities-steps'][0]['value'],
                ),
              if (_sleepData != null)
                DataCard(
                  title: 'Sleep Duration',
                  value: _sleepData!['summary']['totalMinutesAsleep'] != null
                      ? '${(_sleepData!['summary']['totalMinutesAsleep'] / 60).toStringAsFixed(1)} hrs'
                      : 'N/A',
                ),
              if (_heartRateData != null)
                DataCard(
                  title: 'Average Heart Rate',
                  value: _heartRateData!['activities-heart'][0]['value']['restingHeartRate'] != null
                      ? _heartRateData!['activities-heart'][0]['value']['restingHeartRate'].toString()
                      : 'N/A',
                ),
              SizedBox(height: 20),
              // Fitness Tests Section
              Text(
                'Fitness Tests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              fitnessTests.isEmpty
                  ? Text(
                'No fitness tests available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
                  : Column(
                children: fitnessTests.map((test) {
                  return Card(
                    elevation: 4,
                    color: const Color(0xFF1F1F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      title: Text(
                        test.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      children: test.sections.map((section) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: section.exercises.length,
                                itemBuilder: (context, index) {
                                  var exercise = section.exercises[index];
                                  return ExerciseCard(
                                    exercise: exercise,
                                    controller: exerciseControllers[exercise.id]!,
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
            ],
          ),
        ),
      ),
      floatingActionButton: (_isLoading || _isError || fitnessTests.isEmpty)
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

// Data Card Widget for Displaying Fitbit Data
class DataCard extends StatelessWidget {
  final String title;
  final String value;

  DataCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: Color(0xFFff0336),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Exercise Card Widget with Customized TextField
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
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0, bottom: 8),
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
                  // Implement video playback functionality here
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFff0336), // Red background color
                    borderRadius: BorderRadius.circular(15), // Rounded edges with radius 15
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              SizedBox(height: 10),
              // Customized TextField
              TextField(
                controller: controller,
                style: TextStyle(
                  color: Colors.white, // Input text color
                ),
                cursorColor: Color(0xFFff0336), // Cursor color
                decoration: InputDecoration(
                  labelText: 'Enter your value',
                  labelStyle: TextStyle(
                    color: Colors.white, // Label text color
                  ),
                  hintText: '0000',
                  hintStyle: TextStyle(
                    color: Colors.white70, // Hint text color
                  ),
                  filled: true,
                  fillColor: Colors.transparent, // Background fill color
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white, // Border color when not focused
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFFff0336), // Border color when focused
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Border color on error
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Border color when focused and in error
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

// Fitbit API Service to Fetch Data
class FitbitApiService {
  final String accessToken;

  FitbitApiService({required this.accessToken});

  // Fetch Steps Data
  Future<Map<String, dynamic>?> fetchSteps(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/activities/steps/date/$date/1d.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch steps: ${response.statusCode}');
    }
    return null;
  }

  // Fetch Sleep Data
  Future<Map<String, dynamic>?> fetchSleep(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1.2/user/-/sleep/date/$date.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch sleep data: ${response.statusCode}');
    }
    return null;
  }

  // Fetch Heart Rate Data
  Future<Map<String, dynamic>?> fetchHeartRate(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/activities/heart/date/$date/1d.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch heart rate data: ${response.statusCode}');
    }
    return null;
  }
}

// Fitness Test Models
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
*//*



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

// Replace with your actual backend API URL
const String backendUrl = "https://yourbackend.com";

class FitbitAuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  // Fitbit app credentials (only clientId is needed on client side)
  final String _clientId = '23PR55';
  final String _redirectUrl = 'myapp://callback';

  // Fitbit OAuth endpoints
  final String _authorizationEndpoint = 'https://www.fitbit.com/oauth2/authorize';
  final String _tokenEndpoint = 'https://api.fitbit.com/oauth2/token';

  // Define the scopes you need
  final List<String> _scopes = [
    'activity',
    'heartrate',
    'sleep',
    'profile',
  ];

  // Authenticate and obtain authorization code
  Future<String?> authenticate() async {
    try {
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authorizationEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          scopes: _scopes,
        ),
      );

      if (result != null) {
        // Send authorization code to backend for token exchange
        final response = await http.post(
          Uri.parse('$backendUrl/auth/fitbit'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'code': result.authorizationCode}),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          // Assuming backend returns access and refresh tokens
          return data['access_token'];
        } else {
          print('Backend token exchange failed: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
    return null;
  }
}

// Fitbit Login Page
class FitbitLoginPage extends StatefulWidget {
  @override
  _FitbitLoginPageState createState() => _FitbitLoginPageState();
}

class _FitbitLoginPageState extends State<FitbitLoginPage> {
  final FitbitAuthService _authService = FitbitAuthService();

  void _login() async {
    final accessToken = await _authService.authenticate();
    if (accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            accessToken: accessToken,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Black background
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Fitbit Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFff0336), // Red background color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded edges
            ),
          ),
          child: Text(
            'Login with Fitbit',
            style: TextStyle(
              color: Colors.white, // White text color
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Page to Display Fitbit Data and Fitness Tests
class DashboardPage extends StatefulWidget {
  final String accessToken;

  DashboardPage({required this.accessToken});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  bool _isError = false;

  // Fitness Tests Variables
  List<FitnessTest> fitnessTests = [];
  Map<int, TextEditingController> exerciseControllers = {};

  @override
  void initState() {
    super.initState();
    fetchFitnessTests();
  }

  // Fetch Fitness Tests from Your API
  Future<void> fetchFitnessTests() async {
    final String url = "$backendUrl/workout/tests";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer ${widget.accessToken}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          fitnessTests = data.map((item) => FitnessTest.fromJson(item)).toList();
          _isLoading = false;
        });

        // Initialize controllers for each exercise
        initializeControllers();
      } else {
        print("Error fetching fitness tests: ${response.statusCode}");
        print("Response: ${response.body}");
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    } catch (e) {
      print("Error fetching fitness tests: $e");
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  // Initialize TextEditingControllers for each exercise
  void initializeControllers() {
    for (var test in fitnessTests) {
      for (var section in test.sections) {
        for (var exercise in section.exercises) {
          exerciseControllers[exercise.id] = TextEditingController();
        }
      }
    }
  }

  // Handle Submission of Exercise Data
  Future<void> submitExerciseData() async {
    // Convert Map<int, String> to Map<String, String>
    Map<String, String> submissionData = {};

    bool allFilled = true;

    exerciseControllers.forEach((id, controller) {
      if (controller.text.trim().isEmpty) {
        allFilled = false;
      }
      submissionData[id.toString()] = controller.text.trim();
    });

    if (!allFilled) {
      // Show customized AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded curved edges
          ),
          backgroundColor: Colors.black, // Dialog background color
          title: Text(
            'Incomplete Submission',
            style: TextStyle(
              color: Colors.white, // Title text color
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
      builder: (context) => Center(child: CircularProgressIndicator(color: Color(0xFFff0336))),
    );

    // Make submitUrl dynamic based on test ID
    if (fitnessTests.isEmpty) {
      Navigator.of(context).pop(); // Remove loading indicator
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.black,
          title: Text(
            'No Test Found',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            'There is no fitness test to submit data for.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336),
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
    final String submitUrl = "$backendUrl/workout/tests/$testId";

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Authorization': "Bearer ${widget.accessToken}",
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      Navigator.of(context).pop(); // Remove the loading indicator

      if (response.statusCode == 200) {
        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Success',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Your exercise data has been submitted successfully!',
              style: TextStyle(
                color: Colors.white,
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
                    color: Color(0xFFff0336),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Show error message with customized AlertDialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.black,
            title: Text(
              'Submission Failed',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              'Error: ${response.statusCode}\n${response.body}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFff0336),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove the loading indicator
      // Show error message with customized AlertDialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.black,
          title: Text(
            'Submission Error',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            'An error occurred while submitting your data.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFff0336),
                ),
              ),
            ),
          ],
        ),
      );
      print("Error submitting data: $e");
    }
  }

  // Clear all input fields
  void clearAllInputs() {
    exerciseControllers.forEach((id, controller) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Black background
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFff0336)))
          : _isError
          ? Center(
        child: Text(
          'Failed to load data.',
          style: TextStyle(color: Color(0xFFff0336), fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              // Display Fitbit Data
              if (_stepsData != null)
                DataCard(
                  title: 'Steps Today',
                  value: _stepsData!['activities-steps'][0]['value'],
                ),
              if (_sleepData != null)
                DataCard(
                  title: 'Sleep Duration',
                  value: _sleepData!['summary']['totalMinutesAsleep'] != null
                      ? '${(_sleepData!['summary']['totalMinutesAsleep'] / 60).toStringAsFixed(1)} hrs'
                      : 'N/A',
                ),
              if (_heartRateData != null)
                DataCard(
                  title: 'Average Heart Rate',
                  value: _heartRateData!['activities-heart'][0]['value']['restingHeartRate'] != null
                      ? _heartRateData!['activities-heart'][0]['value']['restingHeartRate'].toString()
                      : 'N/A',
                ),
              SizedBox(height: 20),
              // Fitness Tests Section
              Text(
                'Fitness Tests',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              fitnessTests.isEmpty
                  ? Text(
                'No fitness tests available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
                  : Column(
                children: fitnessTests.map((test) {
                  return Card(
                    elevation: 4,
                    color: const Color(0xFF1F1F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.white,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      title: Text(
                        test.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      children: test.sections.map((section) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: section.exercises.length,
                                itemBuilder: (context, index) {
                                  var exercise = section.exercises[index];
                                  return ExerciseCard(
                                    exercise: exercise,
                                    controller: exerciseControllers[exercise.id]!,
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
            ],
          ),
        ),
      ),
      floatingActionButton: (_isLoading || _isError || fitnessTests.isEmpty)
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

// Data Card Widget for Displaying Fitbit Data
class DataCard extends StatelessWidget {
  final String title;
  final String value;

  DataCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: Color(0xFFff0336),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Exercise Card Widget with Customized TextField
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
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0, bottom: 8),
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
                  // Implement video playback functionality here
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFff0336), // Red background color
                    borderRadius: BorderRadius.circular(15), // Rounded edges with radius 15
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              SizedBox(height: 10),
              // Customized TextField
              TextField(
                controller: controller,
                style: TextStyle(
                  color: Colors.white, // Input text color
                ),
                cursorColor: Color(0xFFff0336), // Cursor color
                decoration: InputDecoration(
                  labelText: 'Enter your value',
                  labelStyle: TextStyle(
                    color: Colors.white, // Label text color
                  ),
                  hintText: '0000',
                  hintStyle: TextStyle(
                    color: Colors.white70, // Hint text color
                  ),
                  filled: true,
                  fillColor: Colors.transparent, // Background fill color
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white, // Border color when not focused
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFFff0336), // Border color when focused
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Border color on error
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red, // Border color when focused and in error
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

// Fitbit API Service to Fetch Data
class FitbitApiService {
  final String accessToken;

  FitbitApiService({required this.accessToken});

  // Fetch Steps Data
  Future<Map<String, dynamic>?> fetchSteps(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/activities/steps/date/$date/1d.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch steps: ${response.statusCode}');
    }
    return null;
  }

  // Fetch Sleep Data
  Future<Map<String, dynamic>?> fetchSleep(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1.2/user/-/sleep/date/$date.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch sleep data: ${response.statusCode}');
    }
    return null;
  }

  // Fetch Heart Rate Data
  Future<Map<String, dynamic>?> fetchHeartRate(String date) async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/activities/heart/date/$date/1d.json'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch heart rate data: ${response.statusCode}');
    }
    return null;
  }
}

// Fitness Test Models
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
