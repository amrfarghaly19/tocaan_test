import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../configre/globale_variables.dart';
import '../theme/loading.dart';
class ChangePasswordPage extends StatefulWidget {

  final String Token;
  ChangePasswordPage({required this.Token});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscured = true;
  bool _isObscured2 = true;
  bool _isObscured3 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password Field
            Text("Current Password", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _currentPasswordController,
              obscureText: _isObscured,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // New Password Field
            Text("New Password", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              obscureText: _isObscured2,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured2 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured2 = !_isObscured2;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // Confirm Password Field
            Text("Confirm Password", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
    obscureText: _isObscured3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
    suffixIcon: IconButton(
    icon: Icon(
      _isObscured3 ? Icons.visibility_off : Icons.visibility,
    color: Colors.grey,
    ),
    onPressed: () {
    setState(() {
      _isObscured3 = !_isObscured3;
    });
    },
    ),
              ),
            ),

            SizedBox(height: 24),

            // Change Password Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement password change logic here
                  _submitData();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff0336),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitData() async {


    if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty ) {
      print("Please ensure all required fields are filled.");
      _showSnackBar("Please ensure all required fields are filled" ?? 'Login successful!', Colors.red);
      return;
    }
    try {
      OverlayLoadingProgress.start(context,
        widget: Center(
          child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: const AspectRatio(
              aspectRatio: 1 / 3,
              child: LoadingLogo(),
            ),
          ),
        ),
      );
      var url = Uri.parse("${Config.baseURL}/settings/change-password");
      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = 'Bearer ${widget.Token}'
        ..headers['Accept'] =  "application/json"
        ..fields['current_password'] = _currentPasswordController.text
        ..fields['password'] = _newPasswordController.text
        ..fields['password_confirmation'] = _confirmPasswordController.text;


      var response = await request.send();
      final responseString = await response.stream.bytesToString();

     // Map<String, dynamic>? allData;
      Map<String, dynamic>? answer = jsonDecode(responseString);
      print(answer);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Has been Changed")));
        OverlayLoadingProgress.stop();
        Navigator.pop(context, 'refresh');

      } else {
        OverlayLoadingProgress.stop();
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${answer?['message']}")));
      }
    } catch (e) {
      print("Error: $e");
      OverlayLoadingProgress.stop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
    }
  }
  void _showSnackBar(String message, Color color) {
    print("SnakBar");
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
