import 'package:flutter/material.dart';
import 'package:brainvault/app/router.dart';
import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';

import 'package:brainvault/core/repositories/vault_repository.dart';

// ── Data models ──────────────────────────────────────────────────────────────
class _SearchResult {
  final String title;
  final String subtitle;
  final String category; // 'Notes', 'Tasks', 'Files'
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String route;
  final dynamic objectArg;

  const _SearchResult({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.route,
    this.objectArg,
  });
}

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
  final VaultRepository _repository = VaultRepository.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
    _repository.addListener(_onRepositoryChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }

  void _onRepositoryChanged() {
    if (mounted) setState(() {});
  }

  List<_SearchResult> get _allDynamicResults {
    final results = <_SearchResult>[];

    // Dynamic Notes
    for (final note in _repository.notes) {
      results.add(
        _SearchResult(
          title: note.title,
          subtitle: note.subtitle.isNotEmpty ? note.subtitle : 'Note',
          category: 'Notes',
          icon: note.icon,
          iconBg: note.iconBg,
          iconColor: note.iconColor,
          route: AppRouter.noteEditor,
          objectArg: note,
        ),
      );
    }

    // Dynamic Tasks
    for (final task in _repository.tasks) {
      results.add(
        _SearchResult(
          title: task.title,
          subtitle: task.time,
          category: 'Tasks',
          icon: task.completed ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded,
          iconBg: AppColors.quickActionTaskBg,
          iconColor: task.color,
          route: AppRouter.tasks,
        ),
      );
    }

    return results;
  }

  List<_SearchResult> get _filtered {
    final tab = _tabs[_tabController.index];
    return _allDynamicResults.where((r) {
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
