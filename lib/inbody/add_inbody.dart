/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';

class InbodyReportPage extends StatefulWidget {
  final String Token;

  InbodyReportPage({required this.Token});

  @override
  _InbodyReportPageState createState() => _InbodyReportPageState();
}

class _InbodyReportPageState extends State<InbodyReportPage> {
  File? frontImage;
  File? sideImage;
  File? backImage;
  File? inbodyImage;
  TextEditingController noteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'front':
            frontImage = File(pickedFile.path);
            break;
          case 'side':
            sideImage = File(pickedFile.path);
            break;
          case 'back':
            backImage = File(pickedFile.path);
            break;
          case 'inbody':
            inbodyImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    var request = http.MultipartRequest('POST', Uri.parse('YOUR_API_ENDPOINT'));
    request.headers['Authorization'] = 'Bearer ${widget.Token}';

    if (frontImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'front_image',
        frontImage!.path,
      ));
    }

    if (sideImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'side_image',
        sideImage!.path,
      ));
    }

    if (backImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'back_image',
        backImage!.path,
      ));
    }

    if (inbodyImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'inbody_image',
        inbodyImage!.path,
      ));
    }

    request.fields['note'] = noteController.text;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data submitted successfully')),
      );
    } else {
      print("Failed to upload");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data')),
      );
    }
  }

  Widget _buildImagePicker(String label, File? imageFile, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImagePickerOptions(type),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  imageFile == null ? 'Choose File' : p.basename(imageFile.path),
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.camera_alt, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery, type);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, type);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Inbody Report"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Inbody Report",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildImagePicker("Upload A Photo From The Front", frontImage, 'front'),
            const SizedBox(height: 20),
            _buildImagePicker("Upload A Photo From The Side", sideImage, 'side'),
            const SizedBox(height: 20),
            _buildImagePicker("Upload A Photo From The Back", backImage, 'back'),
            const SizedBox(height: 20),
            _buildImagePicker("Upload An Inbody Photo", inbodyImage, 'inbody'),
            const SizedBox(height: 20),
            Text("Note", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Add your note here',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFFFF0336),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
*/


/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class InbodyReportPage extends StatefulWidget {
  final String Token;

  const InbodyReportPage({Key? key, required this.Token}) : super(key: key);

  @override
  _InbodyReportPageState createState() => _InbodyReportPageState();
}

class _InbodyReportPageState extends State<InbodyReportPage> {
  File? frontImage;
  File? sideImage;
  File? backImage;
  File? inbodyImage;
  final TextEditingController noteController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source, String type) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'front':
            frontImage = File(pickedFile.path);
            break;
          case 'side':
            sideImage = File(pickedFile.path);
            break;
          case 'back':
            backImage = File(pickedFile.path);
            break;
          case 'inbody':
            inbodyImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  Future<void> submitData() async {
    final uri = Uri.parse("${Config.baseURL}/inbody/");
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${widget.Token}';

    if (frontImage != null) {
      request.files.add(await _fileToMultipart(frontImage!, 'front_image'));
    }
    if (sideImage != null) {
      request.files.add(await _fileToMultipart(sideImage!, 'side_image'));
    }
    if (backImage != null) {
      request.files.add(await _fileToMultipart(backImage!, 'back_image'));
    }
    if (inbodyImage != null) {
      request.files.add(await _fileToMultipart(inbodyImage!, 'inbody_image'));
    }
    request.fields['note'] = noteController.text;

    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Data submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Failed to submit data')),
      );
    }
  }

  Future<http.MultipartFile> _fileToMultipart(File file, String fieldName) async {
    final mimeTypeData = lookupMimeType(file.path)!.split('/');
    return http.MultipartFile.fromPath(
      fieldName,
      file.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Inbody Report'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildImagePicker('Upload A Photo From The Front', frontImage, 'front'),
            _buildImagePicker('Upload A Photo From The Side', sideImage, 'side'),
            _buildImagePicker('Upload A Photo From The Back', backImage, 'back'),
            _buildImagePicker('Upload A Inbody Photo', inbodyImage, 'inbody'),
            SizedBox(height: 20),
            Text('Note', style: TextStyle(color: Colors.white, fontSize: 16)),
            TextField(
              controller: noteController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0XFFFF0336)),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, File? image, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.gallery, type),
              icon: Icon(Icons.photo_library,color: Color(0XFFFF0336).withOpacity(0.7),),
              label: Text("Choose File"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.camera, type),
              icon: Icon(Icons.camera_alt,color: Color(0XFFFF0336)Accent.withOpacity(0.7),),
              label: Text("Take Photo"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (image != null)
          Text(
            'File chosen: ${basename(image.path)}',
            style: TextStyle(color: Colors.grey),
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p; // Renaming path to avoid conflicts
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class InbodyReportPage extends StatefulWidget {
  final String Token;

  const InbodyReportPage({Key? key, required this.Token}) : super(key: key);

  @override
  _InbodyReportPageState createState() => _InbodyReportPageState();
}

class _InbodyReportPageState extends State<InbodyReportPage> {
  File? frontImage;
  File? sideImage;
  File? backImage;
  File? inbodyImage;
  final TextEditingController noteController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  Future<void> pickAndCropImage(ImageSource source, String type) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          File finalCroppedFile = File(croppedFile.path); // Convert CroppedFile to File
          switch (type) {
            case 'front':
              frontImage = finalCroppedFile;
              break;
            case 'side':
              sideImage = finalCroppedFile;
              break;
            case 'back':
              backImage = finalCroppedFile;
              break;
            case 'inbody':
              inbodyImage = finalCroppedFile;
              break;
          }
        });
      }
    }
  }

  Future<void> submitData() async {
    final uri = Uri.parse("${Config.baseURL}/inbody/");
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${widget.Token}';

    if (frontImage != null) {
      request.files.add(await _fileToMultipart(frontImage!, 'front_image'));
    }
    if (sideImage != null) {
      request.files.add(await _fileToMultipart(sideImage!, 'side_image'));
    }
    if (backImage != null) {
      request.files.add(await _fileToMultipart(backImage!, 'back_image'));
    }
    if (inbodyImage != null) {
      request.files.add(await _fileToMultipart(inbodyImage!, 'inbody_image'));
    }
    request.fields['note'] = noteController.text;

    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data submitted successfully')),

      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data')),
      );
    }
  }

  Future<http.MultipartFile> _fileToMultipart(File file, String fieldName) async {
    final mimeTypeData = lookupMimeType(file.path)!.split('/');
    return http.MultipartFile.fromPath(
      fieldName,
      file.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Inbody Report'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildImagePicker('Upload A Photo From The Front', frontImage, 'front'),
            _buildImagePicker('Upload A Photo From The Side', sideImage, 'side'),
            _buildImagePicker('Upload A Photo From The Back', backImage, 'back'),
            _buildImagePicker('Upload An Inbody Photo', inbodyImage, 'inbody'),
            SizedBox(height: 20),


            Text('Note', style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 8),

            TextField(
              controller: noteController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Add your note here',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFff0336),),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, File? image, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 10),
        if (image == null)
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => pickAndCropImage(ImageSource.gallery, type),
                icon: Icon(Icons.photo_library, color: Color(0xFFff0336)),
                label: Text("Choose File"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800],
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => pickAndCropImage(ImageSource.camera, type),
                icon: Icon(Icons.camera_alt, color: Color(0xFFff0336)),
                label: Text("Take Photo"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
              ),
            ],
          ),
        if (image != null)
          Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Image.file(image, fit: BoxFit.cover),
                  ),
                ),
                child: Image.file(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Color(0xFFff0336)),
                onPressed: () {
                  setState(() {
                    switch (type) {
                      case 'front':
                        frontImage = null;
                        break;
                      case 'side':
                        sideImage = null;
                        break;
                      case 'back':
                        backImage = null;
                        break;
                      case 'inbody':
                        inbodyImage = null;
                        break;
                    }
                  });
                },
              ),
            ],
          ),
        SizedBox(height: 20),
      ],
    );
  }
}
