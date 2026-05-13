import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_text_field.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService = FirestoreService();
  
  DateTime _selectedDate = DateTime.now();
  bool _isCompleted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.indigo),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.indigo),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Task Title',
                      controller: _titleController,
                      validator: (val) => val != null && val.trim().isNotEmpty ? null : 'Please enter a title',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.calendar_month, color: Colors.indigo),
                      ),
                      title: const Text('Due Date & Time', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDate)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _pickDate(context),
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      secondary: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isCompleted ? Icons.check_circle : Icons.pending_actions,
                          color: _isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_isCompleted ? 'Completed' : 'Pending'),
                      value: _isCompleted,
                      activeColor: Colors.green,
                      onChanged: (val) => setState(() => _isCompleted = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text(
                    isEditing ? 'Update Task' : 'Create Task',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (widget.task != null) {
          final updatedTask = Task(
            id: widget.task!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            date: _selectedDate,
            isCompleted: _isCompleted,
          );
          await _firestoreService.updateTask(updatedTask);
        } else {
          final newTask = Task(
            id: '',
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            date: _selectedDate,
            isCompleted: _isCompleted,
          );
          await _firestoreService.addTask(newTask);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
