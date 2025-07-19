import 'package:hive/hive.dart';

part 'mental_meal.g.dart';

@HiveType(typeId: 0)
class MentalMeal extends HiveObject {
  @HiveField(0)
  String food;

  @HiveField(1)
  String mood;

  @HiveField(2)
  DateTime timestamp;

  MentalMeal({required this.food, required this.mood, required this.timestamp});
}
