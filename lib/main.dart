import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WaterTrackerScreen(),
    );
  }
}

class WaterTrackerScreen extends StatefulWidget {
  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int waterCount = 0;

  @override
  void initState() {
    super.initState();
    _loadWaterCount();
  }

  // Load saved water count
  Future<void> _loadWaterCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      waterCount = prefs.getInt('waterCount') ?? 0;
    });
  }

  // Save water count
  Future<void> _saveWaterCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('waterCount', waterCount);
  }

  void addWater() {
    setState(() {
      waterCount++;
    });
    _saveWaterCount();
  }

  void resetWaterCount() {
    setState(() {
      waterCount = 0;
    });
    _saveWaterCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Water Tracker")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$waterCount glasses of water",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: addWater,
            icon: Icon(Icons.local_drink),
            label: Text("Add a Glass"),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: resetWaterCount,
            icon: Icon(Icons.refresh),
            label: Text("Reset"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
