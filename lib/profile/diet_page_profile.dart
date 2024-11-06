import 'package:flutter/material.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DietPreferencesPage extends StatefulWidget {

  final String Token;

  DietPreferencesPage({Key? key, required this.Token}) : super(key: key);

  @override
  _DietPreferencesPageState createState() => _DietPreferencesPageState();
}

class _DietPreferencesPageState extends State<DietPreferencesPage> {
  final TextEditingController _dietRestrictionController = TextEditingController();
  final TextEditingController _excludeFoodsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _numMealsController = TextEditingController();



  List<dynamic> favoriteFoods = [];

  List<String> selectedFoods = [];


  @override
  void initState() {
    fetchProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Diet Preferences"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Diet Restrictions
            Text("Diet Restrictions", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _dietRestrictionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Favorite Foods
            Text("Choose Your Favorite Foods:", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: favoriteFoods.map((food) {
                  final isSelected = selectedFoods.contains(food);
                  return ChoiceChip(
                    label: Text(food.toString(), style: TextStyle(color: Colors.white)),
                    selected: isSelected,
                    selectedColor: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.9),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedFoods.add(food);
                        } else {
                          selectedFoods.remove(food);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Exclude Foods
            Text("Choose Foods That You Do Not Want To Be On The Diet:", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _excludeFoodsController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Allergies
            Text("If You Are Allergic To A Certain Thing, Please Choose It", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _allergiesController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Number of Meals
            Text("Number Of Meals", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            TextField(
              controller: _numMealsController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement next action here
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff0336),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<Map<String, dynamic>?> fetchProfileData() async {
    final url = Uri.parse('${Config.baseURL}/profile/get-data');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);


        favoriteFoods= data['data']['favorite_foods'];

        print(favoriteFoods);
      } else {
        print('Failed to load profile data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      return null;
    }
  }
}
