import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:gymjoe/theme/loading.dart';
import 'package:human_body_selector/human_body_selector.dart';
import 'package:human_body_selector/svg_painter/maps.dart';
import 'package:human_body_selector/svg_painter/models/body_part.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../diet_screen/diet_screen.dart';
import '../localization/app_localization.dart';

class AddMeasurements extends StatefulWidget {
  final String Token;

  AddMeasurements({Key? key, required this.Token}) : super(key: key);

  @override
  State<AddMeasurements> createState() => _AddMeasurementsState();
}

class _AddMeasurementsState extends State<AddMeasurements> {
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  List<dynamic> drawerItems = [];
  Map<String, dynamic> fetchedData = {};

  @override
  void initState() {
    super.initState();
    fetchTyps();

  }

  @override
  Widget build(BuildContext context) {
    final textDirection = AppLocalization.of(context).getAppDirection();
    final isRtl = textDirection == TextDirection.rtl;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Measurements Report",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:drawerItems.isEmpty ? Center(child: LoadingLogo()) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            buildMeasurementField(
              label: "Shoulder",
              controller: shoulderController,
              bodyParts: ["right shoulder", "left shoulder"],
              prefixIcon: drawerItems[0]["icon"],
              onPrefixTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => VideoPlayerScreen(videoUrl: drawerItems[0]["video"]),
    ),
    );

              },
            ),
            SizedBox(height: 25),
            buildMeasurementField(
              label: "Chest",
              controller: chestController,
              bodyParts: ["chest"],
              prefixIcon: drawerItems[1]["icon"],
              onPrefixTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: drawerItems[1]["video"]),
                  ),
                );
              },
            ),
            SizedBox(height: 25),
            buildMeasurementField(
              label: "Waist",
              controller: waistController,
              bodyParts: ["waist"],
              prefixIcon: drawerItems[2]["icon"],
              onPrefixTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: drawerItems[2]["video"]),
                  ),
                );
              },

            ),
            SizedBox(height: 25),
            buildMeasurementField(
              label: "Hip",
              controller: hipController,
              bodyParts: ["buttock"],
              prefixIcon:drawerItems[3]["icon"],
              onPrefixTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoUrl: drawerItems[3]["video"]),
                  ),
                );
              },
            ),
            SizedBox(height: 25),
            Text(
              "Note",
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 4,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: sendUpdates,
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> fetchTyps() async {
    var url = Uri.parse("${Config.baseURL}/measurements/fields/");
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
          drawerItems = jsonDecode(response.body)['data'];
        });
      } else {
        print('Failed to load types');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildMeasurementField({
    required String label,
    required TextEditingController controller,
    required List<String> bodyParts,
    required String prefixIcon,
    required VoidCallback onPrefixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // HumanBodySelector
            Expanded(
              flex: 2,
              child: HumanBodySelector(
                map: label == "Hip" ? Maps.MALE1 : Maps.MALE,
                initialSelectedPartsList: bodyParts,
                scale: 50,
                selectedColor: Colors.red,
                enabled: false,
                dotColor: Colors.transparent,
                toggle: false,
                height: 50,
                width: 50,
                onChanged: (List<BodyPart> city, BodyPart? active) {},
                onLevelChanged: (List<BodyPart> city) {},
              ),
            ),
            const SizedBox(width: 16),
            // Text Field with Prefix and Measurement Value
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // Prefix Icon with onTap
                  InkWell(
                    onTap: onPrefixTap,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.only(
                          topLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                          bottomLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                          topRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                          bottomRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                        ),
                      ),
                      child: Center(child: 
                      
                    /*  SvgPicture.network(prefixIcon,
                        height: 30,width: 30,)
                      */
                        Icon(Icons.info_outline,color:Color(0XFFFF0336) ,)
                      
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: TextField(
                        controller: controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                          /*  borderRadius: BorderRadius.only(
                              topRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                              bottomRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                              topLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                              bottomLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                            ),*/
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.only(
                        topRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                        bottomRight: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(8) : Radius.circular(0),
                        topLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                        bottomLeft: AppLocalization.of(context).getAppDirection() == TextDirection.ltr ? Radius.circular(0) : Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "cm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }


  Future<void> sendUpdates() async {
    final url = Uri.parse('${Config.baseURL}/measurements/');
    final body = {
      "shoulder": shoulderController.text,
      "chest": chestController.text,
      "waist": waistController.text,
      "hip": hipController.text,
      "note": noteController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurements updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update measurements!')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
