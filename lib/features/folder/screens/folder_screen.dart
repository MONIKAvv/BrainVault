import 'package:brainvault/app/router.dart';
import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';
import 'package:brainvault/core/repositories/vault_repository.dart';
import 'package:flutter/material.dart';

// ── Folder Item for display inside an opened folder ──────────────────────────
class _FolderItem {
  final String id;
  final String title;
  final String subtitle;
  final String section; // 'Notes' | 'Tasks'
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final dynamic rawItem;

  const _FolderItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.section,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.rawItem,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────
class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  final VaultRepository _repository = VaultRepository.instance;
  String? _openFolderName;

  final List<Color> _palette = const [
    AppColors.primaryPurple,
    Color(0xFF2563EB), // Blue
    Color(0xFF059669), // Emerald
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red / Rose
    Color(0xFF0891B2), // Cyan
    Color(0xFF7C3AED), // Violet
    Color(0xFF4F46E5), // Indigo
    Color(0xFF0D9488), // Teal
    Color(0xFFEA580C), // Orange
  ];

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

  int _getFolderCount(String folderName) {
    final noteCount =
        _repository.notes.where((n) => n.folderName == folderName).length;
    final taskCount =
        _repository.tasks.where((t) => t.folderName == folderName).length;
    return noteCount + taskCount;
  }

  List<_FolderItem> _getItemsForFolder(String folderName) {
    final items = <_FolderItem>[];
    for (final note
        in _repository.notes.where((n) => n.folderName == folderName)) {
      items.add(
        _FolderItem(
          id: note.id,
          title: note.title,
          subtitle: note.subtitle.isNotEmpty ? note.subtitle : 'Note',
          section: 'Notes',
          icon: note.icon,
          iconBg: note.iconBg,
          iconColor: note.iconColor,
          rawItem: note,
        ),
      );
    }
    for (final task
        in _repository.tasks.where((t) => t.folderName == folderName)) {
      items.add(
        _FolderItem(
          id: task.id,
          title: task.title,
          subtitle: task.time,
          section: 'Tasks',
          icon: task.completed
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          iconBg: task.completed
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.taskRedBg,
          iconColor: task.completed ? AppColors.success : task.color,
          rawItem: task,
        ),
      );
    }
    return items;
  }

