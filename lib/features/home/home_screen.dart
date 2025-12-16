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
      builder: (BuildContext context) {
        return _UpdateStatusSheet(
          initial: item.status.isEmpty ? _selectedStatus : item.status,
        );
      },
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
    if (status == _selectedStatus) return;
    setState(() => _selectedStatus = status);
    _loadTasks(status: status);
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
                Text(
                  name.isEmpty ? 'Demo User' : name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _StatusCountRow(
                  isLoading: _isLoadingCounts,
                  counts: _counts,
                  selected: _selectedStatus,
                  onTap: _onStatusTab,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(child: Text('No tasks found.')),
                  )
                else
                  ..._tasks.map((TaskItem item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassContainer(
                        radius: 16,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.createdDate,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  _StatusChip(
                                    text: TaskStatusValue.label(
                                      item.status.isEmpty
                                          ? _selectedStatus
                                          : item.status,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () => _openUpdateStatus(item),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () => _confirmDelete(item),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;

  const _StatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
      ),
      child: Text(text),
    );
  }
}

class _StatusCountRow extends StatelessWidget {
  final bool isLoading;
  final Map<String, int> counts;
  final String selected;
  final void Function(String status) onTap;

  const _StatusCountRow({
    required this.isLoading,
    required this.counts,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = TaskStatusValue.all;

    return Row(
      children: statuses.map((String s) {
        final int c = counts[s] ?? 0;
        final bool active = s == selected;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () => onTap(s),
              borderRadius: BorderRadius.circular(16),
              child: GlassContainer(
                radius: 16,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    Text(
                      isLoading ? '-' : c.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TaskStatusValue.label(s),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _UpdateStatusSheet extends StatefulWidget {
  final String initial;

  const _UpdateStatusSheet({required this.initial});

  @override
  State<_UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends State<_UpdateStatusSheet> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
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
            Text(
              'Update Status',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ...TaskStatusValue.all.map((String s) {
              return RadioListTile<String>(
                value: s,
                groupValue: _selected,
                title: Text(TaskStatusValue.label(s)),
                onChanged: (String? v) =>
                    setState(() => _selected = v ?? _selected),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_selected),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
