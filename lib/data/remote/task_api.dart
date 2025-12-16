import 'package:task_manager/data/remote/api_client.dart';
import 'package:task_manager/features/tasks/models/task_item.dart';
import 'package:task_manager/features/tasks/task_status_value.dart';

class TaskApi {
  final ApiClient _client;

  TaskApi({ApiClient? client}) : _client = client ?? ApiClient();

  Future<Map<String, int>> getStatusCounts() async {
    final Map<String, dynamic> response = await _client.get(
      '/taskStatusCount',
      useAuthToken: true,
    );

    final List<dynamic> data =
        response['data'] is List ? response['data'] as List : <dynamic>[];

    final Map<String, int> counts = <String, int>{
      TaskStatusValue.newTask: 0,
      TaskStatusValue.inProgress: 0,
      TaskStatusValue.cancelled: 0,
      TaskStatusValue.completed: 0,
    };

    for (final dynamic row in data) {
      if (row is! Map) continue;
      final Map<String, dynamic> m = Map<String, dynamic>.from(row as Map);
      final String rawStatus =
          (m['_id'] ?? m['status'] ?? '').toString().trim();
      final int sum =
          int.tryParse((m['sum'] ?? m['count'] ?? 0).toString()) ?? 0;
      if (rawStatus.isEmpty) continue;
      final String key = TaskStatusValue.normalize(rawStatus);
      if (!counts.containsKey(key)) continue;
      counts[key] = sum;
    }

    return counts;
  }

  Future<List<TaskItem>> listByStatus(String status) async {
    final String safeStatus =
        Uri.encodeComponent(TaskStatusValue.normalize(status));
    final Map<String, dynamic> response = await _client.get(
      '/listTaskByStatus/$safeStatus',
      useAuthToken: true,
    );

    final List<dynamic> data =
        response['data'] is List ? response['data'] as List : <dynamic>[];
    return data
        .whereType<Map>()
        .map((Map e) => TaskItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> createTask({
    required String title,
    required String description,
  }) async {
    await _client.post(
      '/createTask',
      useAuthToken: true,
      body: <String, dynamic>{
        'title': title.trim(),
        'description': description.trim(),
        'status': TaskStatusValue.newTask,
      },
    );
  }

  Future<void> updateTaskStatus({
    required String id,
    required String status,
  }) async {
    final String safeId = Uri.encodeComponent(id);
    final String safeStatus =
        Uri.encodeComponent(TaskStatusValue.normalize(status));
    await _client.get(
      '/updateTaskStatus/$safeId/$safeStatus',
      useAuthToken: true,
    );
  }

  Future<void> deleteTask({
    required String id,
  }) async {
    final String safeId = Uri.encodeComponent(id);
    await _client.get(
      '/deleteTask/$safeId',
      useAuthToken: true,
    );
  }
}
