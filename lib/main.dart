import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/mood_log.dart';
import 'models/mental_meal.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🔵 Initializing Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  print("📦 Hive initialized at: ${appDocDir.path}");

  // ✅ Adapter registration with dynamic typeId protection
  final moodAdapterTypeId = MoodLogAdapter().typeId;
  final mealAdapterTypeId = MentalMealAdapter().typeId;

  if (!Hive.isAdapterRegistered(moodAdapterTypeId)) {
    Hive.registerAdapter(MoodLogAdapter());
    print("✅ MoodLogAdapter registered with typeId $moodAdapterTypeId");
  } else {
    print("⚠️ MoodLogAdapter already registered (typeId $moodAdapterTypeId)");
  }

  if (!Hive.isAdapterRegistered(mealAdapterTypeId)) {
    Hive.registerAdapter(MentalMealAdapter());
    print("✅ MentalMealAdapter registered with typeId $mealAdapterTypeId");
  } else {
    print("⚠️ MentalMealAdapter already registered (typeId $mealAdapterTypeId)");
  }

  await Hive.openBox<MoodLog>('moodLogs');
  await Hive.openBox<MentalMeal>('mentalMeals');
  print("📂 Hive boxes opened successfully");

  runApp(const MindGuardianApp());
}

class MindGuardianApp extends StatelessWidget {
  const MindGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("🌿 Building MindGuardianApp...");
    return MaterialApp(
      title: 'MindGuardian',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const SafeScaffold(),
    );
  }
}

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      print("🧭 Entering MainNavigation...");
      return const MainNavigation();
    } catch (e) {
      print("❌ Error rendering MainNavigation: $e");
      return Scaffold(
        body: Center(
          child: Text(
            "Something went wrong.\nPlease restart the app.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }
}
