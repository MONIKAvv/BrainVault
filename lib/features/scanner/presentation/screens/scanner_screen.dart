import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen #13: Document Scanner Screen
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  int _selectedModeIndex = 1; // 1 = DOCUMENT
  bool _isFlashOn = false;

  final List<String> _modes = ['PHOTO', 'DOCUMENT', 'BOOK', 'ID CARD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Viewfinder (Simulated Document Camera Feed)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=800',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),

            // Scanning Overlay Bounding Box with Purple Corners
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                height: MediaQuery.of(context).size.height * 0.52,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Corner Brackets
                    _buildCornerBracket(top: 0, left: 0, isTop: true, isLeft: true),
                    _buildCornerBracket(top: 0, right: 0, isTop: true, isLeft: false),
                    _buildCornerBracket(bottom: 0, left: 0, isTop: false, isLeft: true),
                    _buildCornerBracket(bottom: 0, right: 0, isTop: false, isLeft: false),
                  ],
                ),
              ),
            ),

            // Top Bar Controls
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFlashOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      color: _isFlashOn ? Colors.yellow : Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.aspect_ratio_rounded,
                        color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Bottom Control Area (Modes + Shutter)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Mode Selector Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_modes.length, (index) {
                        final isSelected = _selectedModeIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedModeIndex = index;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Column(
                              children: [
                                Text(
                                  _modes[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white60,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isSelected ? 24 : 0,
                                  height: 2,
                                  color: AppColors.primaryViolet,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Shutter Button Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Thumbnail Box
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 44,
                            height: 44,
                            color: Colors.white24,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&q=80&w=200',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Large Circular Shutter Button
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Document Captured!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Right Camera Flip Icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: const Icon(
                            Icons.cameraswitch_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerBracket({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required bool isTop,
    required bool isLeft,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: AppColors.primaryViolet, width: 3.5)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: AppColors.primaryViolet, width: 3.5)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: AppColors.primaryViolet, width: 3.5)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: AppColors.primaryViolet, width: 3.5)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
