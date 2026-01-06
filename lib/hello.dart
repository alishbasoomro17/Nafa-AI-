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
    {
      "type": "logo",
    },

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

    // 🔹 FIRST delay longer (logo screen)
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

      // Restart timer with correct delay for next page
      _startAutoSlide();
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                  _startAutoSlide(); // 🔹 reset timing on manual swipe
                },
                itemBuilder: (context, index) {
                  if (pages[index]["type"] == "logo") {
                    return _logoPage();
                  }
                  return _buildPage(
                    pages[index]["icon"],
                    pages[index]["title"],
                    pages[index]["subtitle"],
                  );
                },
              ),
            ),

            _indicator(),

            const SizedBox(height: 20),

            // Get Started
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: 260,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E4BD8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 LOGO PAGE
  Widget _logoPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/logo1.png', width: 220),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Smart, personalized, and Shariah-aware investment guidance.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 CONTENT PAGES
  Widget _buildPage(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6E4BD8).withOpacity(0.15),
            ),
            child: Icon(icon, size: 56, color: const Color(0xFF6E4BD8)),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 INDICATOR
  Widget _indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color(0xFF6E4BD8)
                : Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
