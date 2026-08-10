import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';
import '../widgets/mind_map_diagram_widget.dart';

/// Screen for displaying saved and AI-generated Mind Maps
class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
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
    final mindMaps = _repository.mindMaps;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_tree_outlined,
            color: Color(0xFF2563EB),
            size: 18,
          ),
        ),
        title: const Text(
          'Mind Maps',
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
        child: mindMaps.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: mindMaps.length,
                itemBuilder: (context, index) {
                  final item = mindMaps[index];
                  return _buildMindMapCard(item);
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
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_tree_rounded,
              size: 48,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Mind Maps Generated Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Generate mind maps automatically from URLs or text using Brain AI',
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
            label: const Text('Generate Mind Map'),
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

  Widget _buildMindMapCard(MindMapItem item) {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (item.sourceUrl.isNotEmpty) ...[
                      const SizedBox(height: 2),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MindMapDiagramWidget(
            centralTopic: item.centralTopic,
            branches: item.branches,
            isInteractive: true,
            height: 280,
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
        currentIndex: 2, // Mind Map index
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRouter.notesList);
          } else if (index == 2) {
            // Already here
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