  void _showCreateFolderDialog({FolderModel? folderToEdit}) {
    final controller =
        TextEditingController(text: folderToEdit?.name ?? '');
    Color selectedColor = folderToEdit?.color ?? _palette[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            title: Text(
              folderToEdit == null ? 'New Folder' : 'Edit Folder',
              style: AppTextStyles.h3(
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Folder name',
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBackground
                          : const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Choose Color',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _palette.map((color) {
                      final isSelected = selectedColor.toARGB32() == color.toARGB32();
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 18)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isEmpty) return;

                  if (folderToEdit != null) {
                    final updated = folderToEdit.copyWith(
                      name: name,
                      color: selectedColor,
                    );
                    _repository.saveFolder(updated);
                    // Update any notes/tasks that had previous name if name changed
                    if (folderToEdit.name != name) {
                      for (final note in _repository.notes
                          .where((n) => n.folderName == folderToEdit.name)) {
                        _repository.moveNoteToFolder(note.id, name);
                      }
                      for (final task in _repository.tasks
                          .where((t) => t.folderName == folderToEdit.name)) {
                        _repository.moveTaskToFolder(task.id, name);
                      }
                    }
                  } else {
                    final newFolder = FolderModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      color: selectedColor,
                      createdAt: DateTime.now(),
                    );
                    _repository.saveFolder(newFolder);
                  }

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        folderToEdit == null
                            ? 'Folder "$name" saved to Cloud!'
                            : 'Folder "$name" updated!',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(folderToEdit == null ? 'Create' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteFolder(FolderModel folder) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Folder'),
        content: Text(
          'Are you sure you want to delete "${folder.name}"? Notes and tasks inside will not be deleted, but removed from this folder.',
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
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (_openFolderName == folder.name) {
                setState(() => _openFolderName = null);
              }
              _repository.deleteFolder(folder.id, folderName: folder.name);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Folder "${folder.name}" deleted'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
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
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final folders = _repository.folders;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: _openFolderName != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => setState(() => _openFolderName = null),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.maybePop(context),
              ),
        title: Text(
          _openFolderName == null ? 'Folders' : _openFolderName!,
          style: AppTextStyles.h3(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRouter.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        onPressed: () => _showCreateFolderDialog(),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: _openFolderName == null
          ? (folders.isEmpty
              ? _buildEmptyState(surface, border, textSecondary)
              : _buildFolderList(
                  folders, surface, border, textSecondary, theme))
          : _buildFolderContents(
              _openFolderName!, surface, border, textSecondary, theme),
    );
  }

  Widget _buildEmptyState(Color surface, Color border, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_special_rounded,
                size: 40,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Folders Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create custom folders to organize your notes and tasks. Everything syncs with Firebase automatically!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _showCreateFolderDialog(),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Create Folder',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Folder list view ──────────────────────────────────────────────────────
  Widget _buildFolderList(
    List<FolderModel> folders,
    Color surface,
    Color border,
    Color textSecondary,
    ThemeData theme,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      itemCount: folders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final folder = folders[index];
        final count = _getFolderCount(folder.name);
        return _FolderTile(
          folder: folder,
          count: count,
          surface: surface,
          border: border,
          textSecondary: textSecondary,
          theme: theme,
          onTap: () => setState(() => _openFolderName = folder.name),
          onEdit: () => _showCreateFolderDialog(folderToEdit: folder),
          onDelete: () => _confirmDeleteFolder(folder),
        );
      },
    );
  }

  // ── Folder contents (Notes / Tasks) ───────────────────────────────
  Widget _buildFolderContents(
    String folderName,
    Color surface,
    Color border,
    Color textSecondary,
    ThemeData theme,
  ) {
    final folderItems = _getItemsForFolder(folderName);
    if (folderItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open_rounded,
                size: 48, color: AppColors.textDarkSecondary),
            const SizedBox(height: 12),
            Text(
              'No items in "$folderName"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Long press any note or task to move it here!',
              style:
                  TextStyle(fontSize: 13, color: AppColors.textDarkSecondary),
            ),
          ],
        ),
      );
    }

    final grouped = <String, List<_FolderItem>>{};
    for (final item in folderItems) {
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
          ...entry.value.map(
            (item) => _ItemTile(
              item: item,
              surface: surface,
              border: border,
              textSecondary: textSecondary,
              onRemoveFromFolder: () {
                if (item.section == 'Notes') {
                  _repository.moveNoteToFolder(item.id, null);
                } else {
                  _repository.moveTaskToFolder(item.id, null);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${item.title}" from "$folderName"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ];
      }).toList(),
    );
  }
}

// ── Folder tile ───────────────────────────────────────────────────────────────
class _FolderTile extends StatelessWidget {
  final FolderModel folder;
  final int count;
  final Color surface;
  final Color border;
  final Color textSecondary;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FolderTile({
    required this.folder,
    required this.count,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.theme,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
                  color: folder.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.folder_rounded, color: folder.color),
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
                      '$count items',
                      style: AppTextStyles.caption(color: textSecondary),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: textSecondary, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (val) {
                  if (val == 'edit') onEdit();
                  if (val == 'delete') onDelete();
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 18, color: AppColors.error),
                        SizedBox(width: 10),
                        Text('Delete', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
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
  final VoidCallback onRemoveFromFolder;

  const _ItemTile({
    required this.item,
    required this.surface,
    required this.border,
    required this.textSecondary,
    required this.onRemoveFromFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: textSecondary, size: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (val) {
                if (val == 'remove') {
                  onRemoveFromFolder();
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.folder_off_outlined,
                          size: 18, color: AppColors.error),
                      SizedBox(width: 10),
                      Text('Remove from Folder',
                          style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
