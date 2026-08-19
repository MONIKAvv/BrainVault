import 'package:firebase_auth/firebase_auth.dart';
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

  String _getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'User';
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    if (user.email != null && user.email!.contains('@')) {
      final prefix = user.email!.split('@').first;
      if (prefix.isNotEmpty) {
        return prefix[0].toUpperCase() + prefix.substring(1);
      }
    }
    return 'User';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
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
    final userName = _getUserDisplayName();
    final greeting = _getGreeting();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 22)),
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
                note: note,
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
    required NoteItem note,
    required VoidCallback onTap,
  }) {
    final customLetter = note.title.isNotEmpty ? note.title[0].toUpperCase() : 'N';
    final subtitle = note.subtitle.isNotEmpty ? note.subtitle : _formatDate(note.createdAt);

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
                color: note.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  customLetter,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: note.iconColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
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
              icon: Icon(
                note.isPinned ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: note.isPinned ? AppColors.primaryViolet : AppColors.textDarkSecondary,
                size: 20,
              ),
              onPressed: () {
                _repository.toggleNotePin(note.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      note.isPinned ? 'Unpinned note' : 'Moved note to Pinned',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
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
    DateTime selectedDate = task.dueDate;
    String selectedTimeDisplay = task.time;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            final formattedDateStr = '${selectedDate.day} ${monthNames[selectedDate.month - 1]} ${selectedDate.year}';

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      hintText: 'What needs to be done?',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const Divider(color: AppColors.borderLight, height: 20),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setDialogState(() {
                          selectedDate = pickedDate;
                          final dateStr = '${pickedDate.day} ${monthNames[pickedDate.month - 1]} ${pickedDate.year}';
                          if (pickedTime != null) {
                            final h = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
                            final ampm = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                            final m = pickedTime.minute.toString().padLeft(2, '0');
                            selectedTimeDisplay = '$dateStr · $h:$m $ampm';
                          } else {
                            selectedTimeDisplay = dateStr;
                          }
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primaryViolet),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Due Date & Time',
                                  style: TextStyle(fontSize: 11, color: AppColors.textDarkSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedTimeDisplay.isNotEmpty ? selectedTimeDisplay : formattedDateStr,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit_calendar_rounded, size: 18, color: AppColors.primaryViolet),
                        ],
                      ),
                    ),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final titleText = titleController.text.trim();
                    if (titleText.isNotEmpty) {
                      final updatedTask = task.copyWith(
                        title: titleText,
                        time: selectedTimeDisplay,
                        dueDate: selectedDate,
                      );
                      _repository.saveTask(updatedTask);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
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
