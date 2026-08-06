import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Page indicator dots matching the UI design (active dot expands into smooth pill).
class OnboardingIndicator extends StatelessWidget {
  final int totalCount;
  final int currentIndex;

  const OnboardingIndicator({
    super.key,
    required this.totalCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalCount,
        (index) {
          final bool isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.indicatorActive
                  : AppColors.indicatorInactive,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        },
      ),
    );
  }
}
