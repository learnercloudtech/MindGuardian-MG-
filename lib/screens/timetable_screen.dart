import 'package:flutter/material.dart';
import 'day_planner_screen.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  DateTime _getDateForWeekday(String weekday) {
    final now = DateTime.now();
    final weekdayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    final targetWeekday = weekdayMap[weekday] ?? now.weekday;
    final offset = targetWeekday - now.weekday;
    return now.add(Duration(days: offset));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Planner'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Weekly Rituals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (_, index) {
                  final dayLabel = days[index];
                  final dayDate = _getDateForWeekday(dayLabel);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(dayLabel[0])),
                      title: Text(dayLabel),
                      subtitle: Text('Tap to edit your routine'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DayPlannerScreen(day: dayDate),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
