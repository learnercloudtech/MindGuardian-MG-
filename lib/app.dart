import 'package:flutter/material.dart';
import 'screens/mood_tracker_screen.dart'; // or correct path
 // or wherever MyHomePage is defined

class MindGuardianApp extends StatelessWidget {
  const MindGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindGuardian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MoodTrackerScreen(), // or whatever your widget is called

    );
  }
}
