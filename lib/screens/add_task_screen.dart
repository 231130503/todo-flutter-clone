import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Checkbox
  bool _isImportant = false;
  bool _isPlanned = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final title = _titleController.text.trim();

    if (uid == null) {
      _showError("User tidak ditemukan.");
      return;
    }

    try {
      await Provider.of<TaskProvider>(
        context,
        listen: false,
      ).addTask(uid, title, isImportant: _isImportant, isPlanned: _isPlanned);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      _showError("Gagal menambahkan task.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Judul tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),

              /// ✅ Checkbox Penting
              CheckboxListTile(
                title: const Text("Tandai sebagai Penting"),
                value: _isImportant,
                onChanged: (value) {
                  setState(() {
                    _isImportant = value ?? false;
                  });
                },
              ),

              /// ✅ Checkbox Terencana
              CheckboxListTile(
                title: const Text("Tandai sebagai Terencana"),
                value: _isPlanned,
                onChanged: (value) {
                  setState(() {
                    _isPlanned = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 16),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
