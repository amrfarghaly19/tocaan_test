import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Auth/login.dart';

class DeleteAccountDialog extends StatelessWidget {
  final String Token;
  DeleteAccountDialog({required this.Token});

  late bool rememberMe;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    // Confirm delete action



                    // Make the DELETE request
                    var url = Uri.parse("{{base_url}}/delete-account");
                    var headers = {
                      'Authorization': 'Bearer ${Token}',
                      'Content-Type': 'application/json',
                    };

                    try {
                      var response = await http.delete(url, headers: headers);
                      if (response.statusCode == 200) {
                        // Account deleted successfully
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.clear(); // Clear all saved preferences
                        print("Account deleted successfully");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false,
                        );
                      } else {
                        // Handle error response
                        print("Failed to delete account: ${response.body}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Failed to delete account. Please try again."),
                        ));
                      }
                    } catch (e) {
                      // Handle network errors
                      print("Error deleting account: $e");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("An error occurred. Please check your connection."),
                      ));
                    }
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFFF1F0EF)
                          : Color(0xFF293F76),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFFF1F0EF)
                          : Color(0xFF293F76),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
