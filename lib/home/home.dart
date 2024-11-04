
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../inbody/inbody_screen.dart';
import '../theme/widgets/bottombar.dart';
/*

class Home extends StatefulWidget {
  Home({
    Key? key,
    required this.Token,
  }) : super(key: key);
  String Token;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
             */
/*   Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/49ed73880f5f21b55f471b022be77333cb2a366feeafc0b501f06796320855fd?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 926,
                ),*//*

                Container(
                  color: Color.fromRGBO(7, 1, 1, 0.89),
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserProfile(),
                            SizedBox(height: 13),
                            WorkoutProgress(),
                            SizedBox(height: 13),
                            ExerciseCards(),
                            SizedBox(height: 31),
                            ProgramsSection(),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
*/


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
        color: Color(0xFF252525),
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
                progressColors: const [Colors.red, Colors.red],
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
  const ExerciseCards({Key? key}) : super(key: key);

  @override
  State<ExerciseCards> createState() => _ExerciseCardsState();
}

class _ExerciseCardsState extends State<ExerciseCards> {

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(75.0);
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
              _buildSleepCard(),
            ],
          ),
        ),
        SizedBox(width: 18),
        Expanded(
          child: Column(
            children: [
              _buildStepsCard(),
              SizedBox(height: 13),
              _buildSessionCard(),
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
        color: Color(0xFFE42C29),
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
                //  color: selectedIndex == 2 ? Colors.red : Colors.white, // Highlight when selected
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
              child: SimpleCircularProgressBar(
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
              ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: 74,
                height: 74,
                child: SimpleCircularProgressBar(
                  animationDuration: 2,
                  backColor: Colors.black,
                  maxValue: 100,
                  progressColors: const [Colors.red, Colors.red],
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
            'Steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '230',
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

class ProgramsSection extends StatelessWidget {
  const ProgramsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Programs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildProgramCard('Jog', 'https://cdn.builder.io/api/v1/image/assets/TEMP/c335a7175fbda5e99fdf9186d37c136faf77b49e0ead1377b6a8182df7de1734?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9', Color(0xFFE42C29), true),
              _buildProgramCard('Yoga', 'https://cdn.builder.io/api/v1/image/assets/TEMP/1ee9d632ca10da4dcd15d69ff88027075b63450886328796e1d5ec78e0cbb826?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9', Color(0xFF252525), false),
              _buildProgramCard('Cycling', 'https://cdn.builder.io/api/v1/image/assets/TEMP/490552eb4a814daaefb49168a76d4cebc26d773d016ff99b9cc5b2332d3df436?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9', Color(0xFF252525), false),
              _buildProgramCard('Workout', 'https://cdn.builder.io/api/v1/image/assets/TEMP/3ac76af5d00a6a18ba7f952e771cb6609ceda38b3056893b5630b77c7e4fcac1?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9', Color(0xFF252525), false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgramCard(String title, String imageUrl, Color backgroundColor, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0), // Add some margin for spacing between cards
      width: 100, // Set a fixed width for each card
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Color(0xFF000000) : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ZoomDrawer(
        backgroundColor: Colors.black,

        showShadow: true,
        overlayBlend: BlendMode.darken, // Try adding this if supported
        // Set to 0 for no blur effect, ensuring pure black
        overlayBlur: 2,
        borderRadius: 30,
       // overlayColor: Colors.black,
        controller: _zoomDrawerController,
        style: DrawerStyle.Style8,
        menuScreen: CustomDrawer(Token: widget.Token,),
        mainScreen: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _zoomDrawerController.toggle?.call(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    Container(
                      color: Color.fromRGBO(7, 1, 1, 0.89),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserProfile(),
                            SizedBox(height: 13),
                            WorkoutProgress(),
                            SizedBox(height: 13),
                            ExerciseCards(),
                            SizedBox(height: 31),
                            ProgramsSection(),
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
    );
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
    drawerItems = [
      DrawerItem(iconPath: 'assets/svg/ganeral/sheet.svg', title: 'Inbody', navigation: InBody(Token: widget.Token)),
     // DrawerItem(iconPath: 'assets/svg/ganeral/file-upload.svg', title: 'Upload Inbody', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/measurements.svg', title: 'Measurements', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/update-measurements.svg', title: 'Update Measurements', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/bandaid.svg', title: 'Injuries', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/medicine.svg', title: 'Medical cases', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/measurements.svg', title: 'Help', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/test.svg', title: 'Fitness Test', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/measurements.svg', title: 'Contact', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/folder.svg', title: 'Files', navigation: InBody(Token: widget.Token)),
      DrawerItem(iconPath: 'assets/svg/ganeral/setting.svg', title: 'Settings', navigation: InBody(Token: widget.Token)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
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
                        color: Colors.red.withOpacity(0.1), // Neon red glow
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
          color: Colors.red.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1), // Neon red glow
              blurRadius: 20, // Spread of the glow
              spreadRadius: 5,
            ),
          ],

        ),

      ),
    );
  }
}
