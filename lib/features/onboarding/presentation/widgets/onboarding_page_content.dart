import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../data/models/onboarding_item.dart';

/// Single Onboarding Page View containing the illustration, title, and subtitle.
class OnboardingPageContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageContent({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Custom Vector Illustration
          item.illustration,

          const SizedBox(height: 36),

          // Title
          Text(
            item.title,
            style: AppTextStyles.onboardingTitle,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            item.subtitle,
            style: AppTextStyles.onboardingSubtitle,
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
