import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen for displaying saved, custom, and AI-generated Summaries
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
            onPressed: () => _showCreateOptionsModal(),
            tooltip: 'Add Summary',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptionsModal(),
        backgroundColor: AppColors.primaryViolet,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _showCreateOptionsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEF3C7),
                child: Icon(Icons.edit_note_rounded, color: Color(0xD9D97706)),
              ),
              title: const Text('Create Custom Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Write your own summary and key takeaways'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, AppRouter.createSummary);
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF3E8FF),
                child: Icon(Icons.auto_awesome, color: AppColors.primaryViolet),
              ),
              title: const Text('Generate with AI', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Summarize YouTube links or articles instantly'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, AppRouter.aiAssistant);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCustomSummaryDialog() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController(text: 'General');
    final sourceUrlController = TextEditingController();
    final overviewController = TextEditingController();
    final bulletsController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create Custom Summary'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g. Clean Code Principles',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category / Source Type',
                  hintText: 'e.g. YouTube, Book, Article',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: sourceUrlController,
                decoration: const InputDecoration(
                  labelText: 'Source Link / URL (Optional)',
                  hintText: 'e.g. https://example.com',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: overviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Overview / Summary Text *',
                  hintText: 'Write a brief summary of the main points...',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bulletsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Key Takeaways (Separated by new lines or commas)',
                  hintText: 'Point 1\nPoint 2\nPoint 3',
                ),
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
              backgroundColor: AppColors.primaryViolet,
            ),
            onPressed: () {
              final titleText = titleController.text.trim();
              final overviewText = overviewController.text.trim();
              if (titleText.isNotEmpty && overviewText.isNotEmpty) {
                final rawBullets = bulletsController.text;
                final bulletList = rawBullets.contains('\n')
                    ? rawBullets.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
                    : rawBullets.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

                final summary = SummaryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleText,
                  sourceCategory: categoryController.text.trim().isNotEmpty
                      ? categoryController.text.trim()
                      : 'General',
                  sourceUrl: sourceUrlController.text.trim(),
                  overview: overviewText,
                  bulletPoints: bulletList,
                  createdAt: DateTime.now(),
                );

                _repository.addSummary(summary);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Summary', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
            'Create your own custom summary or use Brain AI to summarize URLs',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.createSummary),
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text('Create Summary'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryViolet,
                    side: const BorderSide(color: AppColors.primaryViolet),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.aiAssistant);
                },
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('AI Summarize'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryViolet,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
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
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _repository.deleteSummary(item.id),
                tooltip: 'Delete Summary',
              ),
            ],
          ),
          const SizedBox(height: 6),

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
          if (item.bulletPoints.isNotEmpty) ...[
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
