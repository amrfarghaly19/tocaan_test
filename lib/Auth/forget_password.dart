import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymjoe/Auth/login.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/theme/loading.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../configre/globale_variables.dart';
import '../moves/fade.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {




  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
            child: Column(
              children: [

                const SizedBox(height: 90),
                Image.asset(
                  'assets/logogym.png',
                  fit: BoxFit.contain,
                  width: 277,
                ),
                const SizedBox(height: 30),
                 Text(
                  'Reset Your Password'.tr(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                 EmailInput(),
                const SizedBox(height: 21),
                 ResetButton(),
                const SizedBox(height: 21),
                 CustomDivider(),
                const SizedBox(height: 13),
                Text(
                  'Contact sales via Whatsapp'.tr(context),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 14),
                 TelegramButton(),
                const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(FadePageRoute(
                        page: LoginPage(),
                      ));
                    },
                    child:  Text(
                      'Back to Login'.tr(context),
                      style: TextStyle(
                        color: Color(0xFFDADADA),
                        fontSize: 19,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> OnTapRessetPassword() async {
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

    var url = Uri.parse("${Config.baseURL}/password/forget-password");
    var request = http.MultipartRequest('POST', url);

    // Add header
    request.headers.addAll({
      'Accept': 'application/json',
    });

    // Add fields
    request.fields['email'] = emailController.text;


    try {
      // Call request.send() only once
      var response = await request.send();

      // Check if response is successful
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var loginMap = json.decode(responseData);

        // Check if loginMap is not null and has the 'access_token' key
        if (loginMap != null && loginMap.containsKey('access_token')) {
          String accessToken = loginMap['access_token']; // Safely retrieve the access token
          SharedPreferences prefs = await SharedPreferences.getInstance();

          print('Access Token: $accessToken'); // Debugging line to print token

          // Store the token in shared preferences
          prefs.setBool('rememberMe', true);
          prefs.setString('Token', accessToken);
          prefs.setBool('LogedIn', true);

          _showSnackBar(loginMap['message'] ?? 'Login successful!', Colors.blue);
        } else {
          // Handle case when access_token is missing
          _showSnackBar('Error: Access token not found', Color(0XFFFF0336));
        }

        OverlayLoadingProgress.stop();
      } else {
        var responseData = await response.stream.bytesToString();
        var loginMap = json.decode(responseData);
        OverlayLoadingProgress.stop();
        _showSnackBar(loginMap['error'] ?? 'An error occurred.', Color(0XFFFF0336));
      }
    } catch (e) {
      print('Error: $e');
      OverlayLoadingProgress.stop();
      _showSnackBar('An error occurred. Please try again.', Color(0XFFFF0336));
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

  Widget EmailInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/mail.svg',
            width: 27,
            height: 27,
          ),
          const SizedBox(width: 17),
          Container(
            width: 3,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0XFFFF0336), width: 3),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: TextFormField(
              controller: emailController,

              style:  TextStyle(color: Colors.white, fontSize: 16),
              decoration:  InputDecoration(
                hintText: "Enter Your Email".tr(context),
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget ResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          OnTapRessetPassword();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFFFF0336),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        ),
        child:  Text(
          'Reset Password'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  Widget CustomDivider() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: screenWidth/4,
          color: Colors.white,
        ),
        Container(
          width: screenWidth/4,
          child: Center(
            child: Text(
              'Or'.tr(context),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        Container(
          height: 1,
          width: screenWidth/4,
          color: Colors.white,
        ),
      ],
    );
  }


  Widget TelegramButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: ()async {
          // Handle Telegram action

          final Uri whatsappUri = Uri.parse('https://wa.me/201062599157');
          if (await canLaunchUrl(whatsappUri)) {
          await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
          } else {
          // Handle the error, e.g., show a SnackBar or Dialog
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch WhatsApp.')),
          );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        ),
        child:  Text(
          'Whatsapp'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}







