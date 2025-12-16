import 'package:task_manager/features/tasks/task_status.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final TaskStatus status;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
