import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../model/task_model.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text.trim(),
      isDone: widget.task.isDone,
    );

    try {
      await Provider.of<TaskProvider>(
        context,
        listen: false,
      ).updateTask(uid, updatedTask);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal memperbarui tugas")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Membuat UI untuk mengedit tugas.
  ///
  /// Berisi judul tugas dan tombol untuk menyimpan perubahan.
  ///
  /// Jika tugas berhasil disimpan, maka akan kembali ke layar sebelumnya.
  /// Jika gagal, maka akan tampil pesan error.
  /*******  fe8d1c04-8afa-418b-8bb6-ecb78c1f4f0f  *******/
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Perubahan'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
