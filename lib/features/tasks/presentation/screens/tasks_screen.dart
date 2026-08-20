import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen #11: Tasks Screen ("My Tasks")
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Pinned', 'Today', 'Upcoming', 'Done'];
  final VaultRepository _repository = VaultRepository.instance;

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepositoryChanged);
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }

  void _onRepositoryChanged() {
    if (mounted) setState(() {});
  }

  void _showTaskFolderPicker(TaskItem task) {
    final folders = _repository.folders;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Move "${task.title}" to Folder',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              if (folders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'No folders yet.',
                        style: TextStyle(color: AppColors.textDarkSecondary),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(context, AppRouter.folder);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Manage & Create Folders'),
                      ),
                    ],
                  ),
                )
              else
                ...folders.map((folder) {
                  final isCurrent = task.folderName == folder.name;
                  return ListTile(
                    leading: Icon(Icons.folder_rounded, color: folder.color),
                    title: Text(
                      folder.name,
                      style: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrent
                            ? AppColors.primaryViolet
                            : AppColors.textDark,
                      ),
                    ),
                    trailing: isCurrent
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primaryViolet,
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      _repository.moveTaskToFolder(task.id, folder.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Moved task to "${folder.name}"'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }),
              if (task.folderName != null) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.folder_off_outlined,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Remove from Folder',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _repository.moveTaskToFolder(task.id, null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed task from folder'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<TaskItem> get _filteredTasks {
    final allTasks = _repository.tasks;
    final now = DateTime.now();

    switch (_selectedFilterIndex) {
      case 1: // Pinned
        return allTasks.where((t) => t.isPinned).toList();
      case 2: // Today
        return allTasks.where((t) {
          final isSameDay =
              t.dueDate.year == now.year &&
              t.dueDate.month == now.month &&
              t.dueDate.day == now.day;
          return isSameDay;
        }).toList();
      case 3: // Upcoming
        return allTasks.where((t) => !t.completed).toList();
      case 4: // Done
        return allTasks.where((t) => t.completed).toList();
      case 0: // All
      default:
        return allTasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedTasks = _filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
        //   onPressed: () {},
        // ),
        title: const Text(
          'My Tasks',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textDark),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.calendar);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              // Filter Chips Row
              _buildFilterChips(),
              const SizedBox(height: 16),

              // Scrollable Tasks List or Empty State
              Expanded(
                child: displayedTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: displayedTasks.length,
                        itemBuilder: (context, index) {
                          final task = displayedTasks[index];
                          return _buildTaskTile(task);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditTaskDialog(),
        backgroundColor: AppColors.primaryViolet,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedFilterIndex == 1
                ? Icons.bookmark_border_rounded
                : Icons.check_circle_outline_rounded,
            size: 48,
            color: AppColors.textDarkSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            _selectedFilterIndex == 1 ? 'No pinned tasks' : 'No tasks found',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _selectedFilterIndex == 1
                ? 'Click the bookmark icon on any task to pin it!'
                : 'Tap + to add a new task for any date!',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDarkSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryViolet : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryViolet
                        : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textDarkSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTaskTile(TaskItem task) {
    final Color accentColor = task.color;
    final bool completed = task.completed;
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateDisplay =
        '${task.dueDate.day} ${monthNames[task.dueDate.month - 1]} ${task.dueDate.year}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onLongPress: () => _showTaskFolderPicker(task),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              // Custom Checkbox
              GestureDetector(
                onTap: () {
                  final updatedTask = task.copyWith(completed: !completed);
                  _repository.saveTask(updatedTask);
                },
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: completed ? accentColor : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: accentColor, width: 2),
                  ),
                  child: completed
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAddOrEditTaskDialog(task),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: completed
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textDark,
                                decoration: completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          if (task.folderName != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryViolet.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.folderName!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryViolet,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: AppColors.textDarkSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$dateDisplay · ${task.time}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  task.isPinned
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  size: 18,
                  color: task.isPinned
                      ? AppColors.primaryViolet
                      : AppColors.textDarkSecondary,
                ),
                onPressed: () {
                  _repository.toggleTaskPin(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        task.isPinned
                            ? 'Unpinned task'
                            : 'Moved task to Pinned',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: task.isPinned ? 'Unpin Task' : 'Pin Task',
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textDarkSecondary,
                ),
                onPressed: () => _showAddOrEditTaskDialog(task),
                tooltip: 'Edit Task',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Colors.redAccent,
                ),
                onPressed: () => _showDeleteConfirmation(task),
                tooltip: 'Delete Task',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(TaskItem task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              _repository.deleteTask(task.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddOrEditTaskDialog([
    TaskItem? existingTask,
    DateTime? defaultDate,
  ]) {
    final titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final timeController = TextEditingController(
      text: existingTask?.time ?? '10:00 AM',
    );
    DateTime selectedDate =
        existingTask?.dueDate ?? defaultDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final monthNames = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            final formattedDateStr =
                '${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}';

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(existingTask == null ? 'Add New Task' : 'Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      hintText: 'What needs to be done?',
                      hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.borderLight, height: 20),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.primaryViolet,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Due Date',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textDarkSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formattedDateStr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.edit_calendar_rounded,
                            size: 18,
                            color: AppColors.primaryViolet,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: timeController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      prefixIcon: Icon(
                        Icons.access_time_rounded,
                        size: 18,
                        color: AppColors.primaryViolet,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 28,
                        minHeight: 18,
                      ),
                      hintText: 'Time (e.g. 10:00 AM)',
                      hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                if (existingTask != null)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(existingTask);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryViolet,
                  ),
                  onPressed: () {
                    final titleText = titleController.text.trim();
                    final timeText = timeController.text.trim();
                    if (titleText.isNotEmpty) {
                      final taskId =
                          existingTask?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString();
                      final task = TaskItem(
                        id: taskId,
                        title: titleText,
                        time: timeText.isNotEmpty ? timeText : '10:00 AM',
                        color: existingTask?.color ?? AppColors.primaryViolet,
                        completed: existingTask?.completed ?? false,
                        createdAt: existingTask?.createdAt ?? DateTime.now(),
                        dueDate: selectedDate,
                      );
                      _repository.saveTask(task);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    existingTask == null ? 'Add' : 'Save',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 5, // Tasks index
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRouter.notesList);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRouter.mindmap);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRouter.aiAssistant);
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, AppRouter.summary);
          } else if (index == 5) {
            // Already here
          } else if (index == 6) {
            Navigator.pushReplacementNamed(context, AppRouter.profile);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryViolet,
        unselectedItemColor: AppColors.textDarkSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_outlined),
            label: 'Mind Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize_outlined),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
