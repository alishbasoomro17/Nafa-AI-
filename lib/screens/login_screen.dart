
  // Email: admin@nafai.com
  // Password: 123456

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  static const kLime   = Color(0xFFAAF308);
  static const kPurple = Color(0xFF6E4BD8);

  static const kBg     = Color(0xFF0B0B12);
  static const kCard   = Color(0xFF141420);
  static const kField  = Color(0xFF1A1A2E);
  static const kBorder = Color(0xFF2A2A40);

  static const kText   = Colors.white;
  static const kSubText= Color(0xFFB0B3C7);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isSuccess = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: 40, left: 0, right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSuccess ? kLime : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.black : Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: TextStyle(
                      color: isSuccess ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty) {
      _showToast('Please enter your email', isSuccess: false);
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showToast('Please enter your password', isSuccess: false);
      return;
    }

    if (_emailController.text.trim() == 'admin@nafai.com' &&
        _passwordController.text == '123456') {
      _showToast('Login successful!');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      _showToast('Invalid email or password', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0B12), Color(0xFF6E4BD8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 420,
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kBorder),
                  boxShadow: [
                    BoxShadow(
                      color: kPurple.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/nafa-logo.jpeg',
                        width: 72, height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Nafai Ai',
                      style: TextStyle(
                        color: kText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Login to your account',
                      style: TextStyle(color: kSubText, fontSize: 12),
                    ),

                    const SizedBox(height: 32),

                    _field(
                      controller: _emailController,
                      hint: 'Email address',
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 12),

                    _field(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock,
                      obscure: _obscure,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kSubText,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Lime Button ✅
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLime,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kField,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: kText),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kSubText),
          prefixIcon: Icon(icon, color: kSubText, size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}