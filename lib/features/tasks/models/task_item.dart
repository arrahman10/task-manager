class TaskItem {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdDate;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final String id = (json['_id'] ?? json['id'] ?? '').toString();
    final String title = (json['title'] ?? '').toString();
    final String description = (json['description'] ?? '').toString();
    final String status = (json['status'] ?? '').toString();
    final String createdDate =
        (json['createdDate'] ?? json['created_at'] ?? '').toString();

    return TaskItem(
      id: id,
      title: title,
      description: description,
      status: status,
      createdDate: createdDate,
    );
  }
}
