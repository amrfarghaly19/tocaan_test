import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'dart:convert';

import '../configre/globale_variables.dart';
import '../theme/loading.dart';
import '../theme/widgets/bottombar_provider.dart';
import 'e_book.dart';

class DietPlanScreen extends StatefulWidget {
  final String Token;

  DietPlanScreen({Key? key, required this.Token}) : super(key: key);

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  DateTime now = DateTime.now();
  var loginMap;
  String Guidlines="";
  bool isLoading = true; // Add loading flag
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();
  final double itemWidth = 56.0; // Width of each item (40 + padding/margin)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   // WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday());
  }

  // Center today's date when the widget first builds
  void _centerToday(int num) {
    // The position to center today's date (index = 10 in a list of 21 dates)
    int todayIndex = num;
    if(num >17){

    }else{
      double targetOffset = (itemWidth * todayIndex) -
          (_scrollController.position.viewportDimension / 2.3) +
          (itemWidth / 2.3);

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    }

  }

  // Center the selected date when the user taps on a date
  void _onDateSelected(DateTime date, int index) {
    setState(() {
      selectedDate = date;
    });
    getData(selectedDate,index);
    // Calculate the offset to center the selected date
    double offsetToCenter = (itemWidth * index) -
        (_scrollController.position.viewportDimension / 2) +
        (itemWidth / 2);
    _scrollController.animateTo(
      offsetToCenter,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Perform your custom action here when a new date is selected
    print("Selected Date: ${DateFormat('dd-MM-yyyy').format(date)}");
  }



  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      getData(DateTime.now(),10);
      getGuidlines();// Call getData after the widget is fully initialized
    });
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


    DateTime today = DateTime.now();
    List<DateTime> dates = _generateDates(today);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){

          Provider.of<NavigationProvider>(context, listen: false).setIndex(0); // For example, to navigate to the third tab

          // Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),

        title: Text(
          'Diet Plan'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ) ,
        actions: [
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/47e1bc7c8b175035692239daf1b141401cb40be0986250939a12436a57fc070f?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            width: 26,
            height: 31,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 33),
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/2c5eeb1da48947c681b1ba5b42e32bacb98fe61fbf76827fdf0bb096ce1bbb2e?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),

        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:  isLoading
              ? Center( child: LoadingLogo()) :Column(
            children: [
              // Your UI code here
              Container(
                color: const Color(0xE3070101),
                child: Column(
                  children: [

                    const SizedBox(height: 31),

                     DateSelector(context,today,dates,selectedLanguage),
                    const SizedBox(height: 34),

                    // Show loading indicator while data is loading
                    isLoading
                        ? LoadingLogo() // Show a loading spinner
                        : CalorieSummary(data: loginMap),
                    // Show the widget when data is loaded

                    const SizedBox(height: 24),
                    isLoading
                        ? LoadingLogo() // Show a loading spinner
                        : MealPreview(meals: loginMap['data']['meals']),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              isLoading
                  ? LoadingLogo()
                  : NextMeal(meals: loginMap['data']['meals'], timeZoneOffset: '+00:00', selectedLanguage:selectedLanguage),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    InkWell(
                      onTap: (){
                        showCustomDialog(context);

                      },
                      child: Container(
                        width:MediaQuery.of(context).size.width/2.3 ,
                        height: 40,
                        // height: height,
                        decoration: BoxDecoration(
                          color: Color(0XFFFF0336), // Red background color
                          borderRadius: BorderRadius.circular(8), // Rounded edges with radius 20
                          /*  boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],*/
                        ),
                        child: Center(
                          child: Text(
                            "Guidelines".tr(context),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodPage(Token: widget.Token),
                          ),
                        );


                      },
                      child: Container(
                        width:MediaQuery.of(context).size.width/2.3 ,
                        height: 40,
                        // height: height,
                        decoration: BoxDecoration(

                            color: Colors.transparent, // Transparent background
                            border: Border.all(
                              color: Color(0XFFFF0336), // Red border color
                              width: 1, // Border width
                            ),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "E-Cooking Book".tr(context),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(child: Text(loginMap['data']['notes'],
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,)),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }



  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
      false, // User must tap button for closing the dialog
      builder: (BuildContext context) {
        // Calculate 75% of screen height
        double dialogHeight = MediaQuery.of(context).size.height * 0.80;
        double dialogWidth = MediaQuery.of(context).size.width ;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded edges
          ),
          elevation: 0,
          backgroundColor: Colors
              .transparent, // Allows for custom shape and transparency
          child: dialogContent(context, dialogHeight, dialogWidth),
        );
      },
    );
  }

  // Widget representing the content of the dialog
  Widget dialogContent(BuildContext context, double height, double width) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black, // Dialog background color
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Guidlines'.tr(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0XFFFF0336)
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                // Sample long text to demonstrate scrollability
               Guidlines??"",
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child:
            InkWell(
              onTap: (){
                Navigator.of(context).pop();

              },
              child: Container(
                width:MediaQuery.of(context).size.width/2.1 ,
                height: 40,
                // height: height,
                decoration: BoxDecoration(
                  color: Color(0XFFFF0336), // Red background color
                  borderRadius: BorderRadius.circular(8), // Rounded edges with radius 20
                  /*  boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],*/
                ),
                child: Center(
                  child: Text(
                    "Close".tr(context),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),

     /*
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
              ),
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),*/
          ),
        ],
      ),
    );
  }


  Future<void> getData(DateTime date, int num) async {
    final screenWidth = MediaQuery.of(context).size.width;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

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

    print("New Date is  $date    formated is $formattedDate");

    var url = Uri.parse("${Config.baseURL}/diet/plan?date=$formattedDate");
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
          if(num >17){
            print("num is $num will not move");
          }else {

            WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday(num));// Set loading to false once data is fetched
          }
          isLoading = false;
        });
        OverlayLoadingProgress.stop();
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: $responseData");
        setState(() {
          isLoading = false;
        });
        OverlayLoadingProgress.stop();
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      OverlayLoadingProgress.stop();
    } finally {
     // OverlayLoadingProgress.stop();
    }
  }

  Future<void> getGuidlines() async {


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



    var url = Uri.parse("${Config.baseURL}/diet/guidelines");
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
      Map<String, dynamic> jsonData = json.decode(responseData);



      if (response.statusCode == 200) {
        setState(() {
          Guidlines = jsonData['guidelines'] ?? '';
          print("Guidlines  $Guidlines");



        });
      } else {
        print("Error: Status Code ${response.statusCode}");
        print("Response: $responseData");
        setState(() {
         // isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
      //  isLoading = false;
      });
    } finally {
      // OverlayLoadingProgress.stop();
    }
  }

