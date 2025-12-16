import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/features/tasks/models/task_item.dart';

class TaskListTile extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onChangeStatus;
  final VoidCallback onDelete;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onChangeStatus,
    required this.onDelete,
  });

  String _displayDate(String raw) {
    final String v = raw.trim();
    if (v.isEmpty) return '-';
    final DateTime? dt = DateTime.tryParse(v);
    if (dt == null) return v;
    final String d = dt.day.toString().padLeft(2, '0');
    final String m = dt.month.toString().padLeft(2, '0');
    final String y = dt.year.toString();
    return '$d-$m-$y';
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                if (task.description.trim().isNotEmpty)
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 6),
                Text(
                  _displayDate(task.createdDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: <Widget>[
              IconButton(
                onPressed: onChangeStatus,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
