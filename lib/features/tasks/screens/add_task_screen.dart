import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/data/remote/task_api.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TaskApi _taskApi = TaskApi();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Title is required.';
    if (text.length < 2) return 'Please enter at least 2 characters.';
    return null;
  }

  String? _validateDescription(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Description is required.';
    if (text.length < 3) return 'Please enter at least 3 characters.';
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await _taskApi.createTask(
        title: _titleController.text,
        description: _descriptionController.text,
      );
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Task created successfully.',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to create task. Please try again.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _fieldDecoration({
    required String label,
  }) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GlassContainer(
                    radius: 24,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Add New Task',
                          style: AppTypography.h1,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          textInputAction: TextInputAction.next,
                          validator: _validateTitle,
                          decoration: _fieldDecoration(label: 'Title'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 6,
                          textInputAction: TextInputAction.done,
                          validator: _validateDescription,
                          decoration: _fieldDecoration(label: 'Description'),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: 'Create',
                          onPressed: _submit,
                          isBusy: _isSubmitting,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
