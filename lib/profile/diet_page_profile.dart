
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'package:gymjoe/theme/loading.dart';
import 'package:http/http.dart' as http;
import 'package:gymjoe/configre/globale_variables.dart';

// Model class for Food items
// Model class for Food items
// Model class for Food items
class Food {
  final int id;
  final String foodName;
  final String groupName;
  final int groupId;

  Food({required this.id, required this.foodName, required this.groupName, required this.groupId});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      foodName: json['food_name'],
      groupName: json['group'] != null ? json['group']['group_name'] ?? 'Unknown Group' : 'Unknown Group',
      groupId: json['group'] != null ? json['group']['id'] : 0,
    );
  }
}

class DietPreferencesPage extends StatefulWidget {
  final String Token;

  DietPreferencesPage({Key? key, required this.Token}) : super(key: key);

  @override
  _DietPreferencesPageState createState() => _DietPreferencesPageState();
}

class _DietPreferencesPageState extends State<DietPreferencesPage> {
  final TextEditingController _dietRestrictionController = TextEditingController();
  final TextEditingController _numMealsController = TextEditingController();



  // Lists to hold all available foods fetched from the API
  List<String> uniqueGroups = [];
  Map<String, int> groupToIdMap = {};
  List<Food> allFoods = [];
  // List to hold selected group IDs
  List<int> selectedGroupIds = [];

  bool isLoading = true; // To manage loading state
  bool isSubmitting = false; // To manage submission state


