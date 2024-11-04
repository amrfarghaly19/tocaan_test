
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../moves/fade.dart';
import 'add_inbody.dart';

class InBody extends StatefulWidget {
  final String Token;

  InBody({Key? key, required this.Token}) : super(key: key);

  @override
  State<InBody> createState() => _InBodyState();
}

class _InBodyState extends State<InBody> {
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
        title: Text("Inbody"),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Color(0xFFff0336),
              onPressed:() {
              Navigator.of(context).push(FadePageRoute(
                page: InbodyReportPage(Token:widget.Token),
              ));
            } ,
            child: Center(child: Icon(Icons.add,color: Colors.white,)),),
          )
        ],
      ),
      body: SafeArea(
        child: drawerItems.isEmpty
            ? Center(child: CircularProgressIndicator())
            : /*GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 5,
            crossAxisSpacing: 10,
          ),
          itemCount: drawerItems.length,
          itemBuilder: (context, index) {
            String slug = drawerItems[index]['slug'];
            var lastValue = fetchedData[slug]?.isNotEmpty ?? false
                ? fetchedData[slug].last['value']
                : 'N/A';
            return GestureDetector(
              onTap: () {
                final slug = drawerItems[index]['slug'];
                final data = fetchedData[slug] ?? [];
                showDataBottomSheet(context, slug, data);
              },
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.network(
                      drawerItems[index]['icon'],
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      drawerItems[index]['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Last: $lastValue",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),*/
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
            switch (slug) {
              case 'weight':
                maxY = 150;
                minY = 30;
                break;
              case 'body_fat_mass':
                maxY = 50;
                minY = 5;
                break;
              case 'bmi':
                maxY = 40;
                minY = 10;
                break;
              default:
                maxY = 100;
                minY = 0;
            }

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
                        child: LineChart(
                          LineChartData(
                            minY: minY,
                            maxY: maxY,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: (maxY - minY) / 4,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.white.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: Colors.white.withOpacity(0.3),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < data.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Transform.rotate(
                                          angle: 70 * 3.14159 / 180,
                                          child: Text(
                                            data[index]['date'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: (maxY - minY) / 5,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(color: Colors.white, width: 1),
                                bottom: BorderSide(color: Colors.white, width: 1),
                                top: BorderSide(color: Colors.transparent),
                                right: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.map<FlSpot>((entry) {
                                  double x = data.indexOf(entry).toDouble();
                                  double y = double.tryParse(entry['value'].toString()) ?? 0;
                                  return FlSpot(x, y);
                                }).toList(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: [Colors.red, Colors.redAccent],
                                ),
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withOpacity(0.3),
                                      Colors.redAccent.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.red,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ],

                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: Colors.white.withOpacity(0.8),
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    return LineTooltipItem(
                                      '${spot.y.toStringAsFixed(1)}',
                                      TextStyle(color: Colors.blueAccent, fontSize: 14),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
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
    var url = Uri.parse("${Config.baseURL}/inbody/fields");
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
    var url = Uri.parse("${Config.baseURL}/inbody");
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


  void showDataBottomSheet(BuildContext context, String slug, List data) {
    double maxY, minY;

    // Define Y-axis limits based on the slug
    switch (slug) {
      case 'weight':
        maxY = 150;
        minY = 30;
        break;
      case 'body_fat_mass':
        maxY = 50;
        minY = 5;
        break;
      case 'bmi':
        maxY = 40;
        minY = 10;
        break;
      default:
        maxY = 100;
        minY = 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(
                  slug.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 80),
                Expanded(
                  child: data.isEmpty
                      ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                    height: 150, // Set the height of the chart
                    width: double.infinity,
                          child: LineChart(

                    LineChartData(

                          minY: minY,
                          maxY: maxY,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: (maxY - minY) / 4,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.white.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(

                                showTitles: true,
                                reservedSize: 22,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < data.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Transform.rotate(
                                        angle: 70 * 3.14159 / 180,
                                        child: Text(
                                          data[index]['date'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(

                              sideTitles: SideTitles(
                                showTitles: true,

                                interval: (maxY - minY) / 5,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(color: Colors.white, width: 1),  // Red y-axis border line
                              bottom: BorderSide(color: Colors.white, width: 1), // Red x-axis border line
                              top: BorderSide(color: Colors.transparent),      // Hide top border
                              right: BorderSide(color: Colors.transparent),    // Hide right border
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: data.asMap().entries.map((entry) {
                                double x = entry.key.toDouble();
                                double y = double.tryParse(entry.value['value']) ?? 0;
                                return FlSpot(x, y);
                              }).toList(),
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.redAccent],
                              ),
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.withOpacity(0.3),
                                    Colors.redAccent.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.red,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.white.withOpacity(0.8),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toStringAsFixed(1)}',
                                    TextStyle(color: Colors.blueAccent, fontSize: 14),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                    ),
                  ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}


