enum TaskStatus {
  newTask,
  inProgress,
  cancelled,
  completed,
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.newTask:
        return 'New';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}
