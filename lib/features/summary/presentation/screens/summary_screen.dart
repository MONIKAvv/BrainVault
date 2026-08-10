import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen for displaying saved and AI-generated Summaries
class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
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
    final summaries = _repository.summaries;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFFEF3C7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.summarize_outlined,
            color: Color(0xD9D97706),
            size: 18,
          ),
        ),
        title: const Text(
          'Summaries',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.textDark,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.aiAssistant);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: summaries.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: summaries.length,
                itemBuilder: (context, index) {
                  final item = summaries[index];
                  return _buildSummaryCard(item);
                },
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.summarize_rounded,
              size: 48,
              color: Color(0xD9D97706),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Summaries Saved Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Paste YouTube links or article URLs in Brain AI to generate instant summaries',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.aiAssistant);
            },
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Summarize Content'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SummaryItem item) {
    final isYouTube = item.sourceCategory.toLowerCase().contains('youtube');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isYouTube
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isYouTube
                          ? Icons.play_circle_fill_rounded
                          : Icons.language_rounded,
                      color: isYouTube
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF0284C7),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.sourceCategory,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isYouTube
                            ? const Color(0xFFB91C1C)
                            : const Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.bookmark_added_rounded,
                color: AppColors.primaryViolet,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            item.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (item.sourceUrl.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.sourceUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF3B82F6),
              ),
            ),
          ],
          const SizedBox(height: 12),

          Text(
            item.overview,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDarkSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Key Takeaways:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),

          ...item.bulletPoints.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryViolet)),
                  Expanded(
                    child: Text(
                      bullet,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDark,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: 4, // Summary index
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
            // Already here
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
