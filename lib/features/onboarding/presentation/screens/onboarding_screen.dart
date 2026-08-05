import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/onboarding_item.dart';
import '../widgets/onboarding_bottom_bar.dart';
import '../widgets/onboarding_illustrations.dart';
import '../widgets/onboarding_page_content.dart';

/// Main Onboarding View holding the PageView and bottom control bar.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late final List<OnboardingItem> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      OnboardingItem(
        title: AppStrings.onboardingTitle1,
        subtitle: AppStrings.onboardingSubtitle1,
        illustration: CaptureIdeasIllustration(),
      ),
      OnboardingItem(
        title: AppStrings.onboardingTitle2,
        subtitle: AppStrings.onboardingSubtitle2,
        illustration: OrganizeEverythingIllustration(),
      ),
      OnboardingItem(
        title: AppStrings.onboardingTitle3,
        subtitle: AppStrings.onboardingSubtitle3,
        illustration: SmartAIAssistantIllustration(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    AppRouter.navigateToLogin(context);
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      AppRouter.navigateToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.purpleGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Page View area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(item: _pages[index]);
                  },
                ),
              ),

              // Bottom bar navigation (SKIP, Dots, Circular Arrow Button)
              OnboardingBottomBar(
                totalPages: _pages.length,
                currentIndex: _currentIndex,
                onSkip: _onSkip,
                onNext: _onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