/*  Widget DateSelector(DateTime today,
  List<DateTime> dates ){
   return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          DateTime date = dates[index];
          bool isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          bool isDisabled = date.isBefore(today.subtract(Duration(days: 10)));

          return GestureDetector(
            onTap: !isDisabled ? ()  {
              _onDateSelected(date, index);
              getData(date,index);
            } : null,
            // Disable selection for past dates
            child: _DateItem(
              day: DateFormat('d').format(date),
              month: DateFormat('MMM').format(date),
              isSelected: isSelected,
              isDisabled: isDisabled,
            ),
          );
        },
      ),
    );
  }*/


  Widget DateSelector(BuildContext context, DateTime today, List<DateTime> dates, String locale) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          DateTime date = dates[index];
          bool isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          bool isDisabled = date.isBefore(today.subtract(Duration(days: 10)));

          // Format day and month based on the locale
          String day = DateFormat('d', locale).format(date);
          String month = DateFormat('MMM', locale).format(date);

          return GestureDetector(
            onTap: !isDisabled
                ? () {
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
              _onDateSelected(date, index);
              getData(date, index);
            }
                : null, // Disable selection for past dates
            child: _DateItem(
              day: day,
              month: month,
              isSelected: isSelected,
              isDisabled: isDisabled,
            ),
          );
        },
      ),
    );
  }


  List<DateTime> _generateDates(DateTime today) {
    List<DateTime> dates = [];
    for (int i = -10; i <= 10; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }
}


class _DateItem extends StatelessWidget {
  final String day;
  final String month;
  final bool isSelected;
  final bool isDisabled;

