import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/features/tasks/task_status_value.dart';

class UpdateStatusSheet extends StatefulWidget {
  final String initial;

  const UpdateStatusSheet({
    super.key,
    required this.initial,
  });

  @override
  State<UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends State<UpdateStatusSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = TaskStatusValue.normalize(widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Update Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...TaskStatusValue.all.map((String s) {
              return RadioListTile<String>(
                value: s,
                groupValue: _selected,
                onChanged: (String? v) {
                  if (v == null) return;
                  setState(() => _selected = v);
                },
                title: Text(TaskStatusValue.label(s)),
              );
            }),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Update',
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ],
        ),
      ),
    );
  }
}
