import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen #7: Home Dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Greeting + Profile Picture)
              _buildHeader(),
              const SizedBox(height: 20),

              // Search Bar & Bell Icon
              _buildSearchBarRow(),
              const SizedBox(height: 24),

              // Quick Actions Section
              _buildQuickActionsSection(),
              const SizedBox(height: 24),

              // Recent Notes Section
              _buildRecentNotesSection(),
              const SizedBox(height: 24),

              // Upcoming Tasks Section
              _buildUpcomingTasksSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkSecondary,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'Aman',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(width: 6),
                Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
          ],
        ),
        // User Profile Avatar
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.profile),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryViolet.withValues(alpha: 0.1),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Search Bar + Notification Bell
  Widget _buildSearchBarRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRouter.search),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textDarkSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Search notes, tasks, files...',
                    style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textDark,
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // Quick Actions Section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionItem(
              bgColor: AppColors.quickActionNoteBg,
              iconColor: AppColors.quickActionNoteIcon,
              icon: Icons.edit_document,
              label: 'New Note',
              onTap: () => Navigator.pushNamed(context, AppRouter.noteEditor),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionAiBg,
              iconColor: AppColors.quickActionAiIcon,
              icon: Icons.track_changes_rounded,
              label: 'AI Chat',
              onTap: () => Navigator.pushNamed(context, AppRouter.aiAssistant),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionTaskBg,
              iconColor: AppColors.quickActionTaskIcon,
              icon: Icons.check_box_outlined,
              label: 'New Task',
              onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionScanBg,
              iconColor: AppColors.quickActionScanIcon,
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan',
              onTap: () => Navigator.pushNamed(context, AppRouter.scanner),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Notes Section
  Widget _buildRecentNotesSection() {
    final recentNotes = _repository.notes.take(3).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouter.notesList),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryViolet,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recentNotes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Center(
              child: Text(
                'No notes created yet. Tap "New Note" above!',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ),
          )
        else
          ...recentNotes.map((note) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _buildNoteTile(
                iconBg: note.iconBg,
                iconColor: note.iconColor,
                customLetter: note.title.isNotEmpty
                    ? note.title[0].toUpperCase()
                    : 'N',
                title: note.title,
                subtitle: note.subtitle.isNotEmpty
                    ? note.subtitle
                    : _formatDate(note.createdAt),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.noteEditor,
                  arguments: note,
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildNoteTile({
    required Color iconBg,
    required Color iconColor,
    IconData? icon,
    String? customLetter,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: customLetter != null
                    ? Text(
                        customLetter,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.bookmark_outline_rounded,
                color: AppColors.textDarkSecondary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Upcoming Tasks Section
  Widget _buildUpcomingTasksSection() {
    final upcomingTasks = _repository.tasks.take(3).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryViolet,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (upcomingTasks.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Center(
              child: Text(
                'No tasks scheduled. Tap "New Task" above!',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textDarkSecondary,
                ),
              ),
            ),
          )
        else
          ...upcomingTasks.map((task) => _buildHomeTaskTile(task)),
      ],
    );
  }

  Widget _buildHomeTaskTile(TaskItem task) {
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
                onTap: () => _showEditTaskDialog(task),
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
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.textDarkSecondary,
              ),
              onPressed: () => _showEditTaskDialog(task),
              tooltip: 'Edit Task',
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: Colors.redAccent,
              ),
              onPressed: () => _repository.deleteTask(task.id),
              tooltip: 'Delete Task',
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(TaskItem task) {
    final titleController = TextEditingController(text: task.title);
    final timeController = TextEditingController(text: task.time);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time / Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _repository.deleteTask(task.id);
              Navigator.pop(context);
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
                final updatedTask = task.copyWith(
                  title: titleText,
                  time: timeText.isNotEmpty ? timeText : task.time,
                );
                _repository.saveTask(updatedTask);
              }
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          if (index == 0) {
            // Already home
          } else if (index == 1) {
            Navigator.pushNamed(context, AppRouter.notesList);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRouter.mindmap);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRouter.aiAssistant);
          } else if (index == 4) {
            Navigator.pushNamed(context, AppRouter.summary);
          } else if (index == 5) {
            Navigator.pushNamed(context, AppRouter.tasks);
          } else if (index == 6) {
            Navigator.pushNamed(context, AppRouter.profile);
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