  const _DateItem({
    Key? key,
    required this.day,
    required this.month,
    this.isSelected = false,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF252525);
    Color textColor = const Color(0xFFD9D9D9);

    if (isSelected) {
      backgroundColor = const Color(0XFFFF0336);
      textColor = Colors.white;
    } else if (isDisabled) {
      backgroundColor = const Color(0xFF050505);
      textColor = const Color(0x6BF9FAFE);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              month,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalorieSummary extends StatefulWidget {
  final Map<String, dynamic> data;

  CalorieSummary({Key? key, required this.data}) : super(key: key);

  @override
  State<CalorieSummary> createState() => _CalorieSummaryState();
}

class _CalorieSummaryState extends State<CalorieSummary> {
  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    // Safely handle int/double values for percentage of calories
   // print(widget.data);
    var caloriePercentage =
        widget.data['data']['macros']['consumed']['calories'];
   // print(caloriePercentage);
    valueNotifier = ValueNotifier(_parseToDouble(caloriePercentage));
  }

  // Helper method to handle dynamic data and return as double
  double _parseToDouble(dynamic value) {
    if (value is int) {
     // print("value 1 is $value");
      return value.toDouble();
    } else if (value is double) {
    //  print("value 2 is $value");
      return value;
    } else if (value is String) {
     // print("value 3 is $value");
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(11, 25, 11, 11),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "${widget.data['data']['macros']['consumed']['calories'].toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                   Text(
                    "Consumed".tr(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 104,
                height: 104,
                child: SimpleCircularProgressBar(
                  animationDuration: 2,
                  backColor: Colors.black,
                  maxValue:
                      _parseToDouble(widget.data['data']['macros']['calories']),
                  progressColors: const [Color(0XFFFF0336)],
                  startAngle: 0,
                  backStrokeWidth: 16,
                  progressStrokeWidth: 16,
                  valueNotifier: valueNotifier,
                  mergeMode: true,
                  onGetText: (double value) {
                    return Text(
                      "${_parseToDouble(widget.data['data']['macros']['percentage']['calories'])}%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Text(
                    "${widget.data['data']['macros']['remaining']['calories'].toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                   Text(
                    "Remaining".tr(context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMacroInfo(
                  'P'.tr(context),
                  widget.data['data']['macros']['consumed']['proteins'],
                  widget.data['data']['macros']['proteins']),
              _buildMacroInfo(
                  'C'.tr(context),
                  widget.data['data']['macros']['consumed']['carbs'],
                  widget.data['data']['macros']['carbs']),
              _buildMacroInfo(
                  'F'.tr(context),
                  widget.data['data']['macros']['consumed']['fats'],
                  widget.data['data']['macros']['fats']),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, dynamic value, dynamic total) {
    double parsedValue = _parseToDouble(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$label - ${parsedValue.toStringAsFixed(2)}/${total.toStringAsFixed(2)} g',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w300,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 88,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF050505),
            borderRadius: BorderRadius.circular(7),
          ),
          child: FractionallySizedBox(
            widthFactor: parsedValue / total,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0XFFFF0336),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}

class MealPreview extends StatelessWidget {
  final List<dynamic> meals;

  MealPreview({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: meals.asMap().entries.map((entry) {
          int index = entry.key;
          var meal = entry.value;

          // Determine background color based on index
          Color backgroundColor = (index % 2 == 0)
              ? const Color(0xFF252525)
              : const Color(0XFFFF0336); // Dark for odd indices

          // Determine background image
          String imageUrl = (index % 2 == 0)
              ? "assets/card1.png" // Use meal icon for even index
              : "assets/card2.png"; // Placeholder image for odd index

          return InkWell(
            onTap: () {
              showFullScreenBottomSheet( context, meal);
             /* showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (context) => MealBottomSheet(meal: meal),
              );*/
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                width: 176,
                height: 140,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,  // Allow the image to overflow slightly
                  children: [
                    Positioned(
                      top: 14,
                      left: 19,
                      child: Text(
                        meal['type'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    // Positioned image with the curved bottom right corner
                    Positioned(
                      bottom: -10,  // Overflow the image slightly outside the container
                      left: 0,      // Align the image to the left
                      right: -45,   // Overflow to the right slightly
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(17), // Apply curve to bottom right corner
                        ),
                        child: Image.asset(
                          imageUrl,
                          width: 128,
                          height: 102,
                          fit: BoxFit.contain,  // Adjust the image to fit inside the container
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 8,  // Adjust this based on where you want the icon
                      right: 40,
                      child: SvgPicture.network(
                        meal['icon'],
                        width: 90,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}



class MealBottomSheet extends StatelessWidget {
  final Map<String, dynamic> meal;

  MealBottomSheet({required this.meal});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(meal['foods']);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);  // Close the bottom sheet
              },
            ),
          ),

          // Title
          Text(
            'Meal:'.tr(context) +'${meal['type']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // List of foods
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                var food = foods[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Check if there's a video
                      if (food['video'] != null)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                food['thumbnail'], // Show the thumbnail
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_circle_outline,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // On tap, play the video
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(videoUrl: food['video']),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SvgPicture.network(
                            food['icon'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(width: 10),
                      // Wrap the text in Flexible to avoid overflow
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['food_name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,  // Show ellipsis if the text exceeds the limit
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                food['food_type'].toString() == "quantity"? food['quantity'].toString()
                                   :  food['serve_quantity'].toString() ,



                                //  food['serve_quantity'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  food['food_type'].toString() == "quantity"
                                      ? "g":  food['serve_unit'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;

        // Listen for updates to the video's position
        _controller.addListener(() {
          setState(() {
            _currentPosition = _controller.value.position;
          });
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to format duration as mm:ss
  String _formatDuration(Duration duration) {
    return DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        leading: IconButton(onPressed: (){

        // For example, to navigate to the third tab

          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),

        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView( // Wrap everything in SingleChildScrollView to avoid overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Video display
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                                _isPlaying = false;
                              } else {
                                _controller.play();
                                _isPlaying = true;
                              }
                            });
                          },
                          child: VideoPlayer(_controller)),
                    ),
                    Positioned(
                      bottom: 0, // Position the controls at the bottom edge
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5), // Optional background
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                    _isPlaying = false;
                                  } else {
                                    _controller.play();
                                    _isPlaying = true;
                                  }
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                _formatDuration(_controller.value.position),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: Color(0XFFFF0336),
                                activeColor: Color(0XFFFF0336),
                                inactiveColor: Colors.white,
                                value: _controller.value.position.inSeconds.toDouble(),
                                min: 0,
                                max: _controller.value.duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    _controller.seekTo(Duration(seconds: value.toInt()));
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                _formatDuration(_controller.value.duration),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(child: SpinKitHourGlass(color: Color(0XFFFF0336)),),

            // Video controls (play, pause)


            // Slider for seeking in the video





          ],
        ),
      ),
    );
  }
}

// To show the full-screen bottom sheet with close button:
void showFullScreenBottomSheet(BuildContext context, Map<String, dynamic> meal) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Makes the bottom sheet full screen
    backgroundColor: Colors.transparent,  // Removes default background for a seamless effect
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.95,  // Takes almost full screen, adjust heightFactor as needed
      child: MealBottomSheet(meal: meal),
    ),
  );
}

class NextMeal extends StatelessWidget {
  final List<dynamic> meals;
  final String timeZoneOffset;
  final String selectedLanguage;

  const NextMeal({
    Key? key,
    required this.meals,
    required this.timeZoneOffset,
    required this.selectedLanguage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now().toUtc().add(parseTimeZoneOffset(timeZoneOffset));

    // Ensure the meals list is cast to List<Map<String, dynamic>>
    List<Map<String, dynamic>> castedMeals = List<Map<String, dynamic>>.from(meals);

    Map<String, dynamic>? nextMeal = getNextMeal(now, castedMeals);

    if (nextMeal == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child:  Text(
          'No upcoming meal'.tr(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    String mealTime = nextMeal['time'];
    String mealType = nextMeal['type'];
    List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(nextMeal['foods']);
    DateTime parsedMealTime = _parseMealTime(mealTime);
 //   String formattedMealTime = DateFormat('hh:mm a').format(parsedMealTime);
    String formattedMealTime = DateFormat(
      'hh:mm a',
      selectedLanguage == 'ar' ? 'ar' : 'en',
    ).format(parsedMealTime);

    return InkWell(
      onTap: (){
        showFullScreenBottomSheet( context, nextMeal);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Meal'.tr(context)+" "+ '[$formattedMealTime]',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0XFFFF0336),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: foods.map<Widget>((food) {
                      // Ensure this returns a widget
                          return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child:food['video'] == null ?
                            SvgPicture.network(
                              food['icon'],
                              width: 79,
                              height: 61,
                              fit: BoxFit.cover,)
                                : Image.network(
                              food['thumbnail'],
                              width: 79,
                              height: 61,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10,)
                        ],
                      );


                       // MealImageWidget(imageUrl: displayUrl);
                    }).toList(), // Make sure it returns a List<Widget>
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Duration parseTimeZoneOffset(String offset) {
    final match = RegExp(r'([+-])(\d+):(\d+)').firstMatch(offset);
    if (match != null) {
      int hours = int.parse(match.group(2)!);
      int minutes = int.parse(match.group(3)!);
      Duration duration = Duration(hours: hours, minutes: minutes);
      return match.group(1) == '+' ? duration : -duration;
    }
    return Duration.zero;
  }

  Map<String, dynamic>? getNextMeal(DateTime now, List<Map<String, dynamic>> meals) {
    meals.sort((a, b) => _parseMealTime(a['time']).compareTo(_parseMealTime(b['time'])));
    for (var meal in meals) {
      DateTime mealTime = _parseMealTime(meal['time']);
      if (mealTime.isAfter(now)) {
        return meal;
      }
    }
    return null;
  }

  DateTime _parseMealTime(String time) {
    DateFormat format = DateFormat('HH:mm:ss');
    DateTime parsedTime = format.parse(time);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute, parsedTime.second);
  }
}







