import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/theme/loading.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGalleryPage extends StatefulWidget {
  final String Token;

  ImageGalleryPage({Key? key, required this.Token}) : super(key: key);

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<dynamic> imagesData = [];
  List<String> tags = [];
  int currentPage = 1;
  bool isLoading = false;
  String? selectedTag;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages({int page = 1, String? tag, bool clearPrevious = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (clearPrevious) imagesData.clear();
    });

    String apiUrl = "https://demo.team-hm.com/api/client/profile/files?page=$page&paginate=5";
    if (tag != null && tag.isNotEmpty) {
      apiUrl += "&tag=$tag";
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${widget.Token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      setState(() {
        imagesData.addAll(responseData['data']);
        totalPages = responseData['pagination']['last_page'];
        currentPage = responseData['pagination']['current_page'];

        if (tags.isEmpty) {
          tags = responseData['data']
              .map<String>((img) => img['tag'] as String)
              .toSet()
              .toList()
            ..insert(0, 'all');
        }
      });
    } else {
      print("Failed to load images");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _viewImageFullScreen(List<String> imageUrls, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: imageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = imagesData.map((image) => image['file'] as String).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Image Gallery".tr(context)),
        backgroundColor: Colors.black,
      ),
      body: imagesData.isEmpty ? Center(child: LoadingLogo(),): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedTag ?? 'all',
              items: tags.map((tag) {
                return DropdownMenuItem<String>(
                  value: tag,
                  child: Text(tag.replaceAll('_', ' ')), // Show friendly name
                );
              }).toList(),
              onChanged: (String? newTag) {
                setState(() {
                  selectedTag = newTag == 'all' ? null : newTag;
                  currentPage = 1;
                });
                fetchImages(page: 1, tag: selectedTag, clearPrevious: true);
              },
            ),
            Expanded(
              child: imagesData.isEmpty && isLoading
                  ? Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      currentPage < totalPages) {
                    fetchImages(page: currentPage + 1, tag: selectedTag);
                    return true;
                  }
                  return false;
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: imagesData.length,
                  itemBuilder: (context, index) {
                    final image = imagesData[index];
                    return GestureDetector(
                      onTap: () => _viewImageFullScreen(imageUrls, index),
                      child: CachedNetworkImage(
                        imageUrl: image['file'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    );
                  },
                ),
              ),
            ),
            if (isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenImageViewer({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            pageController: PageController(initialPage: initialIndex),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
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
              child: Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
