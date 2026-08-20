import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen #12: Interactive Calendar Screen with Dynamic Date Filtering & Firebase Integration
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  final VaultRepository _repository = VaultRepository.instance;

  final List<String> _daysOfWeek = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDate = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
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

  void _previousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<TaskItem> get _tasksForSelectedDate {
    return _repository.tasks
        .where((t) => _isSameDay(t.dueDate, _selectedDate))
        .toList();
  }

  bool _hasTasksOnDate(DateTime date) {
    return _repository.tasks.any((t) => _isSameDay(t.dueDate, date));
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      _focusedDate.year,
      _focusedDate.month + 1,
      0,
    ).day;
    final firstWeekday = DateTime(
      _focusedDate.year,
      _focusedDate.month,
      1,
    ).weekday; // 1 = Monday, 7 = Sunday
    final leadingBlankSpaces = firstWeekday - 1;
    final totalGridCells = leadingBlankSpaces + daysInMonth;

    final formattedSelectedDateStr =
        '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textDark,
              ),
              onPressed: _previousMonth,
            ),
            Text(
              '${_monthNames[_focusedDate.month - 1]} ${_focusedDate.year}',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDark,
              ),
              onPressed: _nextMonth,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.textDark,
              size: 26,
            ),
            onPressed: () => _showAddOrEditTaskDialog(),
            tooltip: 'Add Task for Selected Date',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Grid Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Day Labels Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _daysOfWeek
                          .map(
                            (day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDarkSecondary,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Month Days Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                          ),
                      itemCount: totalGridCells,
                      itemBuilder: (context, index) {
                        final dayNumber = index - leadingBlankSpaces + 1;
                        if (dayNumber < 1 || dayNumber > daysInMonth) {
                          return const SizedBox();
                        }

                        final cellDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month,
                          dayNumber,
                        );
                        final isSelected = _isSameDay(cellDate, _selectedDate);
                        final hasTask = _hasTasksOnDate(cellDate);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = cellDate;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryViolet
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textDark,
                                  ),
                                ),
                                if (hasTask)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primaryViolet,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Selected Date Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks for $formattedSelectedDateStr',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddOrEditTaskDialog(),
                    child: const Text(
                      '+ Add Task',
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

              // Tasks List for Selected Date
              Expanded(
                child: _tasksForSelectedDate.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.event_note_rounded,
                              size: 44,
                              color: AppColors.textDarkSecondary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No tasks scheduled for $formattedSelectedDateStr',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textDarkSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _showAddOrEditTaskDialog(),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Add Task for this Date'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryViolet,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _tasksForSelectedDate.length,
                        itemBuilder: (context, index) {
                          final task = _tasksForSelectedDate[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _buildAgendaTile(task),
                          );
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
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildAgendaTile(TaskItem task) {
    final Color accentColor = task.color;
    final bool completed = task.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          // Checkbox
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
            onPressed: () => _showAddOrEditTaskDialog(task),
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
    );
  }

  void _showAddOrEditTaskDialog([TaskItem? existingTask]) {
    final titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final timeController = TextEditingController(
      text: existingTask?.time ?? '10:00 AM',
    );
    DateTime selectedDate = existingTask?.dueDate ?? _selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final formattedDateStr =
                '${selectedDate.day} ${_monthNames[selectedDate.month - 1]} ${selectedDate.year}';

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                existingTask == null
                    ? 'Add Task for $formattedDateStr'
                    : 'Edit Task',
              ),
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
                      _repository.deleteTask(existingTask.id);
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
                      setState(() {
                        _selectedDate = selectedDate;
                        _focusedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                        );
                      });
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
            Navigator.pushReplacementNamed(context, AppRouter.tasks);
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
