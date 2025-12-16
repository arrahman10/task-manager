import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_drawer.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/data/remote/task_api.dart';
import 'package:task_manager/features/tasks/models/task_item.dart';
import 'package:task_manager/features/tasks/screens/add_task_screen.dart';
import 'package:task_manager/features/tasks/task_status_value.dart';
import 'package:task_manager/session/session_manager.dart';
import 'package:task_manager/features/tasks/widgets/status_count_card.dart';
import 'package:task_manager/features/tasks/widgets/task_list_tile.dart';
import 'package:task_manager/features/tasks/widgets/update_status_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskApi _taskApi = TaskApi();

  bool _isLoadingCounts = false;
  bool _isLoadingList = false;

  String _selectedStatus = TaskStatusValue.newTask;
  Map<String, int> _counts = <String, int>{
    TaskStatusValue.newTask: 0,
    TaskStatusValue.inProgress: 0,
    TaskStatusValue.cancelled: 0,
    TaskStatusValue.completed: 0,
  };

  List<TaskItem> _tasks = <TaskItem>[];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait(<Future<void>>[
      _loadCounts(),
      _loadTasks(status: _selectedStatus),
    ]);
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoadingCounts = true);
    try {
      final Map<String, int> counts = await _taskApi.getStatusCounts();
      setState(() => _counts = counts);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to load status counts.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } finally {
      if (mounted) setState(() => _isLoadingCounts = false);
    }
  }

  Future<void> _loadTasks({required String status}) async {
    setState(() => _isLoadingList = true);
    try {
      final List<TaskItem> items = await _taskApi.listByStatus(status);
      if (!mounted) return;
      setState(() => _tasks = items);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to load tasks.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } finally {
      if (mounted) setState(() => _isLoadingList = false);
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait(<Future<void>>[
      _loadCounts(),
      _loadTasks(status: _selectedStatus),
    ]);
  }

  Future<void> _openCreateTask() async {
    final bool? created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const AddTaskScreen(),
      ),
    );
    if (created == true) {
      await _refreshAll();
    }
  }

  Future<void> _confirmDelete(TaskItem item) async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deleting...'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (yes != true) return;

    try {
      await _taskApi.deleteTask(id: item.id);
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Task deleted successfully.',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );
      await _refreshAll();
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to delete task.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    }
  }

  Future<void> _openUpdateStatus(TaskItem item) async {
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => UpdateStatusSheet(
        initial: item.status.isEmpty ? _selectedStatus : item.status,
      ),
    );

    if (selected == null || selected.trim().isEmpty) return;

    try {
      await _taskApi.updateTaskStatus(id: item.id, status: selected);
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Status updated successfully.',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );
      await _refreshAll();
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to update status.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    }
  }

  void _onStatusTab(String status) {
    final String next = TaskStatusValue.normalize(status);
    if (next == _selectedStatus) return;
    setState(() => _selectedStatus = next);
    _loadTasks(status: next);
  }

  @override
  Widget build(BuildContext context) {
    final String name = (SessionManager.userName ?? 'Demo User').trim();
    final String email =
        (SessionManager.userEmail ?? 'demo@taskmanager.app').trim();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateTask,
        child: const Icon(Icons.add),
      ),
      body: ScreenBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const Text(
                  'Overview',
                  style: AppTypography.h1,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    StatusCountCard(
                      label: TaskStatusValue.label(TaskStatusValue.newTask),
                      count: _counts[TaskStatusValue.newTask] ?? 0,
                      isSelected: _selectedStatus == TaskStatusValue.newTask,
                      onTap: () => _onStatusTab(TaskStatusValue.newTask),
                    ),
                    StatusCountCard(
                      label: TaskStatusValue.label(TaskStatusValue.inProgress),
                      count: _counts[TaskStatusValue.inProgress] ?? 0,
                      isSelected: _selectedStatus == TaskStatusValue.inProgress,
                      onTap: () => _onStatusTab(TaskStatusValue.inProgress),
                    ),
                    StatusCountCard(
                      label: TaskStatusValue.label(TaskStatusValue.cancelled),
                      count: _counts[TaskStatusValue.cancelled] ?? 0,
                      isSelected: _selectedStatus == TaskStatusValue.cancelled,
                      onTap: () => _onStatusTab(TaskStatusValue.cancelled),
                    ),
                    StatusCountCard(
                      label: TaskStatusValue.label(TaskStatusValue.completed),
                      count: _counts[TaskStatusValue.completed] ?? 0,
                      isSelected: _selectedStatus == TaskStatusValue.completed,
                      onTap: () => _onStatusTab(TaskStatusValue.completed),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  TaskStatusValue.label(_selectedStatus),
                  style: AppTypography.h1,
                ),
                const SizedBox(height: 12),
                if (_isLoadingList)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_tasks.isEmpty)
                  const GlassContainer(
                    radius: 24,
                    padding: EdgeInsets.all(16),
                    child: Text('No tasks found for this status.'),
                  )
                else
                  Column(
                    children: _tasks.map((TaskItem item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskListTile(
                          task: item,
                          onChangeStatus: () => _openUpdateStatus(item),
                          onDelete: () => _confirmDelete(item),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
