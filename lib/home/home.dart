
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gymjoe/files/files_preview.dart';
import 'package:gymjoe/injures/injures.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/medical_cases/medicale_cases.dart';
import 'package:intl/intl.dart' as lol;
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../activity/activity_page.dart';
import '../configre/globale_variables.dart';
import '../diet_screen/diet_screen.dart';
import '../diet_screen/e_book.dart';
import '../inbody/inbody_screen.dart';
import '../measurements/measurements.dart';
import '../moves/fade.dart';
import '../tests/test_screen.dart';
import '../theme/widgets/bottombar.dart';
import '../theme/widgets/bottombar_provider.dart';
import '../workout/workout_screen.dart';
import 'cardio_video.dart';



class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28.5,
              backgroundImage: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/facde3a9c3c52035ca673088762459ab52d311003a4024a246063f7432e5f4a2?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9'),
            ),
            SizedBox(width: 11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!!!',
                  style: TextStyle(
                    color: Color.fromRGBO(249, 250, 254, 0.42),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '3am. Ayoub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/b3c38c5e-c12a-4970-b3b9-dfdeee2a4400?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
              width: 47,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 17),
            Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/550f075f9f9dd2496709caae261986535bd4b44993d9152c6d46979964ee8421?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
              width: 27,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}


class WorkoutProgress extends StatefulWidget {
  const WorkoutProgress({Key? key}) : super(key: key);

  @override
  State<WorkoutProgress> createState() => _WorkoutProgressState();
}

class _WorkoutProgressState extends State<WorkoutProgress> {
  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(75.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Progress !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 9),
              Text(
                '14 Exercise left',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF2F2D2C),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SimpleCircularProgressBar(
                animationDuration: 2,
                backColor: Colors.transparent,
                maxValue: 100,
                progressColors: const [Color(0XFFFF0336), Color(0XFFFF0336)],
                backStrokeWidth:5,
                progressStrokeWidth: 5,
                valueNotifier: valueNotifier,
                mergeMode: true,
                onGetText: (double value) {
                  return Text(
                    '${75.toString()}'+"%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),


           /*   Text(
                '75%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Josefin Sans',
                ),
              ),*/
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
class ExerciseCards extends StatefulWidget {
  final String Token;
  const ExerciseCards({Key? key, required this.Token}) : super(key: key);

  @override
  State<ExerciseCards> createState() => _ExerciseCardsState();
}

class _ExerciseCardsState extends State<ExerciseCards> {

  late ValueNotifier<double> valueNotifier;
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  var loginMap2;
  DateTime now = DateTime.now();
  var loginMap;

  String Guidlines="";
  bool isLoading = true;



  void onStepCount(StepCount event) async {
    setState(() {
      _steps = event.steps;
    });
    await saveSteps(_steps);
  }

  void onStepCountError(error) {
    print('Pedometer Error: $error');
  }

  Future<void> saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_steps', steps);
  }

  Future<int> loadSteps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('daily_steps') ?? 0;
  }
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  // Function to format duration as mm:ss
  String _formatDuration(Duration duration) {
    return lol.DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds));
  }

  Future<void> getCardio() async {





    var url = Uri.parse("${Config.baseURL}/workout/cardio");
    var request = http.MultipartRequest('GET', url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString('cookies')!;

    // Add headers
    request.headers.addAll({
      'Authorization': "Bearer ${widget.Token}",
      'Accept': 'application/json',
    'Cookie': cookies,
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          loginMap2 = json.decode(responseData);
          //   print(loginMap);
          isLoading = false;
          print("num is $loginMap2");

          isLoading = false;
        });



        _videoController = VideoPlayerController.network(loginMap2!['data']['video'])
          ..initialize().then((_) {
            setState(() {});
           /* _videoController.play();
            _isPlaying = true;*/

            // Listen for updates to the video's position
            _videoController.addListener(() {
              setState(() {
                _currentPosition = _videoController.value.position;
              });
            });
          });
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: $responseData");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      // OverlayLoadingProgress.stop();
    }
  }

  void scheduleDailyReset() {
    // Implement scheduling logic here
    // For example, using android_alarm_manager_plus
  }
  late VideoPlayerController _videoController;

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(75.0);
    loadSteps().then((value) {
      setState(() {
        _steps = value;
      });
    });
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    scheduleDailyReset();

