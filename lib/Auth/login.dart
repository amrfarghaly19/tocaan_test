import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/theme/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/home/home.dart';
import 'package:gymjoe/moves/fade.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configre/globale_variables.dart';
import '../localization/change_language.dart';
import '../theme/widgets/bottombar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController phonenumber = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences logindata;
  String Token = "";

  @override
  Widget build(BuildContext context) {
  //  phonenumber.text = "+203510012934";
    // passwordController.text = "+203510012934";

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LanguageSelect(
                  Token: "",
                ),
              );
            },
            icon: Icon(Icons.language_outlined)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/logogym.png',
                  width: 277,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'sign_message'.tr(context),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              PhoneInput(),
              const SizedBox(height: 19),
              PasswordInput(),
              const SizedBox(height: 16),
              SignInButton(),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(FadePageRoute(
                    page: ResetPasswordScreen(),
                  ));
                },
                child: Text(
                  'Forgot Password'.tr(context),
                  style: TextStyle(
                    color: Color(0xFFDADADA),
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PhoneInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: const Color(0xFF252525),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/phone.svg',
            width: 27,
            height: 27,
            color: Colors.white,
          ),
          const SizedBox(width: 11),
          Container(
            width: 3,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0XFFFF0336), width: 3),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextFormField(
              controller: phonenumber,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your Phone Number'.tr(context),
                hintStyle: TextStyle(color: Colors.white54),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

  Widget PasswordInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: const Color(0xFF252525),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/lockpass.svg',
            width: 27,
            height: 27,
            color: Colors.white,
          ),
          const SizedBox(width: 14),
          Container(
            width: 3,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0XFFFF0336), width: 3),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: passwordController,
              obscureText: _obscureText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your password'.tr(context),
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/eyeoff.svg',
              width: 27,
              height: 27,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget SignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          /* Navigator.of(context).push(FadePageRoute(
            page: Home(),
          ));*/

          OnTapLogin();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFFFF0336),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'sign_in'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Future<void> OnTapLogin() async {
    OverlayLoadingProgress.start(
      context,
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
    await _loadSelectedLanguage();

    var url = Uri.parse("${Config.baseURL}/login");
    var request = http.MultipartRequest('POST', url);

    // Add header
    request.headers.addAll({
      'Accept': 'application/json',
    });

    // Add fields

    request.fields['phone'] = phonenumber.text;
    request.fields['password'] = passwordController.text;
    //  request.fields['phone'] = phonenumber.text;
    //  request.fields['password'] = passwordController.text;

    try {
      // Call request.send() only once
      var response = await request.send();

      // Check if response is successful
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var loginMap = json.decode(responseData);

        // Check if loginMap is not null and has the 'access_token' key
        if (loginMap != null && loginMap.containsKey('access_token')) {
          String accessToken =
              loginMap['access_token']; // Safely retrieve the access token
          SharedPreferences prefs = await SharedPreferences.getInstance();

          print('Access Token: $accessToken'); // Debugging line to print token

          // Store the token in shared preferences
          prefs.setBool('rememberMe', true);
          prefs.setBool('tutorial', true);
          prefs.setString('Token', accessToken);
          prefs.setBool('LogedIn', true);
          setState(() {
            Token = accessToken;
          });
          await _updateLanguage();

          _showSnackBar(
              loginMap['message'] ?? 'Login successful!'.tr(context), Color(0xFF1F1F1F));
          Navigator.of(context).pushAndRemoveUntil(
            FadePageRoute(
              page: Bottombar(Token: accessToken),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // Handle case when access_token is missing
          _showSnackBar('Error: Access token not found', Color(0XFFFF0336));
        }

        OverlayLoadingProgress.stop();
      } else {
        var responseData = await response.stream.bytesToString();
        var loginMap = json.decode(responseData);
        OverlayLoadingProgress.stop();
        _showSnackBar(
            loginMap['message'] ?? 'An error occurred.', Color(0XFFFF0336));
      }
    } catch (e) {
      print('Error: $e');
      OverlayLoadingProgress.stop();
      _showSnackBar('An error occurred. Please try again.', Color(0XFFFF0336));
    }
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

  Future<void> _updateLanguage() async {
    var url = Uri.parse("${Config.baseURL}/change-language/$selectedLanguage");
    var request = http.MultipartRequest('POST', url);

    // Add header
    request.headers.addAll(
        {'Accept': 'application/json', 'Authorization': 'Bearer ${Token}'});
    var response2 = await request.send();
    var responseData = await response2.stream.bytesToString();
    var loginMap = json.decode(responseData);

    print(loginMap);
  }

  void _showSnackBar(String message, Color color) {
    print("SnakBar");
    final snackBar = SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white),),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
