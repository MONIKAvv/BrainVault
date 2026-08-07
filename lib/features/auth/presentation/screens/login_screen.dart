import 'package:brainvault/core/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';

/// Screen #5: Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter all fields")));
      return;
    }

    try {
      await _authService.login(email: email, password: password);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successfull")));
      print("User: ${FirebaseAuth.instance.currentUser}");
      AppRouter.navigateToHome(context);
    } on FirebaseAuthException catch (e) {
      String message = "Login failed.";
      switch (e.code) {
        case 'user-not-found':
          message = "No account found with this email.";
          break;

        case 'wrong-password':
          message = "Incorrect password.";
          break;

        case 'invalid-email':
          message = "Invalid email address.";
          break;

        case 'invalid-credential':
          message = "Email or password is incorrect.";
          break;

        default:
          message = e.message ?? "Login failed.";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
  }

  void _onSignUpTap() {
    // Navigate to Register Screen
    AppRouter.navigateToRegister(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header Title
              Row(
                children: const [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('👋', style: TextStyle(fontSize: 24)),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Login to continue to Brain Vault',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDarkSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Social Login Buttons
              _buildSocialButton(
                iconWidget: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                  height: 20,
                  width: 20,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.g_mobiledata_rounded,
                    size: 26,
                    color: Colors.red,
                  ),
                ),
                label: 'Continue with Google',
                onPressed: _onLogin,
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                iconWidget: const Icon(
                  Icons.apple,
                  size: 22,
                  color: AppColors.textDark,
                ),
                label: 'Continue with Apple',
                onPressed: _onLogin,
              ),
              const SizedBox(height: 24),

              // Divider "or"
              Row(
                children: const [
                  Expanded(
                    child: Divider(color: AppColors.borderLight, thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.borderLight, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Email Field
              _buildInputFieldLabel('Email'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                decoration: _buildInputDecoration('youremail@gmail.com'),
              ),
              const SizedBox(height: 20),

              // Password Field
              _buildInputFieldLabel('Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                decoration: _buildInputDecoration(
                  'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textDarkSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDarkSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryViolet,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Don't have an account? Sign Up
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onSignUpTap,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryViolet,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryViolet,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