  // Lists to hold selected food objects
  List<Food> selectedFavoriteFoods = [];
  List<Food> selectedHateFoods = [];
  List<Food> selectedAllergicFoods = [];
  // Controllers for Autocomplete fields
  final TextEditingController _favoriteFoodController = TextEditingController();
  final TextEditingController _hateFoodController = TextEditingController();
  final TextEditingController _allergicFoodController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchAllFoods();
    fetchProfileData();
  }


  @override
  void dispose() {
    _dietRestrictionController.dispose();
    _numMealsController.dispose();
    super.dispose();
  }

  // Fetch all foods from the /cooking/food API
  Future<void> fetchAllFoods() async {
    final url = Uri.parse('${Config.baseURL}/cooking/food');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          allFoods = List<Food>.from(
            data.map((food) => Food.fromJson(food)),
          );
          // Extract unique group names and map to their group IDs
          uniqueGroups = allFoods
              .map((food) => food.groupName)
              .toSet()
              .toList();
          groupToIdMap = {
            for (var food in allFoods) food.groupName: food.groupId
          };
        });
      } else {
        print('Failed to load foods. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load foods. Please try again later.')),
        );
      }
    } catch (e) {
      print('Error fetching foods: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching foods.')),
      );
    }
  }

  // Fetch profile data from the API
  Future<void> fetchProfileData() async {
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
        final data = jsonDecode(response.body)['data'];

        // Parse favorite_foods
        if (data['favorite_foods'] != null) {
          selectedFavoriteFoods = List<Food>.from(
            data['favorite_foods'].map((food) => Food.fromJson(food)),
          );
        }

        // Parse hate_foods
        if (data['hate_foods'] != null) {
          selectedHateFoods = List<Food>.from(
            data['hate_foods'].map((food) => Food.fromJson(food)),
          );
        }

        // Parse allergic_foods
        if (data['allergic_foods'] != null) {
          selectedAllergicFoods = List<Food>.from(
            data['allergic_foods'].map((food) => Food.fromJson(food)),
          );
        }

        // Set other fields
        _dietRestrictionController.text = data['diet_restrictions'] ?? '';
        _numMealsController.text = data['meals_num']?.toString() ?? '';
       // _dietRestrictionController.clear();
        setState(() {
          isLoading = false;
        });
      } else {
        print('Failed to load profile data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile data. Please try again later.'.tr(context))),
        );
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching profile data.'.tr(context))),
      );
    }
  }

  // Method to handle form submission


  Future<void> updateDietPreferences() async {
    setState(() {
      isSubmitting = true;
    });

    final url = Uri.parse('${Config.baseURL}/settings/diet');

    try {
      // Create the JSON payload
      final payload = {
        'diet_restrictions': _dietRestrictionController.text,
        'meals_num': days.toString(),
        'favorite_foods': selectedFavoriteFoods.map((food) => food.id).toList(),
        'hate_foods': selectedHateFoods.map((food) => food.id).toList(),
        'allergic_foods': selectedAllergicFoods.map((food) => food.id).toList(),
      };

      // Send the POST request with raw JSON
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
          "Accept-Encoding":"gzip, deflate, br"
        },
        body: jsonEncode(payload), // Convert payload to JSON
      );

      // Parse and print the response
      final responseBody = response.body;

      try {
        final jsonResponse = jsonDecode(responseBody);
        print('Response (JSON): $jsonResponse');
      } catch (e) {
        print('Response (Non-JSON): $responseBody');
      }

      // Handle the response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diet preferences updated successfully!'.tr(context))),
        );
      } else {
        print('Failed to update diet preferences. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update diet preferences. Please try again.'.tr(context))),
        );
      }
    } catch (e) {
      print('Error updating diet preferences: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while updating preferences.'.tr(context))),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }




  // Widget to build Autocomplete with selected items displayed as Chips
  Widget buildAutocompleteField({
    required String label,

    required List<Food> selectedFoodsList,
    required Function(Food) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(height: 8),
        Autocomplete<Food>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<Food>.empty();
            }
            return allFoods.where((Food food) {
              return food.foodName.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (Food option) => option.foodName,
          onSelected: (Food selection) {
            // Prevent duplicates
            if (!selectedFoodsList.contains(selection)) {
              onSelected(selection);



            }
          },
          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
              FocusNode focusNode, VoidCallback onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                hintText: "Search food...".tr(context),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),

                suffixIcon: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){
                  textEditingController.clear();
                },),
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: selectedFoodsList.map((Food food) {
            return Chip(
              label: Text(
                food.foodName,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0XFFFF0336),
              deleteIcon: Icon(Icons.close, color: Colors.white),
              onDeleted: () {
                setState(() {
                  selectedFoodsList.remove(food);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }



  Widget buildGroupAutocompleteField2({
    required String label,
    required List<int> selectedIds,
    required Function(int) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return uniqueGroups.where((group) {
              return group.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (String option) => option,
          onSelected: (String selection) {
            final groupId = groupToIdMap[selection];
            if (groupId != null && !selectedIds.contains(groupId)) {
              setState(() {
                onSelected(groupId);
              });
            }
          },
          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
              FocusNode focusNode, VoidCallback onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                hintText: "Search by group name...".tr(context),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(icon: Icon(Icons.close,color: Colors.white,),onPressed: (){
                  textEditingController.clear();
                },)
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: selectedIds.map((int id) {
            final groupName = groupToIdMap.keys.firstWhere((key) => groupToIdMap[key] == id, orElse: () => '');
            return Chip(
              label: Text(
                groupName,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0XFFFF0336),
              deleteIcon: Icon(Icons.close, color: Colors.white),
              onDeleted: () {
                setState(() {
                  selectedIds.remove(id);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back, color: Colors.white,)),

    title: Text(
          "Diet Preferences".tr(context),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
        child: LoadingLogo()
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Diet Restrictions
            Text(
              "Diet Restrictions".tr(context),
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
           /* TextField(
              controller: _dietRestrictionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                hintText: "e.g., Vegan, Gluten-Free".tr(context),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),*/
        DropdownButtonFormField<String>(
          value: _dietRestrictionController.text.isNotEmpty ? _dietRestrictionController.text : null,
          onChanged: (value) {
            setState(() {
              _dietRestrictionController.text = value!; // Set the selected value
            });
          },
          items: [
            DropdownMenuItem(
              value: "muslim",
              child: Text("Muslim".tr(context), style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: "christian",
              child: Text("Christian".tr(context), style: TextStyle(color: Colors.white)),
            ),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1F1F1F),
            hintText: "e.g., Vegan, Gluten-Free".tr(context),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: Color(0xFF1F1F1F), // Dropdown background color
        ),



        SizedBox(height: 20),

            // Favorite Foods Autocomplete
            buildAutocompleteField(
              label: "Choose Your Favorite Foods:".tr(context),
              selectedFoodsList: selectedFavoriteFoods,
              onSelected: (Food food) {
                setState(() {
                  selectedFavoriteFoods.add(food);

                });
              },
            ),

            // Hate Foods Autocomplete
            buildAutocompleteField(
              label: "Choose Foods That You Do Not Want To Be On The Diet:".tr(context),
              selectedFoodsList: selectedHateFoods,

              onSelected: (Food food) {
                setState(() {
                  selectedHateFoods.add(food);
                });
              },
            ),

            // Allergies Autocomplete
            buildGroupAutocompleteField2(
              label: "Select Food Groups:".tr(context),
              selectedIds: selectedGroupIds,
              onSelected: (int groupId) {
                selectedGroupIds.add(groupId);
              },
            ),

            // Number of Meals
            Text(
              "Number Of Meals".tr(context),
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Decrement Button

            IconButton(
              icon: Icon(Icons.remove, color: Colors.white),
              onPressed: decrementDays,
            ),
            // Days Display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$days",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            // Increment Button
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: incrementDays,
            ),
          ],
        ),
         /*   TextField(
              controller: _numMealsController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                hintText: "e.g., 3",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),*/
            SizedBox(height: 20),

            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                  // Optionally, add validation here
                  updateDietPreferences();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff0336),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: isSubmitting
                    ? Center(
                 
                  child:LoadingLogo()
                )
                    : Text(
                  "Save".tr(context),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  int days = 3; // Initialize with minimum days

  void incrementDays() {
    if (days < 7) {
      setState(() {
        days++;
      });
    }
  }

  void decrementDays() {
    if (days > 3) {
      setState(() {
        days--;
      });
    }
  }
}
