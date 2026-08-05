import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen #8: All Notes List
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Pinned', 'Folders'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
          onPressed: () {},
        ),
        title: const Text(
          'All Notes',
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
              Icons.notifications_none_rounded,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              // Search Input Bar
              _buildSearchBar(),
              const SizedBox(height: 16),

              // Filter Chips Row
              _buildFilterChips(),
              const SizedBox(height: 20),

              // Notes List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildNoteCard(
                      title: 'Project Ideas',
                      subtitle: 'Today, 9:30 AM',
                      iconBg: AppColors.noteOrangeBg,
                      iconColor: AppColors.noteOrangeIcon,
                      icon: Icons.edit_note_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.noteEditor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildNoteCard(
                      title: 'Study Plan',
                      subtitle: 'Today, 8:15 AM',
                      iconBg: AppColors.notePurpleBg,
                      iconColor: AppColors.notePurpleIcon,
                      icon: Icons.article_outlined,
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.noteEditor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildNoteCard(
                      title: 'Book Summary',
                      subtitle: 'Yesterday, 6:45 PM',
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      icon: Icons.menu_book_outlined,
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.noteEditor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildNoteCard(
                      title: 'Workout Plan',
                      subtitle: 'Yesterday, 5:20 PM',
                      iconBg: const Color(0xFFEFF6FF),
                      iconColor: const Color(0xFF3B82F6),
                      icon: Icons.fitness_center_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.noteEditor);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildNoteCard(
                      title: 'My Thoughts',
                      subtitle: '12 May, 10:30 PM',
                      iconBg: const Color(0xFFFDF2F8),
                      iconColor: const Color(0xFFEC4899),
                      icon: Icons.favorite_border_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.noteEditor);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.noteEditor);
        },
        backgroundColor: AppColors.primaryViolet,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSearchBar() {
    return Row(
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
              hintText: 'Search notes...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: List.generate(_filters.length, (index) {
        final isSelected = _selectedFilterIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
                if (_selectedFilterIndex == 2) {
                  Navigator.pushNamed(context, AppRouter.folder);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryViolet : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryViolet
                      : AppColors.borderLight,
                ),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textDarkSecondary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoteCard({
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRouter.aiAssistant);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, AppRouter.tasks);
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, AppRouter.profile);
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
