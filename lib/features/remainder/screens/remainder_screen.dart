import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class _Reminder {
  String title;
  String schedule;
  bool enabled;
  TimeOfDay time;
  String repeat;

  _Reminder({
    required this.title,
    required this.schedule,
    required this.enabled,
    required this.time,
    this.repeat = 'Daily',
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class RemainderScreen extends StatefulWidget {
  const RemainderScreen({super.key});

  @override
  State<RemainderScreen> createState() => _RemainderScreenState();
}

class _RemainderScreenState extends State<RemainderScreen> {
  final List<_Reminder> _reminders = [
    _Reminder(
      title: 'Drink Water',
      schedule: 'Daily · 8:00 AM',
      enabled: true,
      time: const TimeOfDay(hour: 8, minute: 0),
    ),
    _Reminder(
      title: 'Take Break',
      schedule: 'Daily · 1:00 PM',
      enabled: true,
      time: const TimeOfDay(hour: 13, minute: 0),
    ),
    _Reminder(
      title: 'Night Walk',
      schedule: 'Daily · 7:00 PM',
      enabled: false,
      time: const TimeOfDay(hour: 19, minute: 0),
    ),
    _Reminder(
      title: 'Read Book',
      schedule: 'Daily · 9:30 PM',
      enabled: true,
      time: const TimeOfDay(hour: 21, minute: 30),
    ),
    _Reminder(
      title: 'Morning Walk',
      schedule: 'Daily · 6:00 AM',
      enabled: true,
      time: const TimeOfDay(hour: 6, minute: 0),
    ),
  ];

  // Sort: enabled first, then by time
  List<_Reminder> get _sorted {
    final list = List<_Reminder>.from(_reminders);
    list.sort((a, b) {
      if (a.enabled != b.enabled) return a.enabled ? -1 : 1;
      final aMin = a.time.hour * 60 + a.time.minute;
      final bMin = b.time.hour * 60 + b.time.minute;
      return aMin.compareTo(bMin);
    });
    return list;
  }

  void _showAddReminderDialog() {
    final titleCtrl = TextEditingController();
    String repeat = 'Daily';
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final surface =
            isDark ? AppColors.darkSurface : AppColors.lightSurface;
        final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        final textPrimary = isDark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary;

        return StatefulBuilder(
          builder: (ctx2, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx2).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('New Reminder',
                      style: AppTextStyles.h3(color: textPrimary)),
                  const SizedBox(height: 20),

                  // Title field
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Reminder title',
                      prefixIcon: Icon(Icons.alarm_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time picker row
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setSheetState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(14),
                        color: surface,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: AppColors.primaryPurple),
                          const SizedBox(width: 12),
                          Text(selectedTime.format(context),
                              style: AppTextStyles.subtitle(
                                  color: textPrimary)),
                          const Spacer(),
                          Icon(Icons.chevron_right,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Repeat selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: border),
                      borderRadius: BorderRadius.circular(14),
                      color: surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: repeat,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more),
                        items: ['Daily', 'Weekdays', 'Weekends', 'Once']
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s,
                                      style: AppTextStyles.body(
                                          color: textPrimary)),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setSheetState(() => repeat = v);
                        },
                        dropdownColor: surface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        final h = selectedTime.hourOfPeriod == 0
                            ? 12
                            : selectedTime.hourOfPeriod;
                        final ampm =
                            selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
                        final m = selectedTime.minute
                            .toString()
                            .padLeft(2, '0');
                        setState(() {
                          _reminders.add(_Reminder(
                            title: titleCtrl.text.trim(),
                            schedule: '$repeat · $h:$m $ampm',
                            enabled: true,
                            time: selectedTime,
                            repeat: repeat,
                          ));
                        });
                        Navigator.pop(ctx);
                      },
                      child: Text('Save Reminder',
                          style: AppTextStyles.button()),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteReminder(_Reminder r) {
    setState(() => _reminders.remove(r));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder "${r.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _reminders.add(r)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final sorted = _sorted;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Reminders',
          style: AppTextStyles.h3(
              color: theme.textTheme.titleLarge?.color),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  for (final r in _reminders) {
                    r.enabled = true;
                  }
                });
              },
              child: Text(
                'Enable All',
                style: AppTextStyles.bodySmall(
                    color: AppColors.primaryPurple),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: sorted.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.alarm_off_rounded,
                      size: 56, color: textSecondary),
                  const SizedBox(height: 12),
                  Text('No reminders yet',
                      style: AppTextStyles.body(color: textSecondary)),
                  const SizedBox(height: 8),
                  Text('Tap + to add your first reminder',
                      style: AppTextStyles.caption(color: textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              itemCount: sorted.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final reminder = sorted[index];
                return _ReminderCard(
                  reminder: reminder,
                  onToggle: (val) => setState(() => reminder.enabled = val),
                  onDelete: () => _deleteReminder(reminder),
                );
              },
            ),
    );
  }
}

// ── Reminder card ─────────────────────────────────────────────────────────────
class _ReminderCard extends StatelessWidget {
  final _Reminder reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Dismissible(
      key: ValueKey(reminder.title + reminder.schedule),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: reminder.enabled
                ? AppColors.primaryPurple.withValues(alpha: 0.3)
                : border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Alarm icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: reminder.enabled
                      ? AppColors.primaryPurple.withValues(alpha: 0.12)
                      : border.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.alarm_rounded,
                  color: reminder.enabled
                      ? AppColors.primaryPurple
                      : textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: AppTextStyles.subtitle(
                        color: reminder.enabled
                            ? theme.textTheme.bodyLarge?.color
                            : textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reminder.schedule,
                      style: AppTextStyles.caption(color: textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: reminder.enabled,
                onChanged: onToggle,
                activeThumbColor: AppColors.primaryPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
