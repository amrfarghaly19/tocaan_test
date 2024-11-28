import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gymjoe/Auth/forget_password.dart';
import 'package:gymjoe/configre/globale_variables.dart';
import 'package:gymjoe/localization/app_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'diet_screen.dart';





class FoodPage extends StatefulWidget {

  final String Token;

  FoodPage({Key? key, required this.Token}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

/*
class _FoodPageState extends State<FoodPage> {
  // Replace this URL with your actual API endpoint
  final String apiUrl = '${Config.baseURL}/cooking';

  late Future<List<Food>> futureFoodList;

  @override
  void initState() {
    super.initState();
    futureFoodList = fetchFoodData();
  }

  Future<List<Food>> fetchFoodData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.Token}', // Add the token here
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Food> foods = [];
        for (var item in data['data']) {
          foods.add(Food.fromJson(item));
        }
        return foods;
      } else {
        throw Exception('Failed to load food data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Food>>(
        future: futureFoodList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0XFFFF0336)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Color(0XFFFF0336), fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No food items available.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            return _buildFoodList(snapshot.data!);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Food Items', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildFoodList(List<Food> foods) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Padding(
            padding: const EdgeInsets.all(8.0),
        child: Container(

        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1F1F1F),

        ),
          child: ExpansionTile(
            leading: _buildLeadingIcon(food.group.icon),
            title: Text(
              food.foodName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildThumbnail(food.thumbnail),
                    SizedBox(height: 10),
                    Text(
                      'How to Cook:',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      food.howToCook.replaceAll('\\r\\n', '\n'),
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    _buildMacros(food.macros),
                    SizedBox(height: 10),
                    Center(child: _buildVideoSection(food.video)),
                  ],
                ),
              ),
            ],
          ),
        )
        );
      },
    );
  }

  Widget _buildLeadingIcon(String? iconUrl) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      if (iconUrl.endsWith('.svg')) {
        return SvgPicture.network(
          iconUrl,
          placeholderBuilder: (context) => CircularProgressIndicator(color: Color(0XFFFF0336)),
          width: 40,
          height: 40,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: iconUrl,
          placeholder: (context, url) => CircularProgressIndicator(color: Color(0XFFFF0336)),
          errorWidget: (context, url, error) => Icon(Icons.error, color: Color(0XFFFF0336)),
          width: 40,
          height: 40,
        );
      }
    } else {
      return Icon(Icons.fastfood, color: Color(0XFFFF0336), size: 40);
    }
  }

  Widget _buildThumbnail(String thumbnailUrl) {
    return CachedNetworkImage(
      imageUrl: thumbnailUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Color(0XFFFF0336))),
      errorWidget: (context, url, error) => Icon(Icons.error, color: Color(0XFFFF0336), size: 50),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildMacros(Macros macros) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroItem('Carbs', macros.carbs),
        _buildMacroItem('Fats', macros.fats),
        _buildMacroItem('Proteins', macros.proteins),
        _buildMacroItem('Calories', macros.calories),
      ],
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0XFFFF0336), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildVideoSection(String videoUrl) {
    // Placeholder for video player
    // Implement video playback as needed
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      },
      child: Container(
        width:MediaQuery.of(context).size.width/2.1 ,
        height: 40,
        // height: height,
        decoration: BoxDecoration(
          color: Color(0XFFFF0336), // Red background color
          borderRadius: BorderRadius.circular(8), // Rounded edges with radius 20
          */
/*  boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],*//*

        ),
        child: Center(
          child: Text(
            "Watch Video",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
*/

class _FoodPageState extends State<FoodPage> {
  final String apiUrl = '${Config.baseURL}/cooking';

  late Future<List<Food>> futureFoodList;
  List<Food> foodList = [];
  List<Food> filteredFoodList = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureFoodList = fetchFoodData();
  }

  Future<List<Food>> fetchFoodData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.Token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Food> foods = [];
        for (var item in data['data']) {
          foods.add(Food.fromJson(item));
        }
        // Initialize filtered list with all food items
        setState(() {
          foodList = foods;
          filteredFoodList = foods;
        });
        return foods;
      } else {
        throw Exception('Failed to load food data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void filterFoods(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFoodList = foodList; // Reset to the full list
      });
    } else {
      setState(() {
        filteredFoodList = foodList
            .where((food) =>
        food.foodName.toLowerCase().contains(query.toLowerCase()) ||
            food.group.groupName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: futureFoodList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Color(0XFFFF0336)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Color(0XFFFF0336), fontSize: 18),
                    ),
                  );
                } else if (!snapshot.hasData || foodList.isEmpty) {
                  return Center(
                    child: Text(
                      'No food items available.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                } else {
                  return _buildFoodList(filteredFoodList);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(String? iconUrl) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      if (iconUrl.endsWith('.svg')) {
        return SvgPicture.network(
          iconUrl,
          placeholderBuilder: (context) => CircularProgressIndicator(color: Color(0XFFFF0336)),
          width: 40,
          height: 40,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: iconUrl,
          placeholder: (context, url) => CircularProgressIndicator(color: Color(0XFFFF0336)),
          errorWidget: (context, url, error) => Icon(Icons.error, color: Color(0XFFFF0336)),
          width: 40,
          height: 40,
        );
      }
    } else {
      return Icon(Icons.fastfood, color: Color(0XFFFF0336), size: 40);
    }
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        onChanged: filterFoods, // Call the filter function on input change
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF1F1F1F),
          hintText: 'Search food or group...'.tr(context),
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Food Items'.tr(context), style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildFoodList(List<Food> foods) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1F1F1F),
            ),
            child: ExpansionTile(
              leading: _buildLeadingIcon(food.group.icon),
              title: Text(
                food.foodName,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildThumbnail(food.thumbnail),
                      SizedBox(height: 10),
                      Text(
                        'How to Cook:'.tr(context),
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        food.howToCook.replaceAll('\\r\\n', '\n'),
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 10),
                      _buildMacros(food.macros),
                      SizedBox(height: 10),
                      Center(child: _buildVideoSection(food.video)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildVideoSection(String videoUrl) {
    // Placeholder for video player
    // Implement video playback as needed
    return InkWell(
        onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
        ),
      );
    },
    child: Container(
    width:MediaQuery.of(context).size.width/2.1 ,
    height: 40,
    // height: height,
    decoration: BoxDecoration(
    color: Color(0XFFFF0336), // Red background color
    borderRadius: BorderRadius.circular(8), // Rounded edges with radius 20

        ),
        child: Center(
          child: Text(
            "Watch Video".tr(context),
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
  Widget _buildMacros(Macros macros) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroItem('Carbs'.tr(context), macros.carbs),
        _buildMacroItem('Fats'.tr(context), macros.fats),
        _buildMacroItem('Proteins'.tr(context), macros.proteins),
        _buildMacroItem('Calories'.tr(context), macros.calories),
      ],
    );
  }
  Widget _buildThumbnail(String thumbnailUrl) {
    return CachedNetworkImage(
      imageUrl: thumbnailUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Color(0XFFFF0336))),
      errorWidget: (context, url, error) => Icon(Icons.error, color: Color(0XFFFF0336), size: 50),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Color(0XFFFF0336), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }


}


