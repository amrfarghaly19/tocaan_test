import 'package:flutter/material.dart';



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Measurements Report",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            buildMeasurementField("Shoulder", shoulderController),
            SizedBox(height: 16),
            buildMeasurementField("Chest", chestController),
            SizedBox(height: 16),
            buildMeasurementField("Waist", waistController),
            SizedBox(height: 16),
            buildMeasurementField("Hip", hipController),
            SizedBox(height: 16),
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
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Submit button action
                },
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMeasurementField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[400]),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child:   Container(
                height: 50,
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
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
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
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
      ],
    );
  }
}
