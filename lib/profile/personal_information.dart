

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configre/globale_variables.dart';

class PersonalInformationPage extends StatefulWidget {
  final String Token;
  PersonalInformationPage({required this.Token});

  @override
  _PersonalInformationPageState createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();

  Map<String, dynamic>? allData;
  List<Map<String, dynamic>> countries = [];
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    fetchCountries(); // Fetch countries initially
    fetchProfileData(); // Fetch profile data initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Personal Information"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Dropdown
            Text("Country", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;

                });
              },
              items: countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country['id'].toString(),
                  child: Text(country['name'], style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: Color(0xFF1F1F1F),
            ),
            SizedBox(height: 16),

            // Address Field
            Text("Address", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Birthday Field with Date Picker
            Text("Birthday", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _birthdayController,
              style: TextStyle(color: Colors.white),
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Job Description Field
            Text("Job Description", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _jobDescriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement save action here
                  updateProfile();
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

  // Date Picker for Birthday
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
      //  _birthdayController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        _birthdayController.text ="${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  // Fetch Profile Data
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
        final data = jsonDecode(response.body);

        setState(() {
          allData = data['data'];
          _addressController.text = allData?['address'] ?? "";
          _birthdayController.text = allData?['birthday'] ?? "";
          _jobDescriptionController.text = allData?['job_description'] ?? "";

          // Set initial country value based on country_id from profile
          if (allData?['country_id'] != null) {
            _selectedCountry = allData?['country_id'].toString();
          }
        });
      } else {
        print('Failed to load profile data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  // Fetch Countries
  Future<void> fetchCountries() async {
    final url = Uri.parse('${Config.baseURL}/get-countries');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          countries = List<Map<String, dynamic>>.from(data['data']);

          // Ensure _selectedCountry matches one of the items exactly by ID
          if (_selectedCountry != null &&
              !countries.any((country) => country['id'].toString() == _selectedCountry)) {
            _selectedCountry = null;
          }
        });
      } else {
        print('Failed to load countries data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching countries data: $e');
    }
  }



  Future<void> updateProfile() async {
    final url = Uri.parse('${Config.baseURL}/settings/profile'); // Replace with the correct endpoint if necessary

    // Validate required fields
    if (_addressController.text.isEmpty || _birthdayController.text.isEmpty || _jobDescriptionController.text.isEmpty || _jobDescriptionController.text.isEmpty) {
      print("Please ensure all required fields are filled.");
      return;
    }

    // Construct the request body
    final Map<String, dynamic> requestBody = {
      "name": allData?['name'] ?? "",
      "birthday": _birthdayController.text,
      "country_id": _selectedCountry,
      "job_description": _jobDescriptionController.text,
      "address": _addressController.text,
      "have_disease": true,
      "have_injures": true,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully.");
        Navigator.pop(context);
      } else {
        print("Failed to update profile. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

}
