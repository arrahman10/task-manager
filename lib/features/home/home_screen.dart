import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_drawer.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/features/tasks/add_task_screen.dart';
import 'package:task_manager/features/tasks/task_model.dart';
import 'package:task_manager/features/tasks/task_status.dart';
import 'package:task_manager/features/tasks/widgets/status_count_card.dart';
import 'package:task_manager/features/tasks/widgets/task_list_tile.dart';
import 'package:task_manager/features/tasks/widgets/update_status_sheet.dart';
import 'package:task_manager/session/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskStatus _selectedStatus = TaskStatus.newTask;
  final List<TaskModel> _tasks = <TaskModel>[
    TaskModel(
      id: '1',
      title: 'Demo Task',
      description: 'This is a demo task for UI.',
      createdAt: DateTime.now(),
      status: TaskStatus.newTask,
    ),
  ];

  List<TaskModel> get _filteredTasks {
    return _tasks.where((TaskModel t) => t.status == _selectedStatus).toList();
  }

  int _countByStatus(TaskStatus status) {
    return _tasks.where((TaskModel t) => t.status == status).length;
  }

  Future<void> _openAddTask() async {
    final TaskModel? created = await Navigator.of(context).push<TaskModel>(
      MaterialPageRoute<TaskModel>(
        builder: (_) => const AddTaskScreen(),
      ),
    );

    if (created == null) return;
    setState(() => _tasks.insert(0, created));

    if (!mounted) return;
    AppSnackbar.show(
      context: context,
      message: 'Task created.',
      type: AppSnackbarType.success,
      bottomOffset: 24,
    );
  }

  Future<void> _changeStatus(TaskModel task) async {
    final TaskStatus? next = await showModalBottomSheet<TaskStatus>(
      context: context,
      isScrollControlled: true,
      builder: (_) => UpdateStatusSheet(
        initial: task.status,
      ),
    );

    if (next == null) return;
    setState(() {
      final int index = _tasks.indexWhere((TaskModel t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(status: next);
      }
    });
  }

  Future<void> _confirmDelete(TaskModel task) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Deleting...'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;
    setState(() => _tasks.removeWhere((TaskModel t) => t.id == task.id));
  }

  @override
  Widget build(BuildContext context) {
    final String name = (SessionManager.userName ?? 'Demo User').trim();
    final String email =
        (SessionManager.userEmail ?? 'demo@taskmanager.app').trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        child: const Icon(Icons.add),
      ),
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // GlassContainer(
                //   radius: 24,
                //   padding: const EdgeInsets.all(16),
                //   child: Row(
                //     children: <Widget>[
                //       const CircleAvatar(
                //         radius: 26,
                //         child: Icon(Icons.person_outline),
                //       ),
                //       const SizedBox(width: 12),
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             Text(
                //               name.isEmpty ? 'Demo User' : name,
                //               maxLines: 1,
                //               overflow: TextOverflow.ellipsis,
                //               style: Theme.of(context).textTheme.titleMedium,
                //             ),
                //             const SizedBox(height: 2),
                //             Text(
                //               email,
                //               maxLines: 1,
                //               overflow: TextOverflow.ellipsis,
                //               style: Theme.of(context).textTheme.bodySmall,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16),
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
                      label: TaskStatus.newTask.label,
                      count: _countByStatus(TaskStatus.newTask),
                      isSelected: _selectedStatus == TaskStatus.newTask,
                      onTap: () =>
                          setState(() => _selectedStatus = TaskStatus.newTask),
                    ),
                    StatusCountCard(
                      label: TaskStatus.inProgress.label,
                      count: _countByStatus(TaskStatus.inProgress),
                      isSelected: _selectedStatus == TaskStatus.inProgress,
                      onTap: () => setState(
                          () => _selectedStatus = TaskStatus.inProgress),
                    ),
                    StatusCountCard(
                      label: TaskStatus.cancelled.label,
                      count: _countByStatus(TaskStatus.cancelled),
                      isSelected: _selectedStatus == TaskStatus.cancelled,
                      onTap: () => setState(
                          () => _selectedStatus = TaskStatus.cancelled),
                    ),
                    StatusCountCard(
                      label: TaskStatus.completed.label,
                      count: _countByStatus(TaskStatus.completed),
                      isSelected: _selectedStatus == TaskStatus.completed,
                      onTap: () => setState(
                          () => _selectedStatus = TaskStatus.completed),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedStatus.label,
                  style: AppTypography.h1,
                ),
                const SizedBox(height: 12),
                if (_filteredTasks.isEmpty)
                  const GlassContainer(
                    radius: 24,
                    padding: EdgeInsets.all(16),
                    child: Text('No tasks found for this status.'),
                  )
                else
                  Column(
                    children: _filteredTasks.map((TaskModel task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskListTile(
                          task: task,
                          onChangeStatus: () => _changeStatus(task),
                          onDelete: () => _confirmDelete(task),
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
