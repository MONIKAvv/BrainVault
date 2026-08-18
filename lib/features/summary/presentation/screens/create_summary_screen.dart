import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Full screen for creating a new Custom Summary with clean, borderless, infinite writing space
class CreateSummaryScreen extends StatefulWidget {
  const CreateSummaryScreen({super.key});

  @override
  State<CreateSummaryScreen> createState() => _CreateSummaryScreenState();
}

class _CreateSummaryScreenState extends State<CreateSummaryScreen> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  final _sourceUrlController = TextEditingController();
  final _overviewController = TextEditingController();
  final _bulletsController = TextEditingController();
  final VaultRepository _repository = VaultRepository.instance;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _sourceUrlController.dispose();
    _overviewController.dispose();
    _bulletsController.dispose();
    super.dispose();
  }

  void _saveSummary() {
    final title = _titleController.text.trim();
    final overview = _overviewController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a summary title')),
      );
      return;
    }
    if (overview.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter summary overview text')),
      );
      return;
    }

    final category = _categoryController.text.trim().isNotEmpty
        ? _categoryController.text.trim()
        : 'General';
    final sourceUrl = _sourceUrlController.text.trim();

    final bulletsRaw = _bulletsController.text.split('\n');
    final bulletPoints = bulletsRaw
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty)
        .toList();

    final newSummary = SummaryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      sourceUrl: sourceUrl,
      sourceCategory: category,
      overview: overview,
      bulletPoints: bulletPoints,
      createdAt: DateTime.now(),
    );

    _repository.addSummary(newSummary);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary saved successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Summary',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryViolet,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              onPressed: _saveSummary,
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seamless Borderless Title
              TextField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  letterSpacing: -0.5,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Summary Title...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 14),

              // Category & Source URL chips row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.label_outline_rounded, size: 14, color: Color(0xD9D97706)),
                        const SizedBox(width: 4),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _categoryController,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: 'Category',
                              hintStyle: TextStyle(color: Color(0xFFB45309), fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded, size: 16, color: AppColors.textDarkSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _sourceUrlController,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF3B82F6)),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: 'Source URL (optional)...',
                              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 20),

              // Overview Section Header
              const Text(
                'OVERVIEW & SUMMARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 8),

              // Infinite Borderless Overview Text
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 220),
                child: TextField(
                  controller: _overviewController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textDark),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Start writing the summary overview here...\n\nYou have unlimited space to capture all key insights and context.',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15, height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 20),

              // Key Takeaways Section Header
              const Text(
                'KEY TAKEAWAYS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 8),

              // Infinite Borderless Key Takeaways Text
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 200),
                child: TextField(
                  controller: _bulletsController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textDark),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    hintText: '• Point 1: First important takeaway\n• Point 2: Second key learning or action\n• Point 3: Additional conclusion...',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15, height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
