import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WaterTrackerScreen(),
    );
  }
}

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  int waterCount = 0; // Number of glasses drunk

  @override
  void initState() {
    super.initState();
    _loadWaterCount(); // Load saved water count
  }

  // Load saved water count from local storage
  Future<void> _loadWaterCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      waterCount = prefs.getInt('waterCount') ?? 0;
    });
  }

  // Save water count to local storage
  Future<void> _saveWaterCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterCount', waterCount);
  }

  // Increase water count
  void _addWater() {
    setState(() {
      waterCount++;
    });
    _saveWaterCount();
  }

  // Reset water count
  void _resetWater() {
    setState(() {
      waterCount = 0;
    });
    _saveWaterCount();
  }

  @override
  Widget build(BuildContext context) {
    double glassFill = (waterCount % 8) / 8.0; // Water fill level (0 to 1)

    return Scaffold(
      appBar: AppBar(title: const Text("Water Tracker")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Daily Water Intake",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Glass visualization
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 100,
                height: 200 * glassFill,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "$waterCount glasses of water",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Add Water Button
          ElevatedButton(
            onPressed: _addWater,
            child: const Text("Add a Glass"),
          ),

          // Reset Button
          TextButton(
            onPressed: _resetWater,
            child: const Text(
              "Reset",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
