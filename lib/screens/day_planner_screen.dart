import 'package:flutter/material.dart';

class DayPlannerScreen extends StatefulWidget {
  final DateTime day;

  const DayPlannerScreen({super.key, required this.day});

  @override
  State<DayPlannerScreen> createState() => _DayPlannerScreenState();
}

class _DayPlannerScreenState extends State<DayPlannerScreen> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final task = _controller.text.trim();
    if (task.isEmpty) return;

    setState(() {
      _tasks.add({
        'text': task,
        'time': TimeOfDay.now(),
      });
      _controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added: "$task"')),
    );
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate =
        '${widget.day.day}/${widget.day.month}/${widget.day.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text('$formattedDate Planner'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Plan your day 🌞',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Add task or ritual',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet.'))
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (_, index) {
                  final task = _tasks[index];
                  final time = task['time'] as TimeOfDay?;
                  final timeLabel = time != null
                      ? '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
                      : '';

                  return Dismissible(
                    key: Key(task['text']),
                    background: Container(color: Colors.red.shade200),
                    onDismissed: (_) => _removeTask(index),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(task['text']),
                        subtitle: timeLabel.isNotEmpty
                            ? Text('Logged at $timeLabel')
                            : null,
                      ),
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
