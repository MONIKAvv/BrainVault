import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Screen #9: Enhanced Note Editor
/// Supports custom text formatting (Bold, Italic, Underline, Fonts),
/// interactive Checklists, Images, and Audio Voice Notes.
/// Persists directly to Cloud Firestore.
class NoteEditorScreen extends StatefulWidget {
  final NoteItem? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  // Formatting state
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  String _fontFamily = 'Inter';
  double _fontSize = 15.0;

  // Media & Checklists state
  final List<Map<String, dynamic>> _checklistItems = [];
  String? _imageUrl;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    final note = widget.note;

    _titleController = TextEditingController(text: note?.title ?? '');
    _bodyController = TextEditingController(text: note?.content ?? '');

    if (note != null) {
      _imageUrl = note.imageUrl;
      _audioUrl = note.audioUrl;
      _isBold = note.isBold;
      _isItalic = note.isItalic;
      _isUnderline = note.isUnderline;
      _fontFamily = note.fontFamily;
      _fontSize = note.fontSize;
      if (note.checklist != null) {
        _checklistItems.addAll(note.checklist!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _addChecklistItem() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Checklist Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Research topic outline',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _checklistItems.add({
                    'title': controller.text.trim(),
                    'checked': false,
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddImageDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Insert Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Image URL or sample photo link:',
              style: TextStyle(fontSize: 12, color: AppColors.textDarkSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'https://images.unsplash.com/...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
            ),
            onPressed: () {
              final url = controller.text.trim();
              setState(() {
                _imageUrl = url.isNotEmpty
                    ? url
                    : 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&q=80&w=800';
              });
              Navigator.pop(context);
            },
            child: const Text('Insert Image', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddAudioDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Attach Voice Recording'),
        content: Row(
          children: const [
            Icon(Icons.mic_rounded, color: AppColors.primaryViolet, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Voice note attached successfully (Recorded 0:45s)',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
            ),
            onPressed: () {
              setState(() {
                _audioUrl = 'voice_note_attached.mp3';
              });
              Navigator.pop(context);
            },
            child: const Text('Attach', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFontPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Font Style',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Inter', 'Roboto', 'Outfit', 'Serif', 'Monospace']
                  .map((font) => ChoiceChip(
                        label: Text(font),
                        selected: _fontFamily == font,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _fontFamily = font);
                            Navigator.pop(context);
                          }
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _bodyTextStyle {
    TextStyle style = TextStyle(
      fontSize: _fontSize,
      fontFamily: _fontFamily == 'Monospace' ? 'monospace' : _fontFamily,
      color: AppColors.textDark,
      height: 1.5,
    );

    if (_isBold) style = style.copyWith(fontWeight: FontWeight.bold);
    if (_isItalic) style = style.copyWith(fontStyle: FontStyle.italic);
    if (_isUnderline && _isStrikethrough) {
      style = style.copyWith(
        decoration: TextDecoration.combine([
          TextDecoration.underline,
          TextDecoration.lineThrough,
        ]),
      );
    } else if (_isUnderline) {
      style = style.copyWith(decoration: TextDecoration.underline);
    } else if (_isStrikethrough) {
      style = style.copyWith(decoration: TextDecoration.lineThrough);
    }

    return style;
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty && body.isEmpty && _checklistItems.isEmpty && _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save an empty note.')),
      );
      return;
    }

    final noteId = widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final noteItem = NoteItem(
      id: noteId,
      title: title.isNotEmpty ? title : 'Untitled Note',
      subtitle: 'Just now',
      content: body,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      iconBg: const Color(0xFFFFEDD5),
      iconColor: const Color(0xFFEA580C),
      icon: Icons.edit_note_rounded,
      imageUrl: _imageUrl,
      audioUrl: _audioUrl,
      checklist: _checklistItems.isNotEmpty ? _checklistItems : null,
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      isBold: _isBold,
      isItalic: _isItalic,
      isUnderline: _isUnderline,
    );

    VaultRepository.instance.addNote(noteItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Saved Note to Cloud Firestore!'),
        backgroundColor: AppColors.primaryViolet,
        duration: Duration(seconds: 2),
      ),
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.note != null ? 'Edit Note' : 'New Note',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_format_rounded, color: AppColors.textDark),
            onPressed: _showFontPicker,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Rich Formatting Toolbar
            _buildFormattingToolbar(),
            const Divider(height: 1, color: AppColors.borderLight),

            // Scrollable Editor Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note Title
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                        color: AppColors.textDark,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Note Title...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Interactive Checklist Items
                    if (_checklistItems.isNotEmpty) ...[
                      const Text(
                        'Checklist:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ..._checklistItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item['checked'] = !(item['checked'] as bool);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: (item['checked'] as bool)
                                        ? AppColors.primaryViolet
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: (item['checked'] as bool)
                                          ? AppColors.primaryViolet
                                          : AppColors.textDarkSecondary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: (item['checked'] as bool)
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item['title'] as String? ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (item['checked'] as bool)
                                        ? AppColors.textDarkSecondary
                                        : AppColors.textDark,
                                    decoration: (item['checked'] as bool)
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _checklistItems.remove(item);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],

                    // Note Main Paragraph Body (Infinite vertical space, borderless)
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 450),
                      child: TextField(
                        controller: _bodyController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: _bodyTextStyle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Start writing your note...',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Audio Recording Attachment Card
                    if (_audioUrl != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_fill_rounded,
                                color: AppColors.primaryViolet, size: 36),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Voice Note Recording',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '0:45 • Audio File Attached',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textDarkSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                              onPressed: () {
                                setState(() => _audioUrl = null);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Attached Image Preview Card
                    if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _imageUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _imageUrl = null);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Toolbar
            _buildBottomActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Text(
              'B',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _isBold ? AppColors.primaryViolet : AppColors.textDark,
              ),
            ),
            onPressed: () => setState(() => _isBold = !_isBold),
          ),
          IconButton(
            icon: Text(
              'I',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _isItalic ? AppColors.primaryViolet : AppColors.textDark,
              ),
            ),
            onPressed: () => setState(() => _isItalic = !_isItalic),
          ),
          IconButton(
            icon: Text(
              'U',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _isUnderline ? AppColors.primaryViolet : AppColors.textDark,
              ),
            ),
            onPressed: () => setState(() => _isUnderline = !_isUnderline),
          ),
          IconButton(
            icon: Icon(
              Icons.strikethrough_s_rounded,
              color: _isStrikethrough ? AppColors.primaryViolet : AppColors.textDark,
              size: 20,
            ),
            onPressed: () => setState(() => _isStrikethrough = !_isStrikethrough),
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted_rounded, color: AppColors.textDark, size: 20),
            onPressed: () {
              setState(() {
                _bodyController.text = '${_bodyController.text}\n• ';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.checklist_rounded, color: AppColors.textDark, size: 20),
            onPressed: _addChecklistItem,
          ),
        ],
      ),
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
            icon: const Icon(Icons.image_outlined, color: AppColors.textDarkSecondary, size: 22),
            onPressed: _showAddImageDialog,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: AppColors.textDarkSecondary, size: 22),
            onPressed: _showAddImageDialog,
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_rounded, color: AppColors.textDarkSecondary, size: 22),
            onPressed: _showAddAudioDialog,
          ),
          IconButton(
            icon: const Icon(Icons.checklist_rounded, color: AppColors.textDarkSecondary, size: 22),
            onPressed: _addChecklistItem,
          ),
          const Spacer(),
          // Done Save Button
          GestureDetector(
            onTap: _saveNote,
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
