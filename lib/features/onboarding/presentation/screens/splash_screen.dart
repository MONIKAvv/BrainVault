import 'package:brainvault/app/router.dart';
import 'package:brainvault/features/auth/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for 3 seconds before navigating
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // checking if onboarding has been completed
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final bool onboardingCompleted =
        prefs.getBool('onBoarding Completed') ?? false;

    // check firebase authentication
    final User? currentUser = FirebaseAuth.instance.currentUser;
    print("onBoarding Completed ${onboardingCompleted}");
    print('Current user: ${currentUser}');

    if (!onboardingCompleted) {
      // first time user
      Navigator.of(context).pushReplacementNamed(AppRouter.onboarding);
      return;
    }

    if (currentUser != null) {
      // user is already logged in and onboarding is completed -> go to home directly
      AppRouter.navigateToHome(context);
      return;
    }

    // onboarding is completed but user is not logged in -> navigate via AuthWrapper / login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return const AuthWrapper();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App Icon Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),

                // App Title
                const Text(
                  "BRAIN VAULT",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),

                // Taglines
                const Text(
                  "Your ideas, Organised.",
                  style: AppTextStyles.onboardingSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  "Your Future. Elevated.",
                  style: AppTextStyles.onboardingSubtitle.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Bottom Loading Bar
                const SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
