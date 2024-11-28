import 'package:flutter/material.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/workout/workout_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../configre/globale_variables.dart';
import '../moves/fade.dart';
import '../theme/loading.dart';
import '../theme/widgets/bottombar_provider.dart';

class WorkoutPlansPage extends StatefulWidget {
  final String Token;

  WorkoutPlansPage({Key? key, required this.Token}) : super(key: key);

  @override
  _WorkoutPlansPageState createState() => _WorkoutPlansPageState();
}

class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  List<dynamic> workoutPlans = [];

String cookies2 = "";
  @override
  void initState() {
    super.initState();
    fetchWorkoutPlans();
  }
  Future<String?> getCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }
  // Function to fetch workout plans data from an API
  Future<void> fetchWorkoutPlans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString('cookies')!;

    /*cookies= (await getCookies())!;
    cookies2= "laravel_session=z3uRiMkVY0raDqzynCSdACOgqFG03qhosD9BbXr9";*/
    print(cookies);
    print(cookies2);


    var url = Uri.parse("${Config.baseURL}/workout/types");
    var request = http.MultipartRequest('GET', url);

    // Add headers
    request.headers.addAll({
      'Authorization': "Bearer ${widget.Token}",
      'Accept': 'application/json',
      'Connection':'keep-alive',
      'Cookie': cookies,
    });


      var response = await request.send();
      var responseData = await response.stream.bytesToString();


    if (response.statusCode == 200) {
      setState(() {
        workoutPlans = json.decode(responseData)['data'];
        print(workoutPlans);
      });
    } else {
      throw Exception('Failed to load workout plans');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){

          Provider.of<NavigationProvider>(context, listen: false).setIndex(0); // For example, to navigate to the third tab

          // Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),

        title: Text('Workout Plans'.tr(context),style: TextStyle(color: Colors.white),),
     /*   leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Provider.of<NavigationProvider>(context, listen: false).setIndex(3); // For example, to navigate to the third tab


              // Handle profile
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb Navigation

            SizedBox(height: 20),
            // Check if data has been loaded
            workoutPlans.isEmpty
                ? Center(child: LoadingLogo())
                : Expanded(
              child: ListView.builder(
                itemCount: workoutPlans.length,
                itemBuilder: (context, index) {
                  var plan = workoutPlans[index];
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(FadePageRoute(
                        page: WorkoutsScreen(Token:widget.Token, slug:plan['slug']),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: WorkoutCard(
                        imageUrl:plan['image'],  // Assuming your API provides image URL
                        title: plan['type_name'],        // Assuming your API provides a title
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card widget for individual workout plans
class WorkoutCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  WorkoutCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl,

          ),

         // image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
