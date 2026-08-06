import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';
import 'package:brainvault/shared/theme_provider.dart';
import 'package:flutter/material.dart';

// ── Settings item model ───────────────────────────────────────────────────────
class _SettingsItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? trailingText;
  final Widget Function(BuildContext)? pageBuilder;

  const _SettingsItem(
    this.icon,
    this.label, {
    required this.iconBg,
    required this.iconColor,
    this.trailingText,
    this.pageBuilder,
  });
}

// ── Main Settings Screen ──────────────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final List<_SettingsItem> items = [
      _SettingsItem(
        Icons.person_outline,
        'Account',
        iconBg: const Color(0xFFF4EFFC),
        iconColor: AppColors.primaryPurple,
        pageBuilder: (_) => const _AccountScreen(),
      ),
      _SettingsItem(
        Icons.palette_outlined,
        'Appearance',
        iconBg: const Color(0xFFEFF6FF),
        iconColor: AppColors.info,
        pageBuilder: (_) => const _AppearanceScreen(),
      ),
      _SettingsItem(
        Icons.notifications_none,
        'Notifications',
        iconBg: const Color(0xFFFFF7ED),
        iconColor: AppColors.warning,
        pageBuilder: (_) => const _NotificationsScreen(),
      ),
      _SettingsItem(
        Icons.language_outlined,
        'Language',
        iconBg: const Color(0xFFECFDF5),
        iconColor: AppColors.success,
        trailingText: 'English',
        pageBuilder: (_) => const _LanguageScreen(),
      ),
      _SettingsItem(
        Icons.privacy_tip_outlined,
        'Privacy & Security',
        iconBg: const Color(0xFFFEF2F2),
        iconColor: AppColors.error,
        pageBuilder: (_) => const _PrivacyScreen(),
      ),
      _SettingsItem(
        Icons.storage_outlined,
        'Data & Storage',
        iconBg: const Color(0xFFF4EFFC),
        iconColor: AppColors.secondaryPurple,
        pageBuilder: (_) => const _DataStorageScreen(),
      ),
      _SettingsItem(
        Icons.info_outline,
        'About BrainVault',
        iconBg: const Color(0xFFF1F2F6),
        iconColor: AppColors.slateGray,
        pageBuilder: (_) => const _AboutScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.h3(
              color: theme.textTheme.titleLarge?.color),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          // Profile summary card
          _ProfileCard(surface: surface, border: border, textSecondary: textSecondary),
          const SizedBox(height: 20),

          // Section label
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('General',
                style: AppTextStyles.caption(color: textSecondary)),
          ),

          // Settings items
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SettingsTile(
                item: item,
                surface: surface,
                border: border,
                textSecondary: textSecondary,
                theme: theme,
              ),
            );
          }),

          const SizedBox(height: 16),

          // Sign out button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text('Sign Out', style: AppTextStyles.button(color: AppColors.error)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Text('Sign Out',
                        style: AppTextStyles.h3(
                            color: theme.textTheme.titleLarge?.color)),
                    content: Text(
                      'Are you sure you want to sign out?',
                      style: AppTextStyles.body(color: textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (_) => false);
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile card ─────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final Color surface;
  final Color border;
  final Color textSecondary;

  const _ProfileCard(
      {required this.surface, required this.border, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPurple.withValues(alpha: 0.12),
              border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.3),
                  width: 2),
            ),
            child: const Center(
              child: Text('A',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aman',
                    style: AppTextStyles.subtitle(
                        color:
                            Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(height: 2),
                Text('aman@brainvault.app',
                    style: AppTextStyles.caption(color: textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: textSecondary),
        ],
      ),
    );
  }
}

// ── Settings tile ─────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final _SettingsItem item;
  final Color surface;
  final Color border;
  final Color textSecondary;
  final ThemeData theme;

  const _SettingsTile({
    required this.item,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: item.iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: item.iconColor, size: 20),
        ),
        title: Text(
          item.label,
          style:
              AppTextStyles.subtitle(color: theme.textTheme.bodyLarge?.color),
        ),
        trailing: item.trailingText != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.trailingText!,
                    style: AppTextStyles.bodySmall(color: textSecondary),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: textSecondary),
                ],
              )
            : Icon(Icons.chevron_right, color: textSecondary),
        onTap: item.pageBuilder != null
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: item.pageBuilder!),
                )
            : null,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Sub-screens
// ═══════════════════════════════════════════════════════════════════════════════

// ── Account Screen ────────────────────────────────────────────────────────────
class _AccountScreen extends StatefulWidget {
  const _AccountScreen();

