import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/repositories/vault_repository.dart';

/// Organic Mind Map Diagram Widget inspired by classic hand-drawn mind maps
class MindMapDiagramWidget extends StatelessWidget {
  final String centralTopic;
  final List<MindMapNode> branches;
  final bool isInteractive;
  final double height;

  const MindMapDiagramWidget({
    super.key,
    required this.centralTopic,
    required this.branches,
    this.isInteractive = true,
    this.height = 300,
  });

  static const List<Color> _branchColors = [
    Color(0xFF8B5CF6), // Violet
    Color(0xFF0284C7), // Sky Blue
    Color(0xFF10B981), // Emerald
    Color(0xFFEC4899), // Pink
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Red
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isInteractive ? () => _showFullScreenDialog(context) : null,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Custom Painter for Organic Curved Lines
              Positioned.fill(
                child: CustomPaint(
                  painter: _MindMapCurvesPainter(
                    branchCount: branches.length,
                    colors: _branchColors,
                  ),
                ),
              ),

              // Layout of Central Node & Branch Nodes
              _buildDiagramContent(context),

              // Expand hint icon
              if (isInteractive)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fullscreen_rounded,
                      size: 16,
                      color: AppColors.primaryViolet,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagramContent(BuildContext context) {
    return Column(
      children: [
        // Top row of branches
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (branches.isNotEmpty) _buildBranchCard(branches[0], 0),
              if (branches.length > 1) _buildBranchCard(branches[1], 1),
            ],
          ),
        ),

        // Central Topic Node (Yellow Card with border like reference image)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE047), // Vibrant MindMap Yellow
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 13, color: Color(0xFF1E293B)),
                  SizedBox(width: 4),
                  Text(
                    'MIND MAP',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                centralTopic.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),

        // Bottom row of branches
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (branches.length > 2) _buildBranchCard(branches[2], 2),
              if (branches.length > 3) _buildBranchCard(branches[3], 3),
              if (branches.length > 4) _buildBranchCard(branches[4], 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBranchCard(MindMapNode node, int index) {
    final color = _branchColors[index % _branchColors.length];

    return Container(
      width: 135,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Branch Label Header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  node.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Children bullets
          ...node.children.take(3).map(
                (child) => Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          child,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textDark,
                            height: 1.2,
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

  void _showFullScreenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      centralTopic,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.8,
                  maxScale: 2.5,
                  child: MindMapDiagramWidget(
                    centralTopic: centralTopic,
                    branches: branches,
                    isInteractive: false,
                    height: 400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MindMapCurvesPainter extends CustomPainter {
  final int branchCount;
  final List<Color> colors;

  _MindMapCurvesPainter({
    required this.branchCount,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final targets = <Offset>[
      Offset(size.width * 0.25, size.height * 0.2),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.85),
      Offset(size.width * 0.8, size.height * 0.8),
    ];

    for (int i = 0; i < branchCount && i < targets.length; i++) {
      final color = colors[i % colors.length];
      final target = targets[i];

      final paint = Paint()
        ..color = color.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(center.dx, center.dy);

      final control1 = Offset(
        center.dx + (target.dx - center.dx) * 0.5,
        center.dy,
      );
      final control2 = Offset(
        target.dx,
        center.dy + (target.dy - center.dy) * 0.5,
      );

      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        target.dx,
        target.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MindMapCurvesPainter oldDelegate) {
    return oldDelegate.branchCount != branchCount;
  }
}
