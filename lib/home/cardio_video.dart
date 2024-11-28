import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullScreenVideoSheet extends StatefulWidget {
  final Map<String, dynamic> loginMap2; // Pass the data to the widget

  const FullScreenVideoSheet({Key? key, required this.loginMap2}) : super(key: key);

  @override
  _FullScreenVideoSheetState createState() => _FullScreenVideoSheetState();
}

/*class _FullScreenVideoSheetState extends State<FullScreenVideoSheet> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller
    _videoController = VideoPlayerController.network(widget.loginMap2['data']['video'])
      ..initialize().then((_) {
        setState(() {}); // Refresh to display the video once initialized
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose of the video controller
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _videoController.pause();
            _isPlaying = false;
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Video display
            if (_videoController.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_videoController.value.isPlaying) {
                              _videoController.pause();
                              _isPlaying = false;
                            } else {
                              _videoController.play();
                              _isPlaying = true;
                            }
                          });
                        },
                        child: VideoPlayer(_videoController),
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
                                _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_videoController.value.isPlaying) {
                                    _videoController.pause();
                                    _isPlaying = false;
                                  } else {
                                    _videoController.play();
                                    _isPlaying = true;
                                  }
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                _formatDuration(_videoController.value.position),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: Color(0XFFFF0336),
                                activeColor: Color(0XFFFF0336),
                                inactiveColor: Colors.white,
                                value: _videoController.value.position.inSeconds.toDouble(),
                                min: 0,
                                max: _videoController.value.duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    _videoController.seekTo(Duration(seconds: value.toInt()));
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                _formatDuration(_videoController.value.duration),
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
              Center(
                child: SpinKitHourGlass(color: Color(0XFFFF0336)),
              ),

            SizedBox(height: 20),
            Text(
              "Duration: ${widget.loginMap2['data']['duration']} mins",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Type: ${widget.loginMap2['data']['type']}",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            if (widget.loginMap2['data']['speed'] != null)
              Text(
                "Speed: ${widget.loginMap2['data']['speed']} km/h",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            if (widget.loginMap2['data']['incline'] != null)
              Text(
                "Incline: ${widget.loginMap2['data']['incline']}",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/


class _FullScreenVideoSheetState extends State<FullScreenVideoSheet> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.loginMap2['data']['video'])
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
            SizedBox(height: 20),
            Text(
              "Duration: ${widget.loginMap2['data']['duration']} mins",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Type: ${widget.loginMap2['data']['type']}",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            if (widget.loginMap2['data']['speed'] != null)
              Text(
                "Speed: ${widget.loginMap2['data']['speed']} km/h",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            if (widget.loginMap2['data']['incline'] != null)
              Text(
                "Incline: ${widget.loginMap2['data']['incline']}",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),

            // Slider for seeking in the video





          ],
        ),
      ),
    );
  }
}