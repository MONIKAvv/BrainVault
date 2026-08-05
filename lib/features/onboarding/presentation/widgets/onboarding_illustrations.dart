import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen 1 Illustration: "Capture Ideas"
class CaptureIdeasIllustration extends StatelessWidget {
  const CaptureIdeasIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glowing circle
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          // Potted Plant on right
          Positioned(
            right: 40,
            bottom: 25,
            child: _buildPottedPlant(),
          ),

          // Person sitting down
          Positioned(
            bottom: 20,
            child: _buildPersonWithTablet(),
          ),

          // Floating Cards & Icons Top Left
          Positioned(
            top: 20,
            left: 55,
            child: _buildFloatingCard(
              icon: Icons.article_rounded,
              iconColor: const Color(0xFF8B5CF6),
              rotation: -0.15,
            ),
          ),

          // Floating Cards & Icons Top Center
          Positioned(
            top: 10,
            child: _buildFloatingCard(
              icon: Icons.lightbulb_rounded,
              iconColor: const Color(0xFFF59E0B),
              rotation: 0.08,
            ),
          ),

          // Floating Cards & Icons Top Right
          Positioned(
            top: 25,
            right: 55,
            child: _buildFloatingCard(
              icon: Icons.description_rounded,
              iconColor: const Color(0xFFEC4899),
              rotation: 0.12,
            ),
          ),

          // Floating Music/Note pill
          Positioned(
            top: 75,
            right: 40,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.music_note_rounded,
                  size: 14, color: Colors.white),
            ),
          ),

          // Sparkle Dots
          const Positioned(top: 15, left: 100, child: _SparkleStar(size: 12)),
          const Positioned(top: 85, left: 45, child: _SparkleStar(size: 10)),
          const Positioned(top: 60, right: 90, child: _SparkleStar(size: 14)),
        ],
      ),
    );
  }

  Widget _buildPersonWithTablet() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Legs cross-folded
          Positioned(
            bottom: 0,
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF3730A3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Shoes
          Positioned(
            bottom: 0,
            left: 5,
            child: Container(
              width: 32,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: Container(
              width: 32,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Torso
          Positioned(
            bottom: 30,
            child: Container(
              width: 60,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Tablet in hands
          Positioned(
            bottom: 35,
            child: Transform.rotate(
              angle: -0.1,
              child: Container(
                width: 44,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 34,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC084FC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Head & Hair
          Positioned(
            top: 10,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Hair
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1B4B),
                    shape: BoxShape.circle,
                  ),
                ),
                // Face
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCA5A5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPottedPlant() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Plant Leaves
        SizedBox(
          width: 50,
          height: 60,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                left: 0,
                bottom: 10,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Container(
                    width: 22,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Transform.rotate(
                  angle: 0.3,
                  child: Container(
                    width: 22,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF818CF8),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 24,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA5B4FC),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Pot
        Container(
          width: 36,
          height: 30,
          decoration: const BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCard({
    required IconData icon,
    required Color iconColor,
    required double rotation,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}

/// Screen 2 Illustration: "Organize Everything"
class OrganizeEverythingIllustration extends StatelessWidget {
  const OrganizeEverythingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glow
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          // Secondary Card in background
          Positioned(
            top: 25,
            right: 45,
            child: Container(
              width: 140,
              height: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.amber, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                      width: 80,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 8),
                  Container(
                      width: 100,
                      height: 8,
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
          ),

          // Primary Window (Desktop interface card)
          Positioned(
            top: 45,
            left: 45,
            child: Container(
              width: 175,
              height: 175,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Bar Window Controls
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFF5F56),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFBD2E),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Color(0xFF27C93F),
                              shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search bar line
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            size: 10, color: Colors.grey),
                        const SizedBox(width: 4),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Task Item 1
                  _buildTaskRow(true, "Brainstorming", const Color(0xFF818CF8)),
                  const SizedBox(height: 8),

                  // Task Item 2
                  _buildTaskRow(
                      false, "Design mockups", const Color(0xFFC084FC)),
                  const SizedBox(height: 8),

                  // Task Item 3
                  _buildTaskRow(
                      false, "Review feedback", const Color(0xFFF472B6)),
                ],
              ),
            ),
          ),

          // Floating Checklist Badge Bottom Right
          Positioned(
            bottom: 25,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 35,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B7280),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sparkles
          const Positioned(top: 20, left: 60, child: _SparkleStar(size: 12)),
          const Positioned(bottom: 20, left: 35, child: _SparkleStar(size: 10)),
        ],
      ),
    );
  }

  Widget _buildTaskRow(bool checked, String text, Color accent) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: checked ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: checked ? accent : Colors.grey.shade400, width: 1.5),
          ),
          child: checked
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                color: checked ? Colors.grey.shade400 : Colors.black87,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Screen 3 Illustration: "Smart AI Assistant"
class SmartAIAssistantIllustration extends StatelessWidget {
  const SmartAIAssistantIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Platform Shadow Base
          Positioned(
            bottom: 20,
            child: Container(
              width: 160,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.elliptical(80, 15)),
                color: Colors.black.withValues(alpha: 0.2),
              ),
            ),
          ),

          // Speech Bubble 1 - Top Left (Waveform)
          Positioned(
            top: 25,
            left: 45,
            child: _buildSpeechBubble(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    width: 3,
                    height: (index % 2 == 0 ? 14 : 8).toDouble(),
                    decoration: BoxDecoration(
                      color: AppColors.primaryViolet,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Speech Bubble 2 - Top Right (AI Summary Icon)
          Positioned(
            top: 15,
            right: 45,
            child: _buildSpeechBubble(
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF8B5CF6),
                size: 18,
              ),
            ),
          ),

          // Robot Assistant
          Positioned(
            bottom: 30,
            child: _buildRobotBody(),
          ),

          // Floating Sparkle Dots
          const Positioned(top: 80, left: 35, child: _SparkleStar(size: 12)),
          const Positioned(top: 60, right: 30, child: _SparkleStar(size: 14)),
          const Positioned(bottom: 70, right: 40, child: _SparkleStar(size: 10)),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRobotBody() {
    return SizedBox(
      width: 140,
      height: 170,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Antenna
          Positioned(
            top: 0,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF38BDF8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF38BDF8), blurRadius: 6),
                    ],
                  ),
                ),
                Container(
                  width: 4,
                  height: 12,
                  color: Colors.white70,
                ),
              ],
            ),
          ),

          // Head
          Positioned(
            top: 20,
            child: Container(
              width: 90,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Center(
                // Visor Face
                child: Container(
                  width: 72,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.robotFaceBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Eye Left
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF38BDF8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0xFF38BDF8), blurRadius: 4),
                          ],
                        ),
                      ),
                      // Eye Right
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF38BDF8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0xFF38BDF8), blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Ears / Side Knobs
          Positioned(
            top: 45,
            left: 18,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            top: 45,
            right: 18,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          // Body Torso
          Positioned(
            top: 92,
            child: Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8),
                ],
              ),
              child: Center(
                // Chest Core Badge
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF818CF8).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      size: 18,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Arms Left & Right
          Positioned(
            top: 100,
            left: 12,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 18,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 12,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 18,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper sparkle star widget for visual aesthetic
class _SparkleStar extends StatelessWidget {
  final double size;

  const _SparkleStar({this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: Colors.white.withValues(alpha: 0.7),
    );
  }
}
