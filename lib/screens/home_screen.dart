import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import 'important_screen.dart';
import 'planned_screen.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    final importantCount = taskProvider.importantTasks.length;
    final plannedCount = taskProvider.plannedTasks.length;

    final userName = user?.displayName ?? 'Pengguna';
    final userEmail = user?.email ?? 'Email tidak tersedia';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E),
        child: ListView(
          padding: const EdgeInsets.only(top: 40, left: 16),
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  userInitial,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userEmail,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const Divider(color: Colors.white24),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Hari Saya',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.pinkAccent),
              title: const Text(
                'Penting',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                '$importantCount',
                style: const TextStyle(color: Colors.white),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ImportantScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.white),
              title: const Text(
                'Terencana',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                '$plannedCount',
                style: const TextStyle(color: Colors.white),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlannedScreen()),
                  ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // ✅ Ikon drawer putih
        title: const Text(
          'To Do',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // ✅ Background image
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),

          // ✅ Overlay gelap untuk kontras teks
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // ✅ Konten daftar tugas
          taskProvider.tasks.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada tugas.\nTekan + untuk menambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight + 32,
                  left: 16,
                  right: 16,
                  bottom: 80,
                ),
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return TaskTile(
                    task: task,
                    onTap: () {
                      taskProvider.toggleTask(
                        FirebaseAuth.instance.currentUser!.uid,
                        task,
                      );
                    },
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: task),
                        ),
                      );
                    },
                  );
                },
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            ),
      ),
    );
  }
}
