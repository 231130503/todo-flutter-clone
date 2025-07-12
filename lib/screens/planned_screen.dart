import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class PlannedScreen extends StatelessWidget {
  const PlannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Terencana'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body:
          provider.plannedTasks.isEmpty
              ? const Center(child: Text('Belum ada tugas terencana'))
              : ListView.builder(
                itemCount: provider.plannedTasks.length,
                itemBuilder: (context, index) {
                  final task = provider.plannedTasks[index];
                  return TaskTile(task: task, onTap: () {}, onLongPress: () {});
                },
              ),
    );
  }
}
