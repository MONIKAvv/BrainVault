import 'package:brainvault/app/router.dart';
import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── Data ─────────────────────────────────────────────────────────────────────
class _FolderData {
  final String name;
  final int noteCount;
  final Color tint;

  const _FolderData(this.name, this.noteCount, this.tint);
}

class _FolderItem {
  final String title;
  final String subtitle;
  final String section; // 'Notes' | 'Tasks' | 'Files'
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _FolderItem({
    required this.title,
    required this.subtitle,
    required this.section,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────
class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  static const List<_FolderData> _folders = [
    _FolderData('Personal', 24, AppColors.primaryPurple),
    _FolderData('Work', 18, AppColors.info),
    _FolderData('Study', 16, AppColors.warning),
    _FolderData('Ideas', 12, AppColors.success),
    _FolderData('Projects', 8, AppColors.error),
  ];

  // Items inside "Project" folder (simulating a folder drill-down)
  static const List<_FolderItem> _projectItems = [
    _FolderItem(
      title: 'Project Ideas',
      subtitle: 'Today, 9:30 AM',
      section: 'Notes',
      icon: Icons.edit_note_rounded,
      iconBg: AppColors.noteOrangeBg,
      iconColor: AppColors.noteOrangeIcon,
    ),
    _FolderItem(
      title: 'Project Presentation',
      subtitle: 'Yesterday, 2:30 PM',
      section: 'Notes',
      icon: Icons.article_outlined,
      iconBg: AppColors.notePurpleBg,
      iconColor: AppColors.notePurpleIcon,
    ),
    _FolderItem(
      title: 'Project Presentation',
      subtitle: 'Today, 10:00 AM',
      section: 'Tasks',
      icon: Icons.check_box_outlined,
      iconBg: AppColors.taskRedBg,
      iconColor: AppColors.taskRedIcon,
    ),
    _FolderItem(
      title: 'Project Brief.pdf',
      subtitle: '2.4 MB · PDF Document',
      section: 'Files',
      icon: Icons.picture_as_pdf_outlined,
      iconBg: Color(0xFFFEF2F2),
      iconColor: Color(0xFFEF4444),
    ),
    _FolderItem(
      title: 'Design Assets.zip',
      subtitle: '14.6 MB · Archive',
      section: 'Files',
      icon: Icons.folder_zip_outlined,
      iconBg: AppColors.quickActionAiBg,
      iconColor: AppColors.quickActionAiIcon,
    ),
  ];

  String? _openFolder;

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'New Folder',
          style: AppTextStyles.h3(
              color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Folder name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Folder "${controller.text.trim()}" created'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

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

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: _openFolder != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => setState(() => _openFolder = null),
              )
            : IconButton(
                icon: const Icon(Icons.menu_outlined),
                onPressed: () {},
              ),
        title: Text(
          _openFolder == null ? 'Folders' : _openFolder!,
          style: AppTextStyles.h3(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateFolderDialog,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: _openFolder == null
          ? _buildFolderList(surface, border, textSecondary, theme)
          : _buildFolderContents(surface, border, textSecondary, theme),
    );
  }

  // ── Folder list view ──────────────────────────────────────────────────────
  Widget _buildFolderList(
      Color surface, Color border, Color textSecondary, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      itemCount: _folders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return _FolderTile(
          folder: folder,
          surface: surface,
          border: border,
          textSecondary: textSecondary,
          theme: theme,
          onTap: () => setState(() => _openFolder = folder.name),
        );
      },
    );
  }

  // ── Folder contents (Notes / Tasks / Files) ───────────────────────────────
  Widget _buildFolderContents(
      Color surface, Color border, Color textSecondary, ThemeData theme) {
    final grouped = <String, List<_FolderItem>>{};
    for (final item in _projectItems) {
      grouped.putIfAbsent(item.section, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
      physics: const BouncingScrollPhysics(),
      children: grouped.entries.expand((entry) {
        return [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            child: Text(
              entry.key,
              style: AppTextStyles.subtitle(
                  color: theme.textTheme.bodyLarge?.color),
            ),
          ),
          ...entry.value.map((item) =>
              _ItemTile(item: item, surface: surface, border: border, textSecondary: textSecondary)),
        ];
      }).toList(),
    );
  }
}

// ── Folder tile ───────────────────────────────────────────────────────────────
class _FolderTile extends StatelessWidget {
  final _FolderData folder;
  final Color surface;
  final Color border;
  final Color textSecondary;
  final ThemeData theme;
  final VoidCallback onTap;

  const _FolderTile({
    required this.folder,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: folder.tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.folder_rounded, color: folder.tint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: AppTextStyles.subtitle(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${folder.noteCount} notes',
                      style: AppTextStyles.caption(color: textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Item tile ─────────────────────────────────────────────────────────────────
class _ItemTile extends StatelessWidget {
  final _FolderItem item;
  final Color surface;
  final Color border;
  final Color textSecondary;

  const _ItemTile({
    required this.item,
    required this.surface,
    required this.border,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.subtitle(
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 2),
                    Text(item.subtitle,
                        style: AppTextStyles.caption(color: textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
