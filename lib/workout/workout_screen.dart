/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class WorkoutsScreen extends StatefulWidget {
  final String Token;

  WorkoutsScreen({Key? key, required this.Token}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            color: const Color.fromRGBO(7, 1, 1, 0.89),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [

                        const SizedBox(height: 11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Workouts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Row(
                              children: [
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 21),
                         WorkoutProgress(),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: const Color(0xFFE42C29),
                        ),
                        const SizedBox(height: 14),
                        const ExerciseList(),
                      ],
                    ),
                  ),
                  const Spacer(),

                  const SizedBox(height: 9),
                  Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 9),
                ],
              ),
            ),
          ),
        ],
      ),
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
    valueNotifier = ValueNotifier(25.0);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: SimpleCircularProgressBar(
                  animationDuration: 2,
                  backColor: Colors.black,
                  maxValue: 100,
                  progressColors: const [Colors.red],
                  startAngle: 0,
                  backStrokeWidth: 12,
                  progressStrokeWidth: 12,
                  valueNotifier: valueNotifier,
                  mergeMode: true,
                  onGetText: (double value) {
                    return Text(
                      "25%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),


            ],
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      'Push Day',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                     "assets/icons/Playcircle.svg" ,
                      width: 48,
                      height: 48,
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(text: '1/4 '),
                      TextSpan(
                        text: 'Exercises',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ExerciseList extends StatelessWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: const [
          ExerciseItem(
            imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/93973dfdefdddb8e94402f71ad26087ae6368d07ecb58e635c131378525ed7c4?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            icon:  "assets/icons/checkedredd.svg",
            name: 'JUMP JACKS',
            sets: '3 Sets x 12 Reps',
          ),
          SizedBox(height: 13),
          ExerciseItem(
            imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/78ef4cd70ec51e8c4d776719533742830b073920f4e4a8e229848546a72d6424?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            icon:  "assets/icons/checkedredd.svg",
            name: 'JUMP JACKS',
            sets: '3 Sets x 12 Reps',
          ),
          SizedBox(height: 13),
          ExerciseItem(

            imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/78ef4cd70ec51e8c4d776719533742830b073920f4e4a8e229848546a72d6424?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            icon:  "assets/icons/notchecked.svg",
            name: 'JUMP JACKS',
            sets: '3 Sets x 12 Reps',
          ),
          SizedBox(height: 13),
          ExerciseItem(
            imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/78ef4cd70ec51e8c4d776719533742830b073920f4e4a8e229848546a72d6424?placeholderIfAbsent=true&apiKey=659bc5313176413ebc7dbeebe6381af9',
            icon:  "assets/icons/notchecked.svg",
            name: 'JUMP JACKS',
            sets: '3 Sets x 12 Reps',
          ),
        ],
      ),
    );
  }
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
            color: const Color(0xFFE42C29),
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
                  sets,
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
          SvgPicture.asset(
           icon ,
            width: 27,
            height: 27,
          ),

        ],
      ),
    );
  }
}


*/


import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_player/video_player.dart';

import '../configre/globale_variables.dart';

class WorkoutsScreen extends StatefulWidget {
  final String Token;

  WorkoutsScreen({Key? key, required this.Token}) : super(key: key);

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {


  List<dynamic> exercises = [];
  List<dynamic> sections = [];

  bool isLoading = true;
  Map<String, dynamic>? allData;
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();
  final double itemWidth = 56.0;
  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    _fetchExercises(10);

    valueNotifier = ValueNotifier(75.0);
  }


  void _onDateSelected(DateTime date, int index) {
    setState(() {
      selectedDate = date;
    });
    double offsetToCenter = (itemWidth * index) -
        (_scrollController.position.viewportDimension / 2) +
        (itemWidth / 2);
    _scrollController.animateTo(
      offsetToCenter,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

  Future<void> _fetchExercises(int num) async {
    var url = Uri.parse("${Config.baseURL}/workout/plan?type=fitness");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          allData = responseData['data'];
          sections=responseData['data']['sections'];
          exercises = responseData['data']['sections']
              .expand((section) => section['exercises'] as Iterable)
              .toList();
          isLoading = false;
        });

        if(num > 17){
          print("num is $num will not move");
        }else {

          WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday(num));// Set loading to false once data is fetched
        }
      } else {
        print('Failed to load exercises');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();
    List<DateTime> dates = _generateDates(today);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Workout Plans'),
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
            color: const Color.fromRGBO(7, 1, 1, 0.89),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [




                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 11),

                      /*    Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Workouts',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),*/
                          const SizedBox(height: 31),
                          DateSelector(today, dates),
                          const SizedBox(height: 21),
                          Workout(),
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: const Color(0xFFE42C29),
                          ),
                          const SizedBox(height: 14),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ExerciseList(exercises: exercises, sections:sections),
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
    );
  }

  Widget DateSelector(DateTime today, List<DateTime> dates) {
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
            onTap: !isDisabled
                ? () {
              _onDateSelected(date, index);
            }
                : null,
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
  }

  List<DateTime> _generateDates(DateTime today) {
    List<DateTime> dates = [];
    for (int i = -10; i <= 10; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    return dates;
  }

  Widget Workout() {
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

class ExerciseList extends StatelessWidget {
  final List<dynamic> exercises;
  final List<dynamic> sections;

  const ExerciseList({Key? key, required this.exercises, required this.sections}) : super(key: key);

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
                  showExerciseModal(context, exercises, index);
                },
                child: ExerciseItem(
                  imageUrl: exercise['image'] ?? '',
                  icon: exercise['completed'] ?? false
                      ? "assets/icons/checkedredd.svg"
                      : "assets/icons/notchecked.svg",
                  name: exercise['exercise_name'] ?? 'Unknown Exercise',
                  sets: '${sections[index]['sets']} Sets x ${sections[index]['reps']} Reps',
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

void showExerciseModal(BuildContext context, List exercises, int index) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.black,
    builder: (BuildContext context) {
      return ExerciseModalContent(
        exercises: exercises,
        initialIndex: index,
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
            color: const Color(0xFFE42C29),
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
                  sets,
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
          SvgPicture.asset(
            icon,
            width: 27,
            height: 27,
          ),
        ],
      ),
    );
  }
}

class ExerciseModalContent extends StatefulWidget {
  final List<dynamic> exercises;
  final int initialIndex;

  const ExerciseModalContent({
    Key? key,
    required this.exercises,
    required this.initialIndex,
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


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
                                  thumbColor: Colors.red,
                                  activeColor: Colors.red,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        currentIndex > 0 ? MaterialStateProperty.all(Colors.red) : null),
                    onPressed: currentIndex > 0 ? _showPreviousVideo : null,
                    child: Text("Previous Video"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Finish"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: currentIndex < widget.exercises.length - 1 ? _showNextVideo : null,
                    child: Text("Next Video"),
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
                  color: Colors.red,
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
      backgroundColor = const Color(0xFFE42C29);
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
                child:SvgPicture.string(
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
                child: SvgPicture.string(
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

// Usage example
void showPhotoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomPhotoDialog(
        svgUrl1: 'https://demo.team-hm.com/api/client/workout/lib/exercises/7/male/front',
        svgUrl2: 'https://demo.team-hm.com/api/client/workout/lib/exercises/7/male/front', // Update with your SVG URLs as needed
      );
    },
  );
}


