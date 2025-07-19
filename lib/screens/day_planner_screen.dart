import 'package:flutter/material.dart';

class DayPlannerScreen extends StatefulWidget {
  final String day;

  const DayPlannerScreen({super.key, required this.day});

  @override
  State<DayPlannerScreen> createState() => _DayPlannerScreenState();
}

class _DayPlannerScreenState extends State<DayPlannerScreen> {
  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final task = _controller.text.trim();
    if (task.isEmpty) return;

    setState(() {
      _tasks.add(task);
      _controller.clear();
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.day} Planner'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Add a task or ritual',
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
                  return Dismissible(
                    key: Key(_tasks[index]),
                    background: Container(color: Colors.red),
                    onDismissed: (_) => _removeTask(index),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_box_outline_blank),
                        title: Text(_tasks[index]),
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