  @override
  State<_AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<_AccountScreen> {
  final _nameCtrl = TextEditingController(text: 'Aman');
  final _emailCtrl = TextEditingController(text: 'aman@brainvault.app');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Account',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple.withValues(alpha: 0.12),
                      border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.4),
                          width: 2.5),
                    ),
                    child: const Center(
                      child: Text('A',
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Fields
            _FieldLabel('Display Name', textSecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Your name'),
            ),
            const SizedBox(height: 16),

            _FieldLabel('Email Address', textSecondary),
            const SizedBox(height: 6),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Your email'),
            ),
            const SizedBox(height: 16),

            _FieldLabel('Password', textSecondary),
            const SizedBox(height: 6),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(hintText: '••••••••'),
            ),
            const SizedBox(height: 32),

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated!')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Save Changes',
                    style: AppTextStyles.button()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Appearance Screen (dark mode toggle) ─────────────────────────────────────
class _AppearanceScreen extends StatefulWidget {
  const _AppearanceScreen();

  @override
  State<_AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<_AppearanceScreen> {
  final _tp = ThemeProvider.instance;

  final List<String> _accentOptions = [
    'Purple', 'Blue', 'Green', 'Orange', 'Red', 'Slate',
  ];
  final List<Color> _accentColors = [
    AppColors.primaryPurple,
    AppColors.info,
    AppColors.success,
    AppColors.warning,
    AppColors.error,
    AppColors.slateGray,
  ];
  int _selectedAccent = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Appearance',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Dark mode toggle
          _SectionCard(
            surface: surface,
            border: border,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F1A).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.dark_mode_outlined,
                    color: AppColors.primaryPurple),
              ),
              title: Text('Dark Mode',
                  style: AppTextStyles.subtitle(
                      color: theme.textTheme.bodyLarge?.color)),
              subtitle: Text(
                isDark ? 'On' : 'Off',
                style: AppTextStyles.caption(color: textSecondary),
              ),
              trailing: Switch(
                value: isDark,
                activeThumbColor: AppColors.primaryPurple,
                onChanged: (_) {
                  _tp.toggleTheme();
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text('Theme Mode', style: AppTextStyles.caption(color: textSecondary)),
          const SizedBox(height: 10),
          _SectionCard(
            surface: surface,
            border: border,
            child: Column(
              children: [
                _ThemeModeOption(
                  label: 'Light',
                  icon: Icons.light_mode_outlined,
                  selected: _tp.themeMode == ThemeMode.light,
                  surface: surface,
                  onTap: () {
                    _tp.setThemeMode(ThemeMode.light);
                    setState(() {});
                  },
                ),
                Divider(color: border, height: 1),
                _ThemeModeOption(
                  label: 'Dark',
                  icon: Icons.dark_mode_outlined,
                  selected: _tp.themeMode == ThemeMode.dark,
                  surface: surface,
                  onTap: () {
                    _tp.setThemeMode(ThemeMode.dark);
                    setState(() {});
                  },
                ),
                Divider(color: border, height: 1),
                _ThemeModeOption(
                  label: 'System Default',
                  icon: Icons.phone_android_outlined,
                  selected: _tp.themeMode == ThemeMode.system,
                  surface: surface,
                  onTap: () {
                    _tp.setThemeMode(ThemeMode.system);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Accent Color', style: AppTextStyles.caption(color: textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_accentOptions.length, (i) {
              final selected = _selectedAccent == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedAccent = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _accentColors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? _accentColors[i]
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: _accentColors[i].withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 24)
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Notifications Screen ──────────────────────────────────────────────────────
class _NotificationsScreen extends StatefulWidget {
  const _NotificationsScreen();

  @override
  State<_NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<_NotificationsScreen> {
  bool _reminders = true;
  bool _taskDue = true;
  bool _dailySummary = false;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SwitchTile(
            label: 'Reminders',
            subtitle: 'Get notified for your reminders',
            value: _reminders,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _reminders = v),
          ),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'Task Due Alerts',
            subtitle: 'Notify when tasks are due',
            value: _taskDue,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _taskDue = v),
          ),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'Daily Summary',
            subtitle: 'Morning digest of your day',
            value: _dailySummary,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _dailySummary = v),
          ),
          const SizedBox(height: 20),
          Text('Sound & Vibration',
              style: AppTextStyles.caption(color: textSecondary)),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'Sound',
            subtitle: 'Play notification sounds',
            value: _sound,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _sound = v),
          ),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'Vibration',
            subtitle: 'Vibrate on notification',
            value: _vibration,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _vibration = v),
          ),
        ],
      ),
    );
  }
}

// ── Language Screen ────────────────────────────────────────────────────────────
class _LanguageScreen extends StatefulWidget {
  const _LanguageScreen();

