import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen #7: Home Dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Greeting + Profile Picture)
              _buildHeader(),
              const SizedBox(height: 20),

              // Search Bar & Bell Icon
              _buildSearchBarRow(),
              const SizedBox(height: 24),

              // Quick Actions Section
              _buildQuickActionsSection(),
              const SizedBox(height: 24),

              // Recent Notes Section
              _buildRecentNotesSection(),
              const SizedBox(height: 24),

              // Upcoming Tasks Section
              _buildUpcomingTasksSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkSecondary,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'Aman',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(width: 6),
                Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
          ],
        ),
        // User Profile Avatar
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.profile),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryViolet.withValues(alpha: 0.1),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Search Bar + Notification Bell
  Widget _buildSearchBarRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: const [
              Icon(
                Icons.search_rounded,
                color: AppColors.textDarkSecondary,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search notes, tasks, files...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textDark,
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // Quick Actions Section
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionItem(
              bgColor: AppColors.quickActionNoteBg,
              iconColor: AppColors.quickActionNoteIcon,
              icon: Icons.edit_document,
              label: 'New Note',
              onTap: () => Navigator.pushNamed(context, AppRouter.noteEditor),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionAiBg,
              iconColor: AppColors.quickActionAiIcon,
              icon: Icons.track_changes_rounded,
              label: 'AI Chat',
              onTap: () => Navigator.pushNamed(context, AppRouter.aiAssistant),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionTaskBg,
              iconColor: AppColors.quickActionTaskIcon,
              icon: Icons.check_box_outlined,
              label: 'New Task',
              onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
            ),
            _buildQuickActionItem(
              bgColor: AppColors.quickActionScanBg,
              iconColor: AppColors.quickActionScanIcon,
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan',
              onTap: () => Navigator.pushNamed(context, AppRouter.scanner),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Notes Section
  Widget _buildRecentNotesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouter.notesList),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryViolet,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildNoteTile(
          iconBg: AppColors.noteOrangeBg,
          iconColor: AppColors.noteOrangeIcon,
          customLetter: 'E',
          title: 'Project Ideas',
          subtitle: 'Today, 9:30 AM',
          onTap: () => Navigator.pushNamed(context, AppRouter.noteEditor),
        ),
        const SizedBox(height: 10),
        _buildNoteTile(
          iconBg: AppColors.notePurpleBg,
          iconColor: AppColors.notePurpleIcon,
          icon: Icons.article_outlined,
          title: 'Study Plan',
          subtitle: 'Today, 8:15 AM',
          onTap: () => Navigator.pushNamed(context, AppRouter.noteEditor),
        ),
        const SizedBox(height: 10),
        _buildNoteTile(
          iconBg: AppColors.notePurpleBg,
          iconColor: AppColors.notePurpleIcon,
          icon: Icons.article_outlined,
          title: 'Book Summary',
          subtitle: 'Yesterday, 6:45 PM',
          onTap: () => Navigator.pushNamed(context, AppRouter.noteEditor),
        ),
      ],
    );
  }

  Widget _buildNoteTile({
    required Color iconBg,
    required Color iconColor,
    IconData? icon,
    String? customLetter,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: customLetter != null
                    ? Text(
                        customLetter,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.bookmark_outline_rounded,
                color: AppColors.textDarkSecondary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Upcoming Tasks Section
  Widget _buildUpcomingTasksSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryViolet,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRouter.tasks),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.taskRedBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.taskRedIcon,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Math Assignment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Today, 11:00 AM',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.textDarkSecondary),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          if (index == 1) {
            Navigator.pushNamed(context, AppRouter.notesList);
          } else if (index == 2) {
            Navigator.pushNamed(context, AppRouter.aiAssistant);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRouter.tasks);
          } else if (index == 4) {
            Navigator.pushNamed(context, AppRouter.profile);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryViolet,
        unselectedItemColor: AppColors.textDarkSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
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
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI',
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
