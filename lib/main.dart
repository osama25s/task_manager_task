import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TaskManagerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskModel {
  final String id;
  final String title;
  final IconData icon;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.icon,
    this.isDone = false,
  });
}

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  List<TaskModel> tasks = [
    TaskModel(
      id: "1",
      title: "Complete Flutter Assignment",
      icon: Icons.drag_handle,
    ),
    TaskModel(
      id: "2",
      title: "Review Clean Architecture",
      icon: Icons.drag_handle,
    ),
    TaskModel(
      id: "3",
      title: "Practice Widget Catalog",
      icon: Icons.drag_handle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        title: const Text(
          'Task Manager Page',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.id),
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            confirmDismiss: (direction) async {
              final answer = await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Delete'),
                      content: Text(
                        'Do You wnat to delet "${task.title}" task ؟',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
              return answer ?? false;
            },
            onDismissed: (direction) {
              final removedIndex = tasks.indexWhere((t) => t.id == task.id);
              if (removedIndex == -1) return;
              final removedTask = tasks.removeAt(removedIndex);

              setState(() {});
            },
            child: TaskCard(
              key: ValueKey(task.id),
              task: task,
              onChanged: (val) {
                setState(() {
                  task.isDone = val ?? false;
                });
              },
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) newIndex -= 1;
            final item = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, item);
          });
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?> onChanged;

  const TaskCard({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: CheckboxListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          value: task.isDone,
          onChanged: onChanged,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          title: Row(
            children: [
              Icon(task.icon, color: Colors.black54, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    decoration:
                        task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    decorationColor: Colors.grey[600],
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
