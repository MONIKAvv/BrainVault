import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../mindmap/presentation/widgets/mind_map_diagram_widget.dart';

enum AiMode { note, mindmap, summary }

/// Screen #10: AI Assistant ("Brain AI") integrated with Google Gemini API
class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AiMode _selectedMode = AiMode.note;
  final VaultRepository _repository = VaultRepository.instance;
  final GeminiService _geminiService = GeminiService.instance;
  String _lastPrompt = '';
  bool _isLoading = false;

  late final List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'there');
    _messages = [
      {
        'isUser': false,
        'text':
            'Hello $displayName! 👋\nI am Brain AI powered by Google Gemini.\nAsk me any question or select Note, Mind Map, or Summary above to generate insights!',
      },
    ];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _promptController.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userText = text;
    _lastPrompt = userText;
    _promptController.clear();

    setState(() {
      _messages.add({'isUser': true, 'text': userText});
      _messages.add({'isUser': false, 'type': 'loading'});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final aiAnswer = await _geminiService.askQuestion(userText);

      if (!mounted) return;
      setState(() {
        _messages.removeLast(); // Remove loading bubble
        _messages.add({'isUser': false, 'text': aiAnswer});
        _messages.add({
          'isUser': false,
          'type': 'options',
          'prompt': userText,
          'text':
              'Convert this insight into a saved Note, Mind Map, or Executive Summary:',
        });
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _messages.add({
          'isUser': false,
          'type': 'error',
          'error': e.toString().replaceAll('Exception: ', ''),
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _triggerOutputGeneration({
    required AiMode mode,
    required String promptText,
  }) async {
    if (_isLoading) return;

    setState(() {
      _selectedMode = mode;
      _messages.add({'isUser': false, 'type': 'loading'});
      _isLoading = true;
    });
    _scrollToBottom();

    final now = DateTime.now();
    final urlMatch = RegExp(r'https?://[^\s]+').firstMatch(promptText);
    final extractedUrl = urlMatch != null ? urlMatch.group(0)! : '';
    final isYouTube =
        extractedUrl.toLowerCase().contains('youtube.com') ||
        extractedUrl.toLowerCase().contains('youtu.be');

    try {
      if (mode == AiMode.note) {
        final result = await _geminiService.generateNoteContent(promptText);
        final title = (result['title'] as String?)?.isNotEmpty == true
            ? result['title'] as String
            : 'AI Generated Note';
        final content = (result['content'] as String?) ?? promptText;
        final bulletsRaw = result['bullets'] as List<dynamic>? ?? [];
        final bullets = bulletsRaw.map((e) => e.toString()).toList();

        final noteItem = NoteItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          subtitle: 'Just now • Gemini AI',
          content: content,
          createdAt: now,
          iconBg: const Color(0xFFF3E8FF),
          iconColor: AppColors.primaryViolet,
          icon: Icons.auto_awesome,
        );

        _repository.addNote(noteItem);

        if (!mounted) return;
        setState(() {
          _messages.removeLast();
          _messages.add({
            'isUser': false,
            'type': 'note',
            'title': title,
            'header': 'Generated Note with Gemini:',
            'content': content,
            'bullets': bullets,
            'savedTo': 'Notes section',
          });
          _isLoading = false;
        });
      } else if (mode == AiMode.mindmap) {
        final result = await _geminiService.generateMindMapContent(promptText);
        final title = (result['title'] as String?) ?? 'AI Mind Map';
        final centralTopic = (result['centralTopic'] as String?) ?? title;
        final branchesRaw = result['branches'] as List<dynamic>? ?? [];

        final List<MindMapNode> nodes = [];
        for (int i = 0; i < branchesRaw.length; i++) {
          final b = branchesRaw[i];
          if (b is Map<String, dynamic>) {
            final label = b['label'] as String? ?? 'Branch ${i + 1}';
            final childrenRaw = b['children'] as List<dynamic>? ?? [];
            final children = childrenRaw.map((c) => c.toString()).toList();
            nodes.add(
              MindMapNode(id: 'node_$i', label: label, children: children),
            );
          }
        }

        if (nodes.isEmpty) {
          nodes.addAll([
            MindMapNode(
              id: 'b1',
              label: 'Core Concepts',
              children: ['Key Idea 1', 'Key Idea 2'],
            ),
            MindMapNode(
              id: 'b2',
              label: 'Implementation',
              children: ['Step 1', 'Step 2'],
            ),
          ]);
        }

        final mindMapItem = MindMapItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          sourceUrl: extractedUrl,
          centralTopic: centralTopic,
          createdAt: now,
          branches: nodes,
        );

        _repository.addMindMap(mindMapItem);

        if (!mounted) return;
        setState(() {
          _messages.removeLast();
          _messages.add({
            'isUser': false,
            'type': 'mindmap',
            'title': title,
            'centralTopic': centralTopic,
            'sourceUrl': extractedUrl,
            'header': 'Generated Mind Map structure:',
            'branches': nodes,
            'savedTo': 'Mind Map section',
          });
          _isLoading = false;
        });
      } else if (mode == AiMode.summary) {
        final result = await _geminiService.generateSummaryContent(promptText);
        final title = (result['title'] as String?) ?? 'AI Executive Summary';
        final overview = (result['overview'] as String?) ?? 'Summary of prompt';
        final bulletsRaw = result['bullets'] as List<dynamic>? ?? [];
        final bullets = bulletsRaw.map((e) => e.toString()).toList();

        final summaryItem = SummaryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          sourceUrl: extractedUrl,
          sourceCategory: isYouTube ? 'YouTube' : 'Website',
          overview: overview,
          bulletPoints: bullets,
          createdAt: now,
        );

        _repository.addSummary(summaryItem);

        if (!mounted) return;
        setState(() {
          _messages.removeLast();
          _messages.add({
            'isUser': false,
            'type': 'summary',
            'title': title,
            'sourceUrl': extractedUrl,
            'sourceCategory': summaryItem.sourceCategory,
            'header': 'Generated Executive Summary:',
            'overview': overview,
            'bullets': bullets,
            'savedTo': 'Summary section',
          });
          _isLoading = false;
        });
      }
      _scrollToBottom();

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Saved to ${mode == AiMode.note
                ? "Notes"
                : mode == AiMode.mindmap
                ? "Mind Map"
                : "Summary"} section!',
          ),
          backgroundColor: AppColors.primaryViolet,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _messages.add({
          'isUser': false,
          'type': 'error',
          'error': e.toString().replaceAll('Exception: ', ''),
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFF3E8FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primaryViolet,
            size: 18,
          ),
        ),
        title: const Text(
          'Brain AI',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.more_vert_rounded, color: AppColors.textDark),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Mode Buttons (Notes, Mind Map, Summary)
            _buildTopActionButtons(),

            // Chat Messages Area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['isUser'] as bool;
                  final type = msg['type'] as String?;

                  if (isUser) {
                    return _buildUserBubble(msg['text'] as String);
                  } else if (type == 'loading') {
                    return _buildLoadingBubble();
                  } else if (type == 'error') {
                    return _buildErrorBubble(
                      msg['error'] as String? ?? 'Unknown error',
                    );
                  } else if (type == 'options') {
                    return _buildOptionsBubble(msg);
                  } else if (type == 'note') {
                    return _buildGeneratedNoteBubble(msg);
                  } else if (type == 'mindmap') {
                    return _buildGeneratedMindMapBubble(msg);
                  } else if (type == 'summary') {
                    return _buildGeneratedSummaryBubble(msg);
                  } else {
                    return _buildAiTextBubble(msg['text'] as String);
                  }
                },
              ),
            ),

            // Prompt & URL Input Bar
            _buildInputBar(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildTopActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select AI Output Type:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildModeChip(
                  mode: AiMode.note,
                  label: 'Notes',
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeChip(
                  mode: AiMode.mindmap,
                  label: 'Mind Map',
                  icon: Icons.account_tree_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeChip(
                  mode: AiMode.summary,
                  label: 'Summary',
                  icon: Icons.summarize_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip({
    required AiMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
        if (_lastPrompt.isNotEmpty && !_isLoading) {
          _triggerOutputGeneration(mode: mode, promptText: _lastPrompt);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryViolet
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryViolet : AppColors.borderLight,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryViolet.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.primaryViolet,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryViolet,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Brain AI is thinking...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBubble(String errorMsg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 30),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text(
                  'Gemini Request Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              errorMsg,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiTextBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: SelectableText(
          text,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsBubble(Map<String, dynamic> msg) {
    final promptText = msg['prompt'] as String? ?? '';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primaryViolet.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryViolet.withValues(alpha: 0.05),
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
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primaryViolet,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    msg['text'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildChoiceButton(
                    label: 'Notes',
                    icon: Icons.description_outlined,
                    color: const Color(0xFF9333EA),
                    bgColor: const Color(0xFFF3E8FF),
                    onTap: () => _triggerOutputGeneration(
                      mode: AiMode.note,
                      promptText: promptText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChoiceButton(
                    label: 'Mind Map',
                    icon: Icons.account_tree_outlined,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    onTap: () => _triggerOutputGeneration(
                      mode: AiMode.mindmap,
                      promptText: promptText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildChoiceButton(
                    label: 'Summary',
                    icon: Icons.summarize_outlined,
                    color: const Color(0xD9D97706),
                    bgColor: const Color(0xFFFEF3C7),
                    onTap: () => _triggerOutputGeneration(
                      mode: AiMode.summary,
                      promptText: promptText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedNoteBubble(Map<String, dynamic> msg) {
    final title = msg['title'] as String? ?? 'Generated Note';
    final header = msg['header'] as String? ?? 'Note:';
    final content = msg['content'] as String? ?? '';
    final bullets = (msg['bullets'] as List<dynamic>?)?.cast<String>() ?? [];
    final savedTo = msg['savedTo'] as String? ?? 'Notes section';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryViolet,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                _buildSavedBadge(savedTo),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              header,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDarkSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
                height: 1.4,
              ),
            ),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...bullets.map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: AppColors.primaryViolet,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
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
      ),
    );
  }

  Widget _buildGeneratedMindMapBubble(Map<String, dynamic> msg) {
    final title = msg['title'] as String? ?? 'Generated Mind Map';
    final centralTopic = msg['centralTopic'] as String? ?? title;
    final branches =
        (msg['branches'] as List<dynamic>?)?.cast<MindMapNode>() ?? [];
    final savedTo = msg['savedTo'] as String? ?? 'Mind Map section';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: Color(0xFF2563EB),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                _buildSavedBadge(savedTo),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MindMapDiagramWidget(
                  centralTopic: centralTopic,
                  branches: branches,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedSummaryBubble(Map<String, dynamic> msg) {
    final title = msg['title'] as String? ?? 'Executive Summary';
    final overview = msg['overview'] as String? ?? '';
    final bullets = (msg['bullets'] as List<dynamic>?)?.cast<String>() ?? [];
    final savedTo = msg['savedTo'] as String? ?? 'Summary section';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.summarize_outlined,
                    color: Color(0xD9D97706),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                _buildSavedBadge(savedTo),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              overview,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
                height: 1.4,
              ),
            ),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...bullets.map(
                (bullet) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xD9D97706),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
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
      ),
    );
  }

  Widget _buildSavedBadge(String target) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF10B981),
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            'Saved',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    String placeholderText;
    if (_selectedMode == AiMode.note) {
      placeholderText = 'Ask any question or paste prompt...';
    } else if (_selectedMode == AiMode.mindmap) {
      placeholderText = 'Topic or URL for Mind Map...';
    } else {
      placeholderText = 'Topic or URL for Executive Summary...';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.link_rounded,
                    color: AppColors.textDarkSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: placeholderText,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.mic_none_rounded,
                    color: AppColors.textDarkSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primaryViolet,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 20,
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
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 3, // AI Assistant index
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRouter.notesList);
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, AppRouter.mindmap);
          } else if (index == 3) {
            // Already here
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