    getCardio();
  }






  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildCardioCard(),
              SizedBox(height: 13),
                 // _buildSleepCard(),
            ],
          ),
        ),
        SizedBox(width: 18),
        Expanded(
          child: Column(
            children: [
              _buildStepsCard(),
              SizedBox(height: 13),
           //   _buildSessionCard(),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildCardioCard() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0XFFFF0336),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cardio',
                style: TextStyle(
                  color: Color(0xFFDADADA),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/fire.svg',
                width: 23,
                height: 23,
                //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
              ),
             /* Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/0e01df0ce9361c1ee3732899d7913a4c4c5ac678a3decf81e6b8146f2cc836d5?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
                width: 23,
                fit: BoxFit.contain,
              ),*/
            ],
          ),
          SizedBox(height: 19),
          Align(
            alignment: Alignment.centerRight,
            child:Container(
              width: 143,
              child: /*SimpleCircularProgressBar(
                animationDuration: 2,

                backColor: Colors.white,
                maxValue: 100,
                progressColors: const [Colors.black, Colors.black],
                startAngle: 180,
                backStrokeWidth:16,
                progressStrokeWidth: 16,
                valueNotifier: valueNotifier,
                mergeMode: true,
                onGetText: (double value) {
                  return Text(
                    '${75.toString()}'+"%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              )*/

              loginMap2 != null ?  /* Column(
                children: [
                  ClipOval(

                    child: CachedNetworkImage(
                      imageUrl:   loginMap2['data']['image'],

                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                    ),
                  ),
                  SizedBox(height: 10,),
                  
                  Text(loginMap2['data']['type_name'], style: TextStyle(
                    color: Color(0xFFDADADA),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),)
                ],
              )*/

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => FullScreenVideoSheet(loginMap2: loginMap2),
                    ),
                  );

                },
                child: Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: loginMap2!['data']['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      loginMap2!['data']['type_name'],
                      style: TextStyle(
                        color: Color(0xFFDADADA),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              : SizedBox(),
              
              

            ),

        /*    Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/ff591bcc720695c6f67c2b8fa5bd1df5fdadae8acb780716d51bdd64b3fe0fb3?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
              width: 143,
              fit: BoxFit.contain,
            ),*/
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCard() {
    return Container(
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 46),
              Text(
                '5/8',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
         // SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: 50,
                height: 50,
                child: SimpleCircularProgressBar(
                  animationDuration: 2,
                  backColor: Colors.black,
                  maxValue: 100,
                  progressColors: const [Color(0XFFFF0336), Color(0XFFFF0336)],
                  startAngle: 180,
                  backStrokeWidth:12,

                  progressStrokeWidth: 12,
                  valueNotifier: valueNotifier,
                  mergeMode: true,
               /*   onGetText: (double value) {
                    return Text(
                      '${75.toString()}'+"%",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },*/
                ),
              ),
           /*   Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/7be5d043981d6f17604ad2cb27914f60523f29717bb7ed9303f329f815594175?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
                width: 74,
                fit: BoxFit.contain,
              ),*/
              SizedBox(height: 16),
              Text(
                'Hours',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/1e0140bc-3be2-47b0-84aa-b1fdf7632ca0?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            width: 64,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 14),
          Text(
            'Steps'.tr(context),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '$_steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard() {
    return Container(
      width: 178,
      height: 199,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        image: DecorationImage(
          image: NetworkImage('https://cdn.builder.io/api/v1/image/assets/TEMP/2f7e6ebbeb77c86bda4be2b317168a9d1fca044a531fc25a9fb620c4a354812e?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(left: 13, bottom: 7),
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFFD0CCCC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Session',
            style: TextStyle(
              color: Color(0xFF050505),
              fontSize: 13,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  Home({Key? key, required this.Token}) : super(key: key);
  final String Token;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
  var loginMap;

  String Guidlines="";
  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final textDirection = AppLocalization.of(context).getAppDirection();
    final isRtl = textDirection == TextDirection.rtl;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: ZoomDrawer(
          menuBackgroundColor: Colors.black,
androidCloseOnBackTap: true,
menuScreenTapClose: true,
isRtl: isRtl,
          showShadow: true,
          overlayBlend: BlendMode.darken, // Try adding this if supported
          // Set to 0 for no blur effect, ensuring pure black
          overlayBlur: 2,
          borderRadius: 30,
         // overlayColor: Colors.black,
          controller: _zoomDrawerController,
          style: DrawerStyle.style1,
          mainScreenTapClose: true,
         // disableDragGesture: true,
          menuScreen: CustomDrawer(Token: widget.Token,),
          mainScreen: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => _zoomDrawerController.toggle?.call(),
              ),
              actions: [  Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/550f075f9f9dd2496709caae261986535bd4b44993d9152c6d46979964ee8421?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
                width: 27,
                fit: BoxFit.contain,
              ),],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.black,
                  constraints: BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      Container(
                       color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0,top: 0,right: 8,left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            //  UserProfile(),
                             /* SizedBox(height: 13),
                              WorkoutProgress(),*/
                              SizedBox(height: 13),
                              ExerciseCards(Token:widget.Token),
                              SizedBox(height: 10),
                              loginMap==null ? SizedBox()  :
                              NextMeal(meals: loginMap['data']['meals'], timeZoneOffset: '+00:00',selectedLanguage:selectedLanguage),

                              SizedBox(height: 31),
                              Container(


                                  child: ProgramsSection(Token: widget.Token)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Future<void> getData() async {
    _loadSelectedLanguage();
    /*   OverlayLoadingProgress.start(
      context,
      widget: Center(
        child: Container(
          color: Colors.transparent,
          width: screenWidth, // MediaQuery accessed here
          child: const AspectRatio(
            aspectRatio: 1 / 3,
            child: LoadingLogo(),
          ),
        ),
      ),
    );*/



    var url = Uri.parse("${Config.baseURL}/diet/plan?date=${DateTime.now().toString()}");
    var request = http.MultipartRequest('GET', url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString('cookies')!;

    // Add headers
    request.headers.addAll({
      'Authorization': "Bearer ${widget.Token}",
      'Accept': 'application/json',
    'Cookie': cookies,
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          loginMap = json.decode(responseData);
          //   print(loginMap);
          isLoading = false;
          print("num is $num");

          isLoading = false;
        });
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: $responseData");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      // OverlayLoadingProgress.stop();
    }
  }
}

class DrawerItem {
  final String iconPath;
  final String title;
  final Widget navigation;

  DrawerItem({required this.iconPath, required this.title, required this.navigation});
}

class CustomDrawer extends StatefulWidget {
  final String Token;

  CustomDrawer({Key? key, required this.Token}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late List<DrawerItem> drawerItems;

  @override
  void initState() {
    super.initState();

   /* drawerItems = [
      DrawerItem(iconPath: 'assets/svg/ganeral/sheet.svg', title: 'inbody'.tr(context), navigation: InBody(Token: widget.Token)),
     // DrawerItem(iconPath: 'assets/svg/ganeral/file-upload.svg', title: 'Upload Inbody', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/measurements.svg', title: 'measurements'.tr(context), navigation: measurementsPage(Token: widget.Token)),
      //DrawerItem(iconPath: 'assets/svg/ganeral/update-measurements.svg', title: 'Update Measurements', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/bandaid.svg', title: 'injuries'.tr(context), navigation: Injures(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/medicine.svg', title: 'medical_cases'.tr(context), navigation: MedicalCase(Token: widget.Token)),
     // DrawerItem(iconPath: 'assets/svg/ganeral/measurements.svg', title: 'Help', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/test.svg', title: 'fitness_test'.tr(context), navigation: FitnessTestPage(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/activity.svg', title: 'activity'.tr(context), navigation: DataPage(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/folder.svg', title: 'files'.tr(context), navigation: ImageGalleryPage(Token: widget.Token)),
     // DrawerItem(iconPath: 'assets/svg/ganeral/setting.svg', title: 'Settings', navigation: InBody(Token: widget.Token)),
    ];*/
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Move the initialization logic that depends on context here
    drawerItems = [
      DrawerItem(
        iconPath: 'assets/svg/ganeral/sheet.svg',
        title: 'inbody'.tr(context),
        navigation: InBody(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/measurements.svg',
        title: 'measurements'.tr(context),
        navigation: measurementsPage(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/bandaid.svg',
        title: 'injuries'.tr(context),
        navigation: Injures(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/medicine.svg',
        title: 'medical_cases'.tr(context),
        navigation: MedicalCase(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/test.svg',
        title: 'fitness_test'.tr(context),
        navigation: FitnessTestPage(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/activity.svg',
        title: 'activity'.tr(context),
        navigation: CalendarScreen(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/folder.svg',
        title: 'files'.tr(context),
        navigation: ImageGalleryPage(Token: widget.Token),
      ),
      DrawerItem(
        iconPath: 'assets/svg/ganeral/book.svg',
        title: 'E-Cooking Book'.tr(context),
        navigation: FoodPage(Token: widget.Token),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                final item = drawerItems[index];
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item.navigation,
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1F1F1F),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0XFFFF0336).withOpacity(0.1), // Neon red glow
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              item.iconPath,
                              width: 30,
                              height: 30,
                              color:Color(0xFFff0336),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              item.title,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 70 ),
        ],
      ),
    );
  }
}



class NeonCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0XFFFF0336).withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Color(0XFFFF0336).withOpacity(0.1), // Neon red glow
              blurRadius: 20, // Spread of the glow
              spreadRadius: 5,
            ),
          ],

        ),

      ),
    );
  }
}

// workout_type.dart
class WorkoutType {
  final int id;
  final String typeName;
  final String image;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutType({
    required this.id,
    required this.typeName,
    required this.image,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutType.fromJson(Map<String, dynamic> json) {
    return WorkoutType(
      id: json['id'],
      typeName: json['type_name'],
      image: json['image'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


class ProgramDetailsScreen extends StatelessWidget {
  final WorkoutType workoutType;

  const ProgramDetailsScreen({Key? key, required this.workoutType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutType.typeName),
        backgroundColor: Color(0XFFFF0336), // Match the active card color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              workoutType.image,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),
            Text(
              workoutType.typeName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Slug: ${workoutType.slug}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}



class ProgramsSection extends StatefulWidget {
  final String Token;
   ProgramsSection({Key? key, required this.Token}) : super(key: key);

  @override
  _ProgramsSectionState createState() => _ProgramsSectionState();
}

class _ProgramsSectionState extends State<ProgramsSection> {



  List<WorkoutType> workoutTypes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWorkoutTypes();
  }

  Future<void> fetchWorkoutTypes() async {
    final url = Uri.parse('${Config.baseURL}/workout/types');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString('cookies')!;

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
    'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          workoutTypes = data
              .map((item) => WorkoutType.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
          'Failed to load workout types. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Programs'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 7),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
          child: Text(
            errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        )
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Static first card
              _buildProgramCard(
                title: 'Diet'.tr(context),
                imageUrl:
                'https://cdn.builder.io/api/v1/image/assets/TEMP/c335a7175fbda5e99fdf9186d37c136faf77b49e0ead1377b6a8182df7de1734?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
                backgroundColor: Color(0XFFFF0336),
                isActive: true,
                onTap: () {
                  // Define action for the static card
            /*      Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DietPlanScreen(Token: widget.Token),
                    ),
                  );*/


                  Provider.of<NavigationProvider>(context, listen: false).setIndex(2); // For example, to navigate to the third tab

                },
              ),
              // Dynamically fetched cards
              ...workoutTypes.map((workout) => _buildProgramCard(
                title: workout.typeName,
                imageUrl: workout.image,
                backgroundColor: Color(0xFF252525),
                isActive: false,
                onTap: () {
                  Navigator.of(context).push(FadePageRoute(
                    page: WorkoutsScreen(Token:widget.Token, slug:workout.slug),
                  ));

                },
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String imageUrl,
    required Color backgroundColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        margin: const EdgeInsets.only(right: 8.0), // Spacing between cards
        width: 150,
        height: 150,// Fixed width for each card
       // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title == "Diet".tr(context) ?
        ClipOval(
          child: SvgPicture.asset(
            'assets/icons/foodnewlast.svg',
            width: 70,
            height: 70,
            //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
          ),
        ):
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red, size: 28);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
