

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymjoe/activity/activity_page.dart';
import 'package:gymjoe/injures/add_injures.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/moves/fade.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configre/globale_variables.dart';
import 'add_medical_case.dart';

class MedicalCase extends StatefulWidget {
  final String Token;

  MedicalCase({Key? key, required this.Token}) : super(key: key);

  @override
  State<MedicalCase> createState() => _MedicalCaseState();
}

class _MedicalCaseState extends State<MedicalCase> {
  List<dynamic> entries = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Medical Cases".tr(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Color(0xFFff0336),
              onPressed: () async{

                final result = await Navigator.of(context).push(FadePageRoute(
                  page: AddMedicalCasePage(Token: widget.Token),
                ));

                // Check if the result is not null and is successful, then call fetchData()
                if (result == 'refresh') {
                  fetchData();
                }

              /*  Navigator.of(context).push(FadePageRoute(
                  page: AddInjuryPage(Token: widget.Token),
                ));*/
              },
              child: Center(child: Icon(Icons.add, color: Colors.white)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: entries.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final disease_name = entry['disease_name'] ?? 'Medical Case'.tr(context);
            final doctorNotes = entry['doctor_notes'] ?? 'No notes'.tr(context);
            final reassessmentDate = entry['reassessment_date'] ?? 'N/A'.tr(context);
            final createdAt = entry['created_at'] ?? 'N/A'.tr(context);

            // Extract image URLs
            final List<String> imageUrls = (entry['files'] as List<dynamic>)
                .map((file) => file['src'] as String)
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1F1F1F),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ExpansionTile(
                  title: Text(
                    disease_name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Date:".tr(context) + "$reassessmentDate",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Doctor Notes:".tr(context)+  "$doctorNotes",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                        /*  Text(
                            "Reassessment Date: $reassessmentDate",
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Text(
                            "Created At: $createdAt",
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),*/
                          SizedBox(height: 10),
                  if (imageUrls.isNotEmpty)
              GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, imgIndex) {
                return GestureDetector(
                  onTap: () => _viewImageFullScreen(imageUrls, imgIndex),
                  child: Image.network(
                    imageUrls[imgIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        // Image is fully loaded, display it
                        return child;
                      } else {
                        // Display loading indicator while the image is loading
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),

            ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    var url = Uri.parse("${Config.baseURL}/medical/diseases");
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          entries = jsonDecode(response.body)['data'];
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _viewImageFullScreen(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
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
                imageProvider: NetworkImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
