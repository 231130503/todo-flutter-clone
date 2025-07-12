import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../model/task_model.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4), // semi-transparent background
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            fontWeight: task.isImportant ? FontWeight.bold : FontWeight.normal,
            shadows: const [
              Shadow(
                color: Colors.black,
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ],
          ),
        ),
        subtitle: task.subtitle != null
            ? Text(
                task.subtitle!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 1,
                    )
                  ],
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.isImportant)
              const Icon(Icons.star, color: Colors.pinkAccent, size: 20),
            if (task.isPlanned)
              const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Icon(
              task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.white,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (uid == null) return;
                if (value == 'important') {
                  provider.toggleImportant(uid, task);
                } else if (value == 'planned') {
                  provider.togglePlanned(uid, task);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'important',
                  child: Text(task.isImportant
                      ? 'Hapus dari Penting'
                      : 'Tandai sebagai Penting'),
                ),
                PopupMenuItem(
                  value: 'planned',
                  child: Text(task.isPlanned
                      ? 'Hapus dari Terencana'
                      : 'Tandai sebagai Terencana'),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
