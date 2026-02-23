import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velp_lite/core/entities/user_entity.dart';
import 'package:velp_lite/core/providers/user_providers.dart';
import 'package:velp_lite/core/theme/app_colors.dart';
import 'package:velp_lite/core/validators/validators.dart';
import 'package:velp_lite/features/auth/presentation/screens/register_screen.dart';
import 'package:velp_lite/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();

  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _signIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (_loginFormKey.currentState!.validate()) {
      UserEntity userEntity = UserEntity(
        email: _emailController.text,
        password: _passwordController.text,
      );
      try {
        final user = await ref
            .read(userViewModelProvider.notifier)
            .loginUser(userEntity);
        await prefs.setInt('user_id', user.id!);
        if (user.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          setState(() {
            errorMessage = 'Invalid email or password';
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      } catch (e) {
        String friendlyMessage = 'Login failed. Please try again.';
        if (e.toString().contains('Incorrect password')) {
          friendlyMessage =
              'Oops! The password you entered is incorrect. Please double-check and try again.';
        } else if (e.toString().contains('User not found')) {
          friendlyMessage =
              'Hmm, that email doesn\'t seem right. Please check it and try again.';
        }
        setState(() {
          errorMessage = friendlyMessage;
        });
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative paw prints
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.08,
              child: const Text(
                '🐾',
                style: TextStyle(fontSize: 32, color: Colors.black12),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              right: MediaQuery.of(context).size.width * 0.10,
              child: const Text(
                '🐾',
                style: TextStyle(fontSize: 24, color: Colors.black12),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.15,
              child: const Text(
                '🐾',
                style: TextStyle(fontSize: 28, color: Colors.black12),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.35,
              right: MediaQuery.of(context).size.width * 0.08,
              child: const Text(
                '🐾',
                style: TextStyle(fontSize: 20, color: Colors.black12),
              ),
            ),

            // Main Content
            Column(
              children: [
                // Logo Section
                Padding(
                  padding: const EdgeInsets.only(top: 60, bottom: 40),
                  child: Column(
                    children: [
                      // const Text(
                      //   '🐾',
                      //   style: TextStyle(fontSize: 80, color: Colors.purple),
                      // ),
                      Icon(Icons.pets, size: 120, color: AppColors.primary),
                      const SizedBox(height: 16),
                      const Text(
                        'Velp Lite',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your pet\'s best friend',
                        style: TextStyle(
                          color: AppColors.lightText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Section
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1AB4A7D6),
                          blurRadius: 20,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email Field
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {});
                              },
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                validator: Validators().emailValidation,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'your@email.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.accent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {});
                              },
                              child: TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                validator: Validators().passwordValidation,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: const EdgeInsets.all(16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.background,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.accent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  shadowColor: AppColors.primary.withValues(
                                    alpha: .4,
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Sign Up Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color: AppColors.lightText,
                                    fontSize: 15,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
