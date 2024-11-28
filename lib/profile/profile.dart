import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/profile/change_password.dart';
import 'package:gymjoe/profile/personal_information.dart';
import 'package:gymjoe/profile/time_page.dart';
import 'package:gymjoe/profile/workout_settings.dart';
import 'package:provider/provider.dart';

import '../configre/globale_variables.dart';
import '../localization/change_language.dart';
import '../theme/loading.dart';
import '../theme/widgets/bottombar_provider.dart';
import '../theme/widgets/logout.dart';
import 'delete_account.dart';
import 'diet_page_profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;







// Main Profile Page
class ProfilePage extends StatefulWidget {
  final String Token;

  ProfilePage({Key? key, required this.Token}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Map<String, dynamic>> profileOptions;
  Map<String, dynamic>? allData;

  String Photo = "";
  String Name = "";
  String Code = "";

bool Loading = false;
  @override
  void initState() {
    super.initState();
    fetchProfileData();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    profileOptions = [
      {
        "icon": "assets/svg/ganeral/profile.svg",
        "label": "Personal Information".tr(context),
        "page": PersonalInformationPage(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/padlock.svg",
        "label": "Change Password".tr(context),
        "page": ChangePasswordPage(Token: widget.Token),
      },
      {
        "icon": 'assets/icons/foodnewlast.svg',
        "label": "Diet".tr(context),
        "page": DietPreferencesPage(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/clock.svg",
        "label": "Time Settings".tr(context),
        "page": SchedulePage(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/worktime2.svg",
        "label": "Workout Settings".tr(context),
        "page": WorkoutSettings(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/Language.svg",
        "label": "Language".tr(context),
        "page": LanguageSelect(Token: widget.Token),
      },
      {
        "icon": "assets/svg/ganeral/logout.svg",
        "label": "Logout".tr(context),
        "page": logingout(),
      },
      {
        "icon": "assets/svg/ganeral/deleteaccount.svg",
        "label": "Delete Account".tr(context),
        "page": DeleteAccountDialog(Token: widget.Token),
      },
    ];


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        leading: IconButton(onPressed: (){

          Provider.of<NavigationProvider>(context, listen: false).setIndex(0); // For example, to navigate to the third tab

          // Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),

        title: Text("profile".tr(context),style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child:


        Code == "" ? Center(child: LoadingLogo()):
        Column(
          children: [
            ClipOval(
              child: Image.network(
                Photo ??"",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
             Name ??"",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color:Color(0xFFFF0336),
                borderRadius: BorderRadius.circular(12),
                /* boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],*/
              ),

              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                 Code??"",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: profileOptions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {


                      index == 5?  showDialog(
                        context: context,
                        builder: (context) => LanguageSelect(Token: widget.Token,),
                      ): index ==6?  showDialog(
                        context: context,
                        builder: (context) => logingout(),
                      ):  index ==7?  showDialog(
                        context: context,
                        builder: (context) => DeleteAccountDialog(Token: widget.Token) )
                          : Navigator.push(
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
                               // color: Colors.red.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                profileOptions[index]["icon"]!,
                               // color: Colors.red,
                                width: 32,
                                height: 32,
                                color:  Color(0XFFFF0336)
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
            ),
            SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }

  Future<void> fetchProfileData() async {
    setState(() {
      Loading == true;
    });
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

           Photo = allData?['avatar'] ?? "";
           Name = allData?['name'] ?? "";
           Code = allData?['code'] ?? "";
Loading = false;

        });
      } else {
        print('Failed to load profile data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }


}
