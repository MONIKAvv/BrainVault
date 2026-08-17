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
  final List<String> _filters = ['All', 'Today', 'Upcoming', 'Done'];
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

  List<TaskItem> get _filteredTasks {
    final allTasks = _repository.tasks;
    final now = DateTime.now();

    switch (_selectedFilterIndex) {
      case 1: // Today
        return allTasks.where((t) {
          final isSameDay = t.createdAt.year == now.year &&
              t.createdAt.month == now.month &&
              t.createdAt.day == now.day;
          return isSameDay || t.time.toLowerCase().contains('today') || t.time.toLowerCase().contains('now');
        }).toList();
      case 2: // Upcoming
        return allTasks.where((t) => !t.completed).toList();
      case 3: // Done
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
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
          onPressed: () {},
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: AppColors.textDarkSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tap + to add a new task!',
            style: TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textDarkSecondary,
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
                  border: Border.all(
                    color: accentColor,
                    width: 2,
                  ),
                ),
                child: completed
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
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
                    Text(
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
                    const SizedBox(height: 2),
                    Text(
                      task.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textDarkSecondary),
              onPressed: () => _showAddOrEditTaskDialog(task),
              tooltip: 'Edit Task',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
              onPressed: () => _showDeleteConfirmation(task),
              tooltip: 'Delete Task',
            ),
          ],
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
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

  void _showAddOrEditTaskDialog([TaskItem? existingTask]) {
    final titleController = TextEditingController(text: existingTask?.title ?? '');
    final timeController = TextEditingController(text: existingTask?.time ?? 'Today, 10:00 AM');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(existingTask == null ? 'Add New Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter task name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time / Date',
                hintText: 'e.g. Today, 2:00 PM',
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
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
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
                final taskId = existingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
                final task = TaskItem(
                  id: taskId,
                  title: titleText,
                  time: timeText.isNotEmpty ? timeText : 'Just now',
                  color: existingTask?.color ?? AppColors.primaryViolet,
                  completed: existingTask?.completed ?? false,
                  createdAt: existingTask?.createdAt ?? DateTime.now(),
                );
                _repository.saveTask(task);
              }
              Navigator.pop(context);
            },
            child: Text(existingTask == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
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
