
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:gymjoe/measurements/body_model.dart';
import 'package:gymjoe/theme/loading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:human_body_selector/human_body_selector.dart';
import 'package:human_body_selector/svg_painter/maps.dart';

import '../moves/fade.dart';
import 'add_measurements.dart';


class measurementsPage extends StatefulWidget {
  final String Token;

  measurementsPage({Key? key, required this.Token}) : super(key: key);

  @override
  State<measurementsPage> createState() => _measurementsPageState();
}

class _measurementsPageState extends State<measurementsPage> {
  List<dynamic> drawerItems = [];
  Map<String, dynamic> fetchedData = {};

  @override
  void initState() {
    super.initState();
    fetchTyps();
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
        title: Text("Measurements"),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Color(0xFFff0336),
              onPressed:() {
                Navigator.of(context).push(FadePageRoute(
                  page:// Body3DViewer(),

                  AddMeasurements(Token:widget.Token),
                ));
              } ,
              child: Center(child: Icon(Icons.add,color: Colors.white,)),),
          )
        ],
      ),
      body: SafeArea(
        child: drawerItems.isEmpty
            ? Center(child: LoadingLogo())
            :
        ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: drawerItems.length,
          itemBuilder: (context, index) {
            String slug = drawerItems[index]['slug'];
            var lastValue = fetchedData[slug]?.isNotEmpty ?? false
                ? fetchedData[slug].last['value']
                : 'N/A';
            final data = fetchedData[slug] ?? [];
            double maxY, minY;

            // Define Y-axis limits based on the slug


            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1F1F1F),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0XFFFF0336).withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ExpansionTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.network(
                        drawerItems[index]['icon'],
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            drawerItems[index]['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),

                          Text(
                            "Last Update: $lastValue",
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 250,
                      child: data.isEmpty
                          ? Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: HumanBodySelector(
                          map: index == 3 ? Maps.MALE1: Maps.MALE,
                          // multiSelect: true,
                          // toggle: true,
                             initialSelectedPartsList: index == 0 ? ["right shoulder","left shoulder"] :
                             index == 1 ? ["chest"] :
                             index == 2 ? ["waist"] :
                             index == 3 ? ["buttock"] :
                             [], // Provide an empty list as the default

                          scale: 50,

                          selectedColor: Color(0xFFff0336),

                          enabled: false,
                          dotColor: Colors.transparent,
                          toggle: true,
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width /2,
                          onChanged: (bodyPart, active) {
                            print("BodyPart: $bodyPart");
                            //  print("Active: ${Maps.HUMAN.bodyPart.toString()}");

                            setState(() {
                              // Update state if needed, e.g., dynamically manage active parts
                            });
                          },
                          onLevelChanged: (bodyPart) {
                            print("BodyPart: $bodyPart");
                            // Handle level change events here
                          },
                          // Pre-select body parts

                          // Display tooltips/labels with values
                          /* tooltipBuilder: (bodyPart) {
                final partName = bodyPart.name;
                final value = _bodyPartValues[partName] ?? 'No Value';
                return '$partName: $value';
              },*/
                        ),
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

  Future<void> fetchData() async {
    var url = Uri.parse("${Config.baseURL}/measurements");
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
          fetchedData = jsonDecode(response.body)['data'];
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }






}


