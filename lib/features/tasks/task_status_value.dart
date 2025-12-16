abstract final class TaskStatusValue {
  static const String newTask = 'New';
  static const String inProgress = 'Progress';
  static const String cancelled = 'Cancelled';
  static const String completed = 'Completed';

  static const List<String> all = <String>[
    newTask,
    inProgress,
    cancelled,
    completed,
  ];

  static String normalize(String raw) {
    final String v = raw.trim();
    if (v.isEmpty) return newTask;

    final String lower = v.toLowerCase();

    if (lower == 'new' || lower == 'newtask' || lower == 'new_task')
      return newTask;

    // accept both backend-style and UI-style inputs
    if (lower == 'progress' ||
        lower == 'inprogress' ||
        lower == 'in progress' ||
        lower == 'in_progress') {
      return inProgress; // keep internal value as 'Progress'
    }

    if (lower == 'cancelled' || lower == 'canceled' || lower == 'cancel')
      return cancelled;

    if (lower == 'completed' || lower == 'complete' || lower == 'done')
      return completed;

    return v;
  }

  static String label(String status) {
    final String v = normalize(status);
    switch (v) {
      case inProgress:
        return 'In Progress';
      default:
        return v;
    }
  }
}
