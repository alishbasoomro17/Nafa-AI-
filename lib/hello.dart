import 'dart:async';
import 'package:flutter/material.dart';
import 'signup.dart';       


class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> pages = [
    // 🔹 FIRST PAGE — LOGO
    {"type": "logo"},

    // 🔹 ONBOARDING PAGES
    {
      "type": "content",
      "title": "Create Account in Minutes",
      "subtitle":
      "Start investing quickly with a simple, secure, and guided signup process.",
      "icon": Icons.flash_on_rounded,
    },
    {
      "type": "content",
      "title": "Shariah & Non-Shariah Options",
      "subtitle":
      "Choose transparent investment options aligned with your personal values.",
      "icon": Icons.verified_user_rounded,
    },
    {
      "type": "content",
      "title": "Quiz-Based Risk Profiling",
      "subtitle":
      "Answer a short quiz to receive AI-powered investment recommendations.",
      "icon": Icons.analytics_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();

    // 🔹 Delay for first page (logo) longer
    Duration delay =
    currentIndex == 0 ? const Duration(seconds: 5) : const Duration(seconds: 3);

    _timer = Timer(delay, () {
      if (!mounted) return;

      if (currentIndex < pages.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      _controller.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _startAutoSlide(); // restart timer
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black, // Full pure black background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Logo
              Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/logo1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                'Smart Investment',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Make informed financial decisions with personalized recommendations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: 250,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E4BD8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
