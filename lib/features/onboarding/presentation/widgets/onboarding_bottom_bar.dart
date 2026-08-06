import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import 'onboarding_indicator.dart';

/// Bottom bar widget containing SKIP button, page dots, and circular next arrow button.
class OnboardingBottomBar extends StatelessWidget {
  final int totalPages;
  final int currentIndex;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingBottomBar({
    super.key,
    required this.totalPages,
    required this.currentIndex,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SKIP Text Button
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              AppStrings.skip,
              style: AppTextStyles.skipButton,
            ),
          ),

          // Page Indicator Dots
          OnboardingIndicator(
            totalCount: totalPages,
            currentIndex: currentIndex,
          ),

          // Circular Action Next Arrow Button
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.buttonWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.iconDark,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
