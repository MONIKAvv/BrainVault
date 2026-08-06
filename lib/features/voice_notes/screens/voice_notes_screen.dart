import 'dart:math';
import 'package:brainvault/app/theme/app_colors.dart';
import 'package:brainvault/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

// ── Data model ───────────────────────────────────────────────────────────────
class _VoiceNote {
  final String title;
  final String timestamp;
  String duration;
  final List<double> waveform;
  bool isPlaying = false;

  _VoiceNote(this.title, this.timestamp, this.duration, this.waveform);
}

// ── Screen ───────────────────────────────────────────────────────────────────
class VoiceNotesScreen extends StatefulWidget {
  const VoiceNotesScreen({super.key});

  @override
  State<VoiceNotesScreen> createState() => _VoiceNotesScreenState();
}

class _VoiceNotesScreenState extends State<VoiceNotesScreen>
    with SingleTickerProviderStateMixin {
  static final List<double> _wave =
      List.generate(28, (i) => 0.25 + Random(i).nextDouble() * 0.75);

  static final List<double> _wave2 =
      List.generate(28, (i) => 0.2 + Random(i + 10).nextDouble() * 0.8);

  late List<_VoiceNote> _notes;

  // Recording state
  bool _isRecording = false;
  int _recordingSeconds = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _notes = [
      _VoiceNote('Lecture 01', 'Today, 10:20 AM', '03:45', _wave),
      _VoiceNote('Meeting Notes', 'Yesterday, 4:30 PM', '05:12', _wave2),
      _VoiceNote('Ideas Voice Note', '12 May, 8:15 PM', '02:30', _wave),
    ];

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _recTime {
    final m = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_recordingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _pulseController.repeat(reverse: true);
      // Simulate timer
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted || !_isRecording) return false;
        setState(() => _recordingSeconds++);
        return _isRecording;
      });
    } else {
      _pulseController.stop();
      if (_recordingSeconds > 0) {
        final m = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
        final s = (_recordingSeconds % 60).toString().padLeft(2, '0');
        final wave = List.generate(
            28, (i) => 0.2 + Random(DateTime.now().millisecond + i).nextDouble() * 0.8);
        setState(() {
          _notes.insert(
            0,
            _VoiceNote(
              'Recording ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
              'Just now',
              '$m:$s',
              wave,
            ),
          );
          _recordingSeconds = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice note saved!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showRecordingSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
        final textPrimary =
            isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        final textSecondary =
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

        return StatefulBuilder(
          builder: (ctx2, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Recording', style: AppTextStyles.h3(color: textPrimary)),
                  const SizedBox(height: 8),
                  // Animated timer text
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, _) => Transform.scale(
                      scale: _isRecording ? _pulseAnim.value : 1,
                      child: Text(
                        _recTime,
                        style: GoogleFontsHelper.poppinsBold(
                            56, AppColors.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRecording ? 'Recording in progress…' : 'Tap mic to start',
                    style: AppTextStyles.caption(color: textSecondary),
                  ),
                  const SizedBox(height: 32),

                  // Waveform preview
                  SizedBox(
                    height: 40,
                    child: CustomPaint(
                      painter: _AnimatedWaveformPainter(
                        _isRecording
                            ? List.generate(
                                30,
                                (i) => 0.2 +
                                    Random(DateTime.now().millisecond + i)
                                        .nextDouble() *
                                        0.8)
                            : List.filled(30, 0.1),
                        AppColors.primaryPurple,
                        textSecondary,
                      ),
                      size: const Size(double.infinity, 40),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Discard button
                      if (_isRecording) ...[
                        _CircleButton(
                          icon: Icons.delete_outline,
                          color: AppColors.error,
                          size: 52,
                          onTap: () {
                            setState(() {
                              _isRecording = false;
                              _recordingSeconds = 0;
                            });
                            _pulseController.stop();
                            Navigator.pop(ctx);
                          },
                        ),
                        const SizedBox(width: 32),
                      ],

                      // Main mic/stop button
                      GestureDetector(
                        onTap: () {
                          _toggleRecording();
                          setSheetState(() {});
                          if (!_isRecording) {
                            Navigator.pop(ctx);
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, _) => Transform.scale(
                            scale: _isRecording ? _pulseAnim.value : 1,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? AppColors.error
                                    : AppColors.primaryPurple,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isRecording
                                            ? AppColors.error
                                            : AppColors.primaryPurple)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Pause button
                      if (_isRecording) ...[
                        const SizedBox(width: 32),
                        _CircleButton(
                          icon: Icons.pause_rounded,
                          color: AppColors.warning,
                          size: 52,
                          onTap: () {
                            setState(() => _isRecording = false);
                            _pulseController.stop();
                            setSheetState(() {});
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
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
          'Voice Notes',
          style: AppTextStyles.h3(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRecordingSheet,
        shape: const CircleBorder(),
        child: const Icon(Icons.mic_rounded),
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic_off_rounded, size: 56, color: textSecondary),
                  const SizedBox(height: 12),
                  Text('No voice notes yet',
                      style: AppTextStyles.body(color: textSecondary)),
                  const SizedBox(height: 8),
                  Text('Tap the mic button to record',
                      style: AppTextStyles.caption(color: textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
              itemCount: _notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) =>
                  _VoiceNoteTile(
                    note: _notes[index],
                    onPlayToggle: () => setState(() {
                      for (var i = 0; i < _notes.length; i++) {
                        _notes[i].isPlaying =
                            i == index && !_notes[index].isPlaying;
                      }
                    }),
                    onDelete: () {
                      final deleted = _notes[index];
                      setState(() => _notes.removeAt(index));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${deleted.title}" deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () => setState(() => _notes.insert(index, deleted)),
                          ),
                        ),
                      );
                    },
                  ),
            ),
    );
  }
}

// ── Waveform Painter ──────────────────────────────────────────────────────────
class _AnimatedWaveformPainter extends CustomPainter {
  final List<double> heights;
  final Color activeColor;
  final Color trackColor;

  _AnimatedWaveformPainter(this.heights, this.activeColor, this.trackColor);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (heights.length * 1.6);
    final gap = barWidth * 0.6;
    final activeCount = (heights.length * 0.35).round();

    for (var i = 0; i < heights.length; i++) {
      final x = i * (barWidth + gap);
      final h = heights[i] * size.height;
      final paint = Paint()
        ..color = i < activeCount ? activeColor : trackColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth;
      canvas.drawLine(
        Offset(x, size.height / 2 - h / 2),
        Offset(x, size.height / 2 + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedWaveformPainter old) => true;
}

// ── Voice note tile ────────────────────────────────────────────────────────────
class _VoiceNoteTile extends StatelessWidget {
  final _VoiceNote note;
  final VoidCallback onPlayToggle;
  final VoidCallback onDelete;

  const _VoiceNoteTile({
    required this.note,
    required this.onPlayToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Dismissible(
      key: ValueKey(note.title + note.timestamp),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: AppTextStyles.subtitle(
                          color: theme.textTheme.bodyLarge?.color),
                    ),
                  ),
                  Text(
                    note.duration,
                    style: AppTextStyles.caption(color: textSecondary),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.more_vert, color: textSecondary, size: 18),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                note.timestamp,
                style: AppTextStyles.caption(color: textSecondary),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  // Play / Pause button
                  GestureDetector(
                    onTap: onPlayToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: note.isPlaying
                            ? AppColors.primaryPurple
                            : AppColors.primaryPurple,
                        shape: BoxShape.circle,
                        boxShadow: note.isPlaying
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryPurple
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      child: Icon(
                        note.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Waveform
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: CustomPaint(
                        painter: _AnimatedWaveformPainter(
                          note.waveform,
                          AppColors.primaryPurple,
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        size: const Size(double.infinity, 32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Circle button helper ───────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: size * 0.42),
      ),
    );
  }
}

// ── Google Fonts helper (avoids importing google_fonts everywhere) ─────────────
class GoogleFontsHelper {
  static TextStyle poppinsBold(double size, Color color) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.5,
    );
  }
}