  @override
  State<_LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<_LanguageScreen> {
  String _selected = 'English';
  final List<String> _languages = [
    'English', 'Hindi', 'Spanish', 'French', 'German',
    'Arabic', 'Chinese', 'Japanese', 'Korean', 'Portuguese',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Language',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _languages.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = _selected == lang;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _selected = lang),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple.withValues(alpha: 0.1)
                    : surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPurple.withValues(alpha: 0.5)
                      : border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(lang,
                        style: AppTextStyles.subtitle(
                            color: isSelected
                                ? AppColors.primaryPurple
                                : theme.textTheme.bodyLarge?.color)),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.primaryPurple, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Privacy & Security Screen ─────────────────────────────────────────────────
class _PrivacyScreen extends StatefulWidget {
  const _PrivacyScreen();

  @override
  State<_PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<_PrivacyScreen> {
  bool _biometric = false;
  bool _appLock = false;
  bool _hideContent = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Privacy & Security',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SwitchTile(
            label: 'Biometric Lock',
            subtitle: 'Use fingerprint or face ID',
            value: _biometric,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _biometric = v),
          ),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'App Lock',
            subtitle: 'Require PIN to open app',
            value: _appLock,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _appLock = v),
          ),
          const SizedBox(height: 10),
          _SwitchTile(
            label: 'Hide Content in Preview',
            subtitle: 'Blur content in app switcher',
            value: _hideContent,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onChanged: (v) => setState(() => _hideContent = v),
          ),
          const SizedBox(height: 24),
          _ActionTile(
            label: 'Change PIN',
            icon: Icons.lock_outline,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change PIN coming soon')),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionTile(
            label: 'Delete Account',
            icon: Icons.delete_forever_outlined,
            surface: surface,
            border: border,
            textSecondary: AppColors.error,
            theme: theme,
            onTap: () {},
            destructive: true,
          ),
        ],
      ),
    );
  }
}

// ── Data & Storage Screen ─────────────────────────────────────────────────────
class _DataStorageScreen extends StatelessWidget {
  const _DataStorageScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Data & Storage',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Storage bar card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Storage Used',
                    style: AppTextStyles.subtitle(
                        color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 6),
                Text('2.4 GB of 10 GB used',
                    style: AppTextStyles.caption(color: textSecondary)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.24,
                    minHeight: 10,
                    backgroundColor: border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primaryPurple),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _LegendDot(AppColors.primaryPurple, 'Notes'),
                    const SizedBox(width: 12),
                    _LegendDot(AppColors.info, 'Files'),
                    const SizedBox(width: 12),
                    _LegendDot(AppColors.warning, 'Voice'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ActionTile(
            label: 'Export All Data',
            icon: Icons.download_outlined,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export started…')),
            ),
          ),
          const SizedBox(height: 10),
          _ActionTile(
            label: 'Clear Cache',
            icon: Icons.cleaning_services_outlined,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cache cleared!')),
            ),
          ),
          const SizedBox(height: 10),
          _ActionTile(
            label: 'Backup to Cloud',
            icon: Icons.cloud_upload_outlined,
            surface: surface,
            border: border,
            textSecondary: textSecondary,
            theme: theme,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup in progress…')),
            ),
          ),
        ],
      ),
    );
  }
}

// ── About Screen ──────────────────────────────────────────────────────────────
class _AboutScreen extends StatelessWidget {
  const _AboutScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('About',
            style: AppTextStyles.h3(
                color: theme.textTheme.titleLarge?.color)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.psychology_rounded,
                  color: Colors.white, size: 44),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('BrainVault',
                style: AppTextStyles.h2(
                    color: theme.textTheme.titleLarge?.color)),
          ),
          Center(
            child: Text('Version 1.0.0',
                style: AppTextStyles.caption(color: textSecondary)),
          ),
          const SizedBox(height: 28),
          ...[
            'Terms of Service',
            'Privacy Policy',
            'Open Source Licenses',
            'Rate BrainVault',
            'Follow on Twitter',
          ].map(
            (label) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActionTile(
                label: label,
                icon: Icons.chevron_right,
                surface: surface,
                border: border,
                textSecondary: textSecondary,
                theme: theme,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Shared sub-screen widgets
// ═══════════════════════════════════════════════════════════════════════════════

class _FieldLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _FieldLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.caption(color: color));
  }
}

class _SectionCard extends StatelessWidget {
  final Color surface;
  final Color border;
  final Widget child;

  const _SectionCard(
      {required this.surface, required this.border, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color surface;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.surface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                color: selected
                    ? AppColors.primaryPurple
                    : Theme.of(context).iconTheme.color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.subtitle(
                    color: selected
                        ? AppColors.primaryPurple
                        : Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryPurple, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final Color surface;
  final Color border;
  final Color textSecondary;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label,
            style: AppTextStyles.subtitle(
                color: theme.textTheme.bodyLarge?.color)),
        subtitle: Text(subtitle,
            style: AppTextStyles.caption(color: textSecondary)),
        trailing: Switch(
          value: value,
          activeThumbColor: AppColors.primaryPurple,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color surface;
  final Color border;
  final Color textSecondary;
  final ThemeData theme;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionTile({
    required this.label,
    required this.icon,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.theme,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14),
        title: Text(
          label,
          style: AppTextStyles.subtitle(
              color: destructive
                  ? AppColors.error
                  : theme.textTheme.bodyLarge?.color),
        ),
        trailing: Icon(
          icon,
          color: destructive ? AppColors.error : textSecondary,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
