
import 'package:gymjoe/localization/app_localization.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_player/video_player.dart';

import '../configre/globale_variables.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../theme/loading.dart';


class WorkoutsScreen extends StatefulWidget {
  final String Token, slug;

  WorkoutsScreen({Key? key, required this.Token,required this.slug}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {


  List<dynamic> exercises = [];
  List<dynamic> sections = [];
int day_num= 0; int plan_id = 0;
  bool isLoading = true;
  Map<String, dynamic>? allData;
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();
  final double itemWidth = 56.0;
  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _fetchExercises(10,selectedDate);

    valueNotifier = ValueNotifier(75.0);
  }

  String selectedLanguage = '';

  Future<void> _loadSelectedLanguage() async {
    final savedLanguage = await AppLocalization.getLanguage();
    print(savedLanguage);
    if (mounted) {
      setState(() {
        selectedLanguage = savedLanguage ?? 'en';
      });
    }
  }



  void _onDateSelected(DateTime date, int index) {
    setState(() {
      selectedDate = date;
    });
    _fetchExercises(index,selectedDate);
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
  Future<void> _fetchExercises(int num, DateTime date) async {

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    var url = Uri.parse("${Config.baseURL}/workout/plan?type=${widget.slug}&date=$formattedDate");
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
        final responseData = jsonDecode(response.body);
        List<dynamic> sectionsData = responseData['data']['sections'];

        List<dynamic> flattenedExercises = [];

        for (var section in sectionsData) {
          for (var exercise in section['exercises']) {
            // Enrich each exercise with its parent section's sets and reps
            exercise['sets'] = section['sets'];
            exercise['reps'] = section['reps'];
            exercise['tempo'] = section['tempo'];

            flattenedExercises.add(exercise);
          }
        }

        setState(() {
          allData = responseData['data'];
          sections = sectionsData;
          exercises = flattenedExercises;
          day_num= responseData['data']['day_num'];
          plan_id = responseData['data']['plan_id'];

          print("day_num $day_num :plan_id  $plan_id ");
          isLoading = false;
          print("num is $num");
          if (num > 17) {
            print("num is $num will not move");
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday(num));
          }
        });
        OverlayLoadingProgress.stop();
      } else {
        print('Failed to load exercises');
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
        title: Text('Workout Plans'.tr(context),style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              // Handle profile
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color:  Colors.black,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [




                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 11),

                          const SizedBox(height: 31),
                          DateSelector(context,today,dates,selectedLanguage),
                          const SizedBox(height: 21),
                          Workout(),
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: const Color(0XFFFF0336),
                          ),
                          const SizedBox(height: 14),
                          isLoading
                              ? const Center(child: LoadingLogo())

                              : exercises.isEmpty?SizedBox(): ExerciseList(exercises: exercises, sections:sections,day_num:day_num,plan_id:plan_id, Token: widget.Token),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: exercises.isEmpty?SizedBox(): Container(
        padding: EdgeInsets.all(2),
        height: 50,
        width: 170,
        child: FloatingActionButton(onPressed:()=> showExerciseModal(context, exercises, 0,widget.Token,plan_id,
            day_num),
          backgroundColor: Color(0xFFff0336),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
            Icon(Icons.play_arrow_outlined),

            Text("Start Workout".tr(context))
          ],),
        ),),
      ),
    );
  }
  Widget DateSelector(BuildContext context, DateTime today, List<DateTime> dates, String locale) {
    print(locale);
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
            }
                : null,
            child:   _DateItem(
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

  Widget Workout() {
    print("${exercises.length}"+" "+ "Exercises".tr(context));
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
                allData?['name'] ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 9),
              Text(
                '${exercises.length} Exercises',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        /*  Container(
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
                backStrokeWidth: 5,
                progressStrokeWidth: 5,
                valueNotifier: valueNotifier,
                mergeMode: true,
                onGetText: (double value) {
                  return Text(
                    '${75.toString()}' + "%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),*/
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



class ExerciseList extends StatelessWidget {
  final List<dynamic> exercises;
  final String Token;
  final List<dynamic> sections;
  final int plan_id,day_num;

  const ExerciseList({Key? key, required this.exercises,required this.plan_id,required this.day_num,required this.Token, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: exercises.asMap().entries.map((entry) {
          int index = entry.key;
          var exercise = entry.value;
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  showExerciseModal(context, exercises, index,Token,plan_id,day_num);
                },
                child: ExerciseItem(
                  imageUrl: exercise['image'] ?? '',
                  icon: exercise['completed'] ?? false
                      ? "assets/icons/checkedredd.svg"
                      : "assets/icons/notchecked.svg",
                  name: exercise['exercise_name'] ?? 'Unknown Exercise',
                  // Use the enriched 'sets' and 'reps' directly from the exercise
                  sets: '${exercise['sets']}'+ ' '+ 'Sets'.tr(context)+ ' x ' + '${exercise['reps']}'+ ' '+'Reps'.tr(context)+ ','+' ' +'${exercise['tempo']}'+ ' '+ 'tempo'.tr(context),
                ),
              ),
              const SizedBox(height: 13),
            ],
          );
        }).toList(),
      ),
    );
  }
}


