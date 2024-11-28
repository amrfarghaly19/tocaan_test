/*
// lib/body_3d_viewer.dart
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Body3DViewer extends StatefulWidget {
  @override
  _Body3DViewerState createState() => _Body3DViewerState();
}

class _Body3DViewerState extends State<Body3DViewer> {
  Object? _selectedObject;

  // Example data for body parts
  final Map<String, String> bodyData = {
    'Head': 'The head houses the brain and is responsible for cognitive functions.',
    'Heart': 'The heart pumps blood throughout the body, supplying oxygen and nutrients.',
    'Lungs': 'The lungs are essential for breathing, facilitating the exchange of oxygen and carbon dioxide.',
    'Arm': 'Arms enable movement and interaction with the environment.',
    'Leg': 'Legs support the body’s weight and facilitate locomotion.',
    // Add more body parts and their descriptions here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive 3D Body'),
      ),
      body: Column(
        children: [
          SizedBox(height: 200,),
          Container(
            height: 500,
            child: Cube(
              onSceneCreated: (Scene scene) {
                scene.world.add(Object(
                  scale: Vector3.all(2.0),
                  fileName: 'assets/3d/base.obj',
                ));
                scene.camera.zoom = 6;
              },
              interactive: true,
              onObjectCreated: (Object object) {
                // Optional: Handle object creation
              },

            */
/*  on: (HitResult? hitResult) {
                if (hitResult != null && hitResult.object != null) {
                  print('Tapped on: ${hitResult.object.name}');
                  setState(() {
                    _selectedObject = hitResult.object;
                  });
                  _showDataDialog(_selectedObject);
                }
              },*//*


            ),
          ),
        ],
      ),
    );
  }

  void _showDataDialog(Object? object) {
    if (object == null) return;

    String partName = object.name ?? 'Unknown Part';
    String data = bodyData[partName] ?? 'No data available for this part.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$partName Details'),
        content: Text(data),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
*/




import 'package:flutter/material.dart';
import 'package:human_body_selector/human_body_selector.dart';
import 'package:human_body_selector/svg_painter/maps.dart';

class Body3DViewer extends StatefulWidget {
  @override
  _Body3DViewerState createState() => _Body3DViewerState();
}

class _Body3DViewerState extends State<Body3DViewer> {
  // Pre-selecting body parts


  final List<String> _preSelectedParts = [];

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Body Selector'),
      ),
      body: Row(
        children: [
          Center(
            child: HumanBodySelector(
              map: Maps.HUMAN,
             // multiSelect: true,
             // toggle: true,
              initialSelectedPartsList:["right shoulder","left shoulder","chest", "waist"],

              selectedColor: Colors.red,

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
          Center(
            child: HumanBodySelector(
              map: Maps.HUMAN1,
              // multiSelect: true,
              // toggle: true,
              initialSelectedPartsList:["buttock"],


              selectedColor: Colors.red,

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
        ],
      ),
    );
  }
}
