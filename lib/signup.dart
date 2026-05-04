import 'package:flutter/material.dart';
import 'package:op/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for sound
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ----- Play sound function -----
  void _playButtonSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3')); // Place click.mp3 in assets
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  // ----- Validation functions -----
String? _validateFullName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Username is required';
  if (value.trim().length < 6) return 'Username must be at least 6 characters';
  if (value.trim().length > 20) return 'Username must be at most 20 characters';
  final nameRegex = RegExp(r"^[a-zA-Z ]+$");
  if (!nameRegex.hasMatch(value.trim())) return 'Username can only contain letters and spaces';
  return null;
}

String? _validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6)  return 'Password must be at least 6 characters';
  if (value.length > 15) return 'Password must be at most 15 characters';
  if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Password must contain at least one uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(value)) return 'Password must contain at least one lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(value)) return 'Password must contain at least one number';
  if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) return 'Password must contain at least one special character';
  return null;
}
/// Parses the backend's { message, statusCode } JSON into a friendly string
String _parseBackendError(String responseBody, int statusCode) {
  try {
    final data = jsonDecode(responseBody);
    if (data is Map && data['message'] != null) {
      final msg = data['message'];
      if (msg is List) return (msg as List).join('\n');
      if (msg is String && msg.trim().isNotEmpty) return msg.trim();
    }
  } catch (_) {}

  // Fallback by status code
  switch (statusCode) {
    case 400: return 'Some information you entered is invalid. Please review and try again.';
    case 409: return 'An account with this email already exists. Try logging in instead.';
    case 422: return 'Please check your details and try again.';
    case 500: return 'Our server is having an issue. Please try again in a moment.';
    default:  return 'Signup failed. Please try again.';
  }
}

/// Maps exceptions (network, timeout, etc.) to friendly messages
String _parseException(Exception e) {
  final msg = e.toString().toLowerCase();
  if (msg.contains('timeout'))          return 'Request timed out. Please check your connection and try again.';
  if (msg.contains('socketexception'))  return 'No internet connection. Please check your network.';
  if (msg.contains('handshake'))        return 'Secure connection failed. Please try again.';
  return 'Something went wrong. Please try again.';
}

/// Red error snackbar — never shows raw code or exception text
void _showErrorSnackbar(String message) {
  if (!mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white70,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
}

/// Green success snackbar
void _showSuccessSnackbar(String message) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}

void _handleSignup() async {
  _playButtonSound();

  if (!_formKey.currentState!.validate()) return;

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: Color(0xFF6E4BD8)),
    ),
  );

  try {
    final prodUrl = dotenv.env['base_url_production'] ?? '';

    if (prodUrl.isEmpty) {
      Navigator.of(context).pop(); // close loader
      _showErrorSnackbar('App configuration error. Please contact support.');
      return;
    }

    final response = await http.post(
      Uri.parse("$prodUrl/users/register-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": _fullNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "role": "user",
      }),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('timeout'),
    );

    Navigator.of(context).pop(); // close loader

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data["access_token"];
      final userId = data["user"]?["id"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      if (userId != null) await prefs.setInt("userId", userId);

      _showSuccessSnackbar('Account created successfully! Welcome 🎉');

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuizScreen()),
        );
      });
    } else {
      // Parse friendly message from your backend's JSON response
      final message = _parseBackendError(response.body, response.statusCode);
      _showErrorSnackbar(message);
    }
  } on Exception catch (e) {
    if (Navigator.canPop(context)) Navigator.of(context).pop(); // close loader if still open
    final message = _parseException(e);
    _showErrorSnackbar(message);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),

// Mascot
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 160,  // adjust size here
                    height: 160, // adjust size here
                    child: Image.asset(
                      "assets/logo1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 0),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Full Name"),
                      const SizedBox(height: 8),
                      _inputField(
                        controller: _fullNameController,
                        hint: "Your full name",
                        validator: _validateFullName,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 18),

                      _label("Email Address"),
                      const SizedBox(height: 8),
                      _inputField(
                        controller: _emailController,
                        hint: "example@gmail.com",
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),

                      _label("Password"),
                      const SizedBox(height: 8),
                      _passwordInput(
                        controller: _passwordController,
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 30),

                      // Sign Up Button with sound
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6E4BD8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 8,
                          ),
                          onPressed: _handleSignup,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Or divider and social icons
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white24)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Or",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                          ),
                          Expanded(child: Divider(color: Colors.white24)),
                        ],
                      ),
                      const SizedBox(height: 24),
                    
                      const SizedBox(height: 30),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // REMOVE _playButtonSound(); here
                            Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
);
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white60, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Log In",
                                  style: TextStyle(
                                    color: Color(0xFFAAF308),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFAAF308), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        isDense: true,
      ),
    );
  }

  Widget _passwordInput({
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: !isPasswordVisible,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0D0D0D),
        hintText: "Enter password",
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFAAF308), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white54,
              size: 20),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  // Widget _socialIcon(IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: const Color(0xFF0D0D0D),
  //       border: Border.all(color: Colors.white24),
  //     ),
  //     child: Icon(icon, color: const Color(0xFFAAF308), size: 24),
  //   );
  // }
}
