import 'package:flutter/material.dart';

/// Data model representing an onboarding screen page item.
class OnboardingItem {
  final String title;
  final String subtitle;
  final Widget illustration;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}
