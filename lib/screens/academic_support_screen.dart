import 'dart:async';
import 'package:flutter/material.dart';

class AcademicSupportScreen extends StatefulWidget {
  const AcademicSupportScreen({Key? key}) : super(key: key);

  @override
  _AcademicSupportScreenState createState() => _AcademicSupportScreenState();
}

class _AcademicSupportScreenState extends State<AcademicSupportScreen> {
  int _timeLeft = 25 * 60;
  Timer? _timer;
  bool isRunning = false;

  final List<String> _goals = [
    "Review biology notes 🧬",
    "Practice math problems ➕",
    "Summarize history reading 📚",
  ];

  void _toggleTimer() {
    if (isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          setState(() {
            _timeLeft--;
          });
        } else {
          timer.cancel();
          setState(() {
            isRunning = false;
            _timeLeft = 25 * 60;
          });
        }
      });
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Academic Support")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Pomodoro Timer 🍅",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTime(_timeLeft),
              style: const TextStyle(fontSize: 48),
            ),
            ElevatedButton(
              onPressed: _toggleTimer,
              child: Text(isRunning ? "Pause" : "Start Focus Session"),
            ),
            const Divider(height: 32),
            const Text(
              "Today's Study Goals 📝",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._goals.map((goal) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(goal),
            )),
            const Spacer(),
            const Text(
              "“Small steps lead to big victories.” 💚",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
