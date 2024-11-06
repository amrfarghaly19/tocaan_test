/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../configre/globale_variables.dart';

class AddInjuryPage extends StatefulWidget {
  final String Token;

  AddInjuryPage({Key? key, required this.Token}) : super(key: key);

  @override
  _AddInjuryPageState createState() => _AddInjuryPageState();
}

class _AddInjuryPageState extends State<AddInjuryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorNotesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  DateTime? _reassessmentDate;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _reassessmentDate = pickedDate;
      });
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }


  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_reassessmentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a reassessment date")));
      return;
    }

    try {
      var url = Uri.parse("${Config.baseURL}/injures");
      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = 'Bearer ${widget.Token}'
        ..fields['reassessment_date'] = _reassessmentDate.toString()
        ..fields['doctor_notes'] = _doctorNotesController.text;

      for (var image in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data submitted successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit data")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Injury"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reassessment Date", style: TextStyle(color: Colors.white, fontSize: 16)),
              TextButton(
                onPressed: _pickDate,
                child: Text(
                  _reassessmentDate != null ? _reassessmentDate.toString().split(' ')[0] : "Select Date",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextFormField(
                controller: _doctorNotesController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Doctor Notes",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter doctor notes";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Selected Images", style: TextStyle(color: Colors.white, fontSize: 16)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages.map((image) {
                  return InkWell(
                    onTap: (){
                    //  _viewImageFullScreen(index),

                    },
                    child: Stack(
                      children: [
                        Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.remove(image);
                              });
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: _pickImages,
                style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                child: Text("Add Images", style: TextStyle(color: Colors.red)),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void _viewImageFullScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: _selectedImages,
          initialIndex: index,
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<File> images;
  final int initialIndex;

  FullScreenImageViewer({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}*/


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../configre/globale_variables.dart';
import '../theme/loading.dart';

class AddInjuryPage extends StatefulWidget {
  final String Token;

  AddInjuryPage({Key? key, required this.Token}) : super(key: key);

  @override
  _AddInjuryPageState createState() => _AddInjuryPageState();
}

class _AddInjuryPageState extends State<AddInjuryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorNotesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  DateTime? _reassessmentDate;



  Future<void> _pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_reassessmentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a reassessment date")));
      return;
    }

    try {
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
      var url = Uri.parse("${Config.baseURL}/injures");
      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = 'Bearer ${widget.Token}'
        ..fields['reassessment_date'] = _reassessmentDate.toString()
        ..fields['doctor_notes'] = _doctorNotesController.text;

      for (var image in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
      }

      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print("Response status: ${response.statusCode}");
      print("Response body: $responseString");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data submitted successfully")));
        OverlayLoadingProgress.stop();
        Navigator.pop(context, 'refresh');

      } else {
        OverlayLoadingProgress.stop();
print(response);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit data")));
      }
    } catch (e) {
      print("Error: $e");
      OverlayLoadingProgress.stop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Injury"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reassessment Date", style: TextStyle(color: Colors.white, fontSize: 16)),
                  TextButton(
                    onPressed: _pickDate, // Calls the method to pick a date
                    child: Text(
                      _reassessmentDate != null
                          ? DateFormat('yyyy-MM-dd').format(_reassessmentDate!)  // Formats the selected date
                          : "Select Date",  // Shows prompt text if no date is selected
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _doctorNotesController,
                maxLines: 3,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Doctor Notes",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter doctor notes";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Selected Images", style: TextStyle(color: Colors.white, fontSize: 16)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages.map((image) {
                  int index = _selectedImages.indexOf(image);
                  return InkWell(
                    onTap: () => _viewImageFullScreen(index),
                    child: Stack(
                      children: [
                        Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: _pickImages,
                style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                child: Text("Add Images", style: TextStyle(color: Colors.red)),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _reassessmentDate = pickedDate;
      });
    }
  }


  void _viewImageFullScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: _selectedImages,
          initialIndex: index,
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<File> images;
  final int initialIndex;

  FullScreenImageViewer({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(color: Colors.black),
          ),

          Padding(
            padding: const EdgeInsets.only(top:90.0,left: 20),
            child: InkWell(
              onTap:() => Navigator.pop(context),

              child: Text("X",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),),
            ),
          )
        ],
      ),
    );
  }
}