void showExerciseModal(BuildContext context, List exercises, int index,String Token,int plan_id,int day_num) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.black,
    builder: (BuildContext context) {
      return ExerciseModalContent(
        Token: Token,
        exercises: exercises,
        initialIndex: index,
          plan_id:plan_id,
          day_num:day_num
      );
    },
  );
}

class ExerciseItem extends StatelessWidget {
  final String imageUrl;
  final String icon;
  final String name;
  final String sets;

  const ExerciseItem({
    Key? key,
    required this.imageUrl,
    required this.icon,
    required this.name,
    required this.sets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.network(
              imageUrl,
              width: 83,
              height: 73,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 73,
            color: const Color(0XFFFF0336),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  sets??"",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        /*  SvgPicture.asset(
            icon,
            width: 27,
            height: 27,
          ),*/
        ],
      ),
    );
  }
}

class ExerciseModalContent extends StatefulWidget {
  final List<dynamic> exercises;
  final int initialIndex;
  final String Token;
  final int   plan_id,
  day_num;

  const ExerciseModalContent({
    Key? key,
    required this.exercises,
    required this.initialIndex,
    required this.plan_id,
    required this.day_num,
    required this.Token,
  }) : super(key: key);

  @override
  _ExerciseModalContentState createState() => _ExerciseModalContentState();
}

class _ExerciseModalContentState extends State<ExerciseModalContent> {
  late VideoPlayerController _controller;
  late int currentIndex;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Offset _dragPosition = Offset(-3, 408); // Initial position of the draggable widget

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    print(widget.exercises);
    _loadVideo(widget.exercises[currentIndex]['video']);
  }

  void _loadVideo(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
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

  void _showNextVideo() {
    if (currentIndex < widget.exercises.length - 1) {
      setState(() {
        currentIndex++;
        _controller.dispose();
        _loadVideo(widget.exercises[currentIndex]['video']);
      });
    }
  }

  void _showPreviousVideo() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _controller.dispose();
        _loadVideo(widget.exercises[currentIndex]['video']);
      });
    }
  }

  String _formatDuration(Duration duration) {
    return DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds));
  }
 String SelectedFeedbackalue ="";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.97,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              StepProgressIndicator(
                totalSteps: widget.exercises.length ,
                currentStep: currentIndex +1,
                size: 10,
                selectedColor: Color(0XFFFF0336),
                unselectedColor: Colors.white,
                roundedEdges: Radius.circular(10),
                /*gradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange, Colors.white],
                ),*/
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.exercises[currentIndex]['exercise_name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text("Tool: ${widget.exercises[currentIndex]['tools'][0]["tool_name"]}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),

                  Text("${widget.exercises[currentIndex]['sets']} Sets x ${widget.exercises[currentIndex]['reps']} Reps , ${widget.exercises[currentIndex]['tempo']} Tempo"),
                ],
              ),
              SizedBox(height: 15,),


              //  Text(widget.exercises[currentIndex]['tools']['tool_name']),
              Expanded(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: InkWell(
                          onTap: () {
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
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
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
                    : const Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        currentIndex > 0 ? MaterialStateProperty.all(Color(0XFFFF0336)) : null),
                    onPressed: currentIndex > 0 ? _showPreviousVideo : null,
                    child: Text("Previous Video".tr(context),

                      style: TextStyle(color: currentIndex > 0 ? Colors.white: Colors.white.withOpacity(0.7),
                          fontSize: 11

                      ),),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0XFFFF0336))),
                    onPressed: () {
                      Navigator.pop(context);
                      showSatisfactionSurvey(context);

                    },
                    child: Text("Finish".tr(context),

    style: TextStyle(color: Colors.white,
    fontSize: 11

    ),),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor:currentIndex < widget.exercises.length - 1 ? MaterialStateProperty.all(Color(0XFFFF0336)) : null),
                    onPressed: currentIndex < widget.exercises.length - 1 ? _showNextVideo : null,
                    child: Text("Next Video".tr(context),

    style: TextStyle(color: Colors.white,
    fontSize: 11

    ),),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: _dragPosition.dx,
            top: _dragPosition.dy,
            child: GestureDetector(
              onTap: (){
                print(widget.exercises[currentIndex]['vectors']['male']['front']);
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomPhotoDialog(

                      svgUrl1:widget.exercises[currentIndex]['vectors']['male']['front'],
                      svgUrl2: widget.exercises[currentIndex]['vectors']['male']['back'],
                    );
                  },
                );
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragPosition += details.delta;

                  print(" x = ${_dragPosition.dx}" +  " y = ${_dragPosition.dy}");
                });
              },
              child: Container(
                height: 40,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0XFFFF0336),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset("assets/svg/ganeral/muscleimage.svg",
                    height: 20,
                    width: 20,
                    color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSatisfactionSurvey(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full-height if needed
      backgroundColor: Colors.black, // Black background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // Handle keyboard overlap
          child: SatisfactionSurvey(
            onSubmit: (selectedValue) {
              // Handle the submitted value here
              print("User selected: $selectedValue");
              // You can add further processing, such as sending to a server


              SelectedFeedbackalue = "$selectedValue";



              submitSchedule();

            },
          ),
        );
      },
    );
  }
  Future<void> submitSchedule() async {

    // Format the current date as "YYYY-MM-DD HH:MM:SS"
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final url = Uri.parse('${Config.baseURL}/workout/set-finish');
    print(formattedDate);

    final payload = {
      "feedback": SelectedFeedbackalue, // ["tooeasy", "a_little_easy", "just_right", "a_little_hard", "too_hard"]
      "plan_id": widget. plan_id,
     // current plan id
      "day_num":  widget.day_num, // integer value of the workout day_num
      "date": formattedDate // Workout Date of the day in format "Y-m-d H:i:s"
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString('cookies')!;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
          "Accept":"application/json",
    'Cookie': cookies,
        },
        body: jsonEncode(payload),
      );

      final responseBody = response.body;

      try {
        final jsonResponse = jsonDecode(responseBody);
        print('Response (JSON): $jsonResponse');
      } catch (e) {
        print('Response (Non-JSON): $responseBody');
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Thank you for your feedback!"),
            backgroundColor:Color(0xFFff0336),
          ),
        );
      } else {
        print('Failed to update schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating schedule: $e');
    }
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


