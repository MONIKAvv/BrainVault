import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/vault_repository.dart';

/// Service to track and calculate user activity streak (Days Streak)
class StreakService {
  static const String _keyActivityDates = 'brainvault_user_activity_dates';

  /// Formats DateTime as YYYY-MM-DD
  static String formatDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  /// Records today as an active day
  static Future<void> recordTodayActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dates = prefs.getStringList(_keyActivityDates) ?? [];
      final todayStr = formatDate(DateTime.now());
      if (!dates.contains(todayStr)) {
        dates.add(todayStr);
        await prefs.setStringList(_keyActivityDates, dates);
      }
    } catch (_) {}
  }

  /// Calculates the consecutive active days streak
  static Future<int> calculateStreak(VaultRepository repository) async {
    try {
      await recordTodayActivity();
      final prefs = await SharedPreferences.getInstance();
      final storedDates = prefs.getStringList(_keyActivityDates) ?? [];

      final Set<String> activeDates = Set<String>.from(storedDates);

      for (final note in repository.notes) {
        activeDates.add(formatDate(note.createdAt));
      }
      for (final task in repository.tasks) {
        activeDates.add(formatDate(task.createdAt));
      }
      for (final s in repository.summaries) {
        activeDates.add(formatDate(s.createdAt));
      }
      for (final m in repository.mindMaps) {
        activeDates.add(formatDate(m.createdAt));
      }

      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);
      final todayStr = formatDate(todayDate);

      int streak = 0;
      DateTime cursor = todayDate;

      // Check consecutive days starting from today backwards
      if (activeDates.contains(todayStr)) {
        while (activeDates.contains(formatDate(cursor))) {
          streak++;
          cursor = cursor.subtract(const Duration(days: 1));
        }
      } else {
        // If today not yet present, check consecutive days starting from yesterday
        DateTime yesterday = todayDate.subtract(const Duration(days: 1));
        while (activeDates.contains(formatDate(yesterday))) {
          streak++;
          yesterday = yesterday.subtract(const Duration(days: 1));
        }
      }

      return streak > 0 ? streak : 1;
    } catch (e) {
      return 1;
    }
  }
}
