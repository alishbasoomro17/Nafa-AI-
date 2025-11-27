import 'package:flutter/material.dart';
import 'signup.dart';
import 'quiz_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