class CustomPhotoDialog extends StatelessWidget {
  final String svgUrl1;
  final String svgUrl2;

  const CustomPhotoDialog({
    Key? key,
    required this.svgUrl1,
    required this.svgUrl2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:SvgPicture.network(
                  svgUrl1,
                  height: 300, // Adjust the size as needed
                  width: 300,
                  fit: BoxFit.contain,
                ),


              ),

            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.network(
                  svgUrl2,
                  fit: BoxFit.contain,

                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}



// SurveyOption Model
class SurveyOption {
  final String displayLabel;
  final String value;
  final String emoji;

  SurveyOption({
    required this.displayLabel,
    required this.value,
    required this.emoji,
  });
}

// SatisfactionSurvey Widget
class SatisfactionSurvey extends StatefulWidget {
  final Function(String) onSubmit;

  const SatisfactionSurvey({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _SatisfactionSurveyState createState() => _SatisfactionSurveyState();
}

class _SatisfactionSurveyState extends State<SatisfactionSurvey> {
  // Define the survey options
  final List<SurveyOption> options = [
    SurveyOption(displayLabel: "Too Easy", value: "tooeasy", emoji: "🟢"),
    SurveyOption(displayLabel: "A Little Easy", value: "a_little_easy", emoji: "😊"),
    SurveyOption(displayLabel: "Just Right", value: "just_right", emoji: "😐"),
    SurveyOption(displayLabel: "A Little Hard", value: "a_little_hard", emoji: "😕"),
    SurveyOption(displayLabel: "Too Hard", value: "too_hard", emoji: "🔴"),
  ];

  // Track the selected index
  int? selectedIndex;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Black background for the bottom sheet
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Survey Title
          Center(
            child: Text(
              "How was your experience?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Display the options
          Column(
            children: List.generate(options.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Color(0xFFff0336)
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: selectedIndex == index
                        ? Border.all(color: Color(0xFFff0336), width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        options[index].emoji,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          options[index].displayLabel,
                          style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.grey[300],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 20),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: selectedIndex != null
                  ? () {
                // Pass the selected value back to the parent widget
                String selectedValue = options[selectedIndex!].value;
                widget.onSubmit(selectedValue);
                Navigator.pop(context); // Close the bottom sheet
              }
                  : null, // Disable button if no selection
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFFff0336), // Text color
                padding:
                EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

