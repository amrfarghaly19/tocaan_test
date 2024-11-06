import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymjoe/profile/change_password.dart';
import 'package:gymjoe/profile/personal_information.dart';
import 'package:gymjoe/profile/time_page.dart';

import 'diet_page_profile.dart';








// Main Profile Page
class ProfilePage extends StatefulWidget {
  final String Token;

  ProfilePage({Key? key, required this.Token}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Map<String, dynamic>> profileOptions;

  @override
  void initState() {
    super.initState();
    profileOptions = [
      {
        "icon": "assets/svg/ganeral/profile.svg",
        "label": "Personal Information",
        "page": PersonalInformationPage(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/padlock.svg",
        "label": "Change Password",
        "page": ChangePasswordPage(Token: widget.Token),
      },
      {
        "icon": "assets/icons/diet.svg",
        "label": "Diet",
        "page": DietPreferencesPage(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/clock.svg",
        "label": "Time",
        "page": SchedulePage(Token: widget.Token),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profileOptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profileOptions[index]["page"]),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                 /* boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],*/
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        profileOptions[index]["icon"]!,
                       // color: Colors.red,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      profileOptions[index]["label"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
