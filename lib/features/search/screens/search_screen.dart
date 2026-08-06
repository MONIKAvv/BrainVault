import 'package:flutter/material.dart';
import 'package:brainvault/app/router.dart';
import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';

// ── Data models ──────────────────────────────────────────────────────────────
class _SearchResult {
  final String title;
  final String subtitle;
  final String category; // 'Notes', 'Tasks', 'Files'
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String route;

  const _SearchResult({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.route,
  });
}

const _allResults = <_SearchResult>[
  // Notes
  _SearchResult(
    title: 'Project Ideas',
    subtitle: 'Today, 9:30 AM',
    category: 'Notes',
    icon: Icons.edit_note_rounded,
    iconBg: AppColors.noteOrangeBg,
    iconColor: AppColors.noteOrangeIcon,
    route: AppRouter.noteEditor,
  ),
  _SearchResult(
    title: 'Project Presentation',
    subtitle: 'Yesterday, 2:30 PM',
    category: 'Notes',
    icon: Icons.article_outlined,
    iconBg: AppColors.notePurpleBg,
    iconColor: AppColors.notePurpleIcon,
    route: AppRouter.noteEditor,
  ),
  _SearchResult(
    title: 'Study Plan',
    subtitle: 'Yesterday, 8:15 AM',
    category: 'Notes',
    icon: Icons.menu_book_outlined,
    iconBg: Color(0xFFECFDF5),
    iconColor: Color(0xFF10B981),
    route: AppRouter.noteEditor,
  ),
  // Tasks
  _SearchResult(
    title: 'Project Presentation',
    subtitle: 'Today, 10:00 AM',
    category: 'Tasks',
    icon: Icons.check_box_outlined,
    iconBg: AppColors.taskRedBg,
    iconColor: AppColors.taskRedIcon,
    route: AppRouter.tasks,
  ),
  _SearchResult(
    title: 'Math Assignment',
    subtitle: 'Today, 11:00 AM',
    category: 'Tasks',
    icon: Icons.assignment_outlined,
    iconBg: AppColors.quickActionTaskBg,
    iconColor: AppColors.quickActionTaskIcon,
    route: AppRouter.tasks,
  ),
  // Files
  _SearchResult(
    title: 'Project Brief.pdf',
    subtitle: '2.4 MB · PDF Document',
    category: 'Files',
    icon: Icons.picture_as_pdf_outlined,
    iconBg: Color(0xFFFEF2F2),
    iconColor: Color(0xFFEF4444),
    route: AppRouter.folder,
  ),
  _SearchResult(
    title: 'Design Assets.zip',
    subtitle: '14.6 MB · Archive',
    category: 'Files',
    icon: Icons.folder_zip_outlined,
    iconBg: AppColors.quickActionAiBg,
    iconColor: AppColors.quickActionAiIcon,
    route: AppRouter.folder,
  ),
];

// ── Screen ───────────────────────────────────────────────────────────────────
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final List<String> _tabs = ['All', 'Notes', 'Tasks', 'Files'];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<_SearchResult> get _filtered {
    final tab = _tabs[_tabController.index];
    return _allResults.where((r) {
      final matchesTab = tab == 'All' || r.category == tab;
      final matchesQuery =
          _query.isEmpty || r.title.toLowerCase().contains(_query);
      return matchesTab && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Search',
          style: AppTextStyles.h3(color: theme.textTheme.titleLarge?.color),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search_rounded, color: textSecondary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: AppTextStyles.body(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search notes, tasks, files…',
                        hintStyle: AppTextStyles.body(color: textSecondary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close, color: textSecondary, size: 18),
                      onPressed: () => _searchController.clear(),
                      splashRadius: 18,
                    ),
                ],
              ),
            ),
          ),

          // ── Filter tabs ─────────────────────────────────────────────────────
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: AppTextStyles.subtitle(
                color: AppColors.primaryPurple,
              ),
              unselectedLabelStyle: AppTextStyles.subtitle(
                color: textSecondary,
              ),
              labelColor: AppColors.primaryPurple,
              unselectedLabelColor: textSecondary,
              // indicator: UnderlineTabIndicator(
              //   borderSide: const BorderSide(
              //     color: AppColors.primaryPurple,
              //     width: 2,
              //   ),
              //   borderRadius: BorderRadius.circular(2),
              // ),
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
              onTap: (_) => setState(() {}),
            ),
          ),
          Divider(height: 1, color: border),
          const SizedBox(height: 8),

          // ── Results ─────────────────────────────────────────────────────────
          Expanded(
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                final results = _filtered;
                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 56,
                          color: textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _query.isEmpty
                              ? 'Start typing to search…'
                              : 'No results for "$_query"',
                          style: AppTextStyles.body(color: textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                // Group by category
                final grouped = <String, List<_SearchResult>>{};
                for (final r in results) {
                  grouped.putIfAbsent(r.category, () => []).add(r);
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  children: grouped.entries.expand((entry) {
                    return [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 10),
                        child: Text(
                          entry.key,
                          style: AppTextStyles.subtitle(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      ...entry.value.map(
                        (r) => _ResultTile(
                          result: r,
                          surface: surface,
                          border: border,
                          textSecondary: textSecondary,
                        ),
                      ),
                    ];
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Result tile ──────────────────────────────────────────────────────────────
class _ResultTile extends StatelessWidget {
  final _SearchResult result;
  final Color surface;
  final Color border;
  final Color textSecondary;

  const _ResultTile({
    required this.result,
    required this.surface,
    required this.border,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, result.route),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: result.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(result.icon, color: result.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: AppTextStyles.subtitle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.subtitle,
                      style: AppTextStyles.caption(color: textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  result.category,
                  style: AppTextStyles.caption(color: AppColors.primaryPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
