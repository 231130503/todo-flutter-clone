import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class ImportantScreen extends StatelessWidget {
  const ImportantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Penting'),
        backgroundColor: const Color.fromARGB(255, 98, 212, 253),
      ),
      body:
          provider.importantTasks.isEmpty
              ? const Center(child: Text('Belum ada tugas penting'))
              : ListView.builder(
                itemCount: provider.importantTasks.length,
                itemBuilder: (context, index) {
                  final task = provider.importantTasks[index];
                  return TaskTile(task: task, onTap: () {}, onLongPress: () {});
                },
              ),
    );
  }
}