// Model Classes Defined Within main.dart

class Food {
  final int id;
  final int groupId;
  final Group group;
  final String foodName;
  final String foodType;
  final int? quantity;
  final String icon;
  final String video;
  final String thumbnail;
  final String howToCook;
  final Macros macros;
  final String? baseMacro;
  final String? serveUnit;
  final int? serveQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Food({
    required this.id,
    required this.groupId,
    required this.group,
    required this.foodName,
    required this.foodType,
    this.quantity,
    required this.icon,
    required this.video,
    required this.thumbnail,
    required this.howToCook,
    required this.macros,
    this.baseMacro,
    this.serveUnit,
    this.serveQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      groupId: json['group_id'],
      group: Group.fromJson(json['group']),
      foodName: json['food_name'],
      foodType: json['food_type'],
      quantity: json['quantity'],
      icon: json['icon'] ?? '',
      video: json['video'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      howToCook: json['how_to_cook'] ?? '',
      macros: Macros.fromJson(json['macros']),
      baseMacro: json['base_macro'],
      serveUnit: json['serve_unit'],
      serveQuantity: json['serve_quantity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Group {
  final int id;
  final String groupName;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.groupName,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['group_name'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Macros {
  final String carbs;
  final String fats;
  final String proteins;
  final String calories;

  Macros({
    required this.carbs,
    required this.fats,
    required this.proteins,
    required this.calories,
  });

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      carbs: json['carbs'],
      fats: json['fats'],
      proteins: json['proteins'],
      calories: json['calories'],
    );
  }
}
