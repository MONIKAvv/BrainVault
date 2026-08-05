import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen #9: Note Editor ("Project Ideas")
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController(
    text: 'Brain Vault App Ideas',
  );
  final TextEditingController _bodyController = TextEditingController(
    text:
        'This app will help users to capture, organize and grow their ideas effortlessly.',
  );

  // Checklist items state
  final List<Map<String, dynamic>> _checklistItems = [
    {'title': 'AI Note Summary', 'checked': false},
    {'title': 'Voice to Text', 'checked': false},
    {'title': 'Mind Map Generation', 'checked': false},
    {'title': 'Smart Search', 'checked': false},
    {'title': 'Cross Platform Sync', 'checked': false},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Project Ideas',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.unfold_more_rounded,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Text Formatting Toolbar
            _buildFormattingToolbar(),
            const Divider(height: 1, color: AppColors.borderLight),

            // Scrollable Note Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Editable Note Title
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note Title',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Interactive Checklist Items
                    ..._checklistItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item['checked'] = !item['checked'];
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: item['checked']
                                      ? AppColors.primaryViolet
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: item['checked']
                                        ? AppColors.primaryViolet
                                        : AppColors.textDarkSecondary,
                                    width: 1.5,
                                  ),
                                ),
                                child: item['checked']
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 14,
                                color: item['checked']
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textDark,
                                decoration: item['checked']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // Main Text Body Paragraph
                    TextField(
                      controller: _bodyController,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textDark,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing...',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Attached Image Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&q=80&w=800',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.landscape_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Media & Action Bar
            _buildBottomActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Wrap(
      children: [
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Text(
                  'B',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Text(
                  'I',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Text(
                  'U',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(
                  Icons.strikethrough_s_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_list_bulleted_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_list_numbered_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(
                  Icons.checklist_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.image_outlined,
              color: AppColors.textDarkSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.textDarkSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.mic_none_rounded,
              color: AppColors.textDarkSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.attach_file_rounded,
              color: AppColors.textDarkSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
          const Spacer(),
          // Done Save Button (Blue/Violet rounded box with checkmark)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note Saved Successfully!'),
                  duration: Duration(seconds: 1),
                ),
              );
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF5B41F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
