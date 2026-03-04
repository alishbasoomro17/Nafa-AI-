import 'package:flutter/material.dart';
import 'package:op/recommendation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterQuizSplash extends StatefulWidget {
  const AfterQuizSplash({super.key});

  @override
  State<AfterQuizSplash> createState() => _AfterQuizSplashState();
}

class _AfterQuizSplashState extends State<AfterQuizSplash> {
  String? riskCategory;

  @override
  void initState() {
    super.initState();
    _loadRiskCategory();
  }

 Future<void> _loadRiskCategory() async {
  final prefs = await SharedPreferences.getInstance();

  while (mounted) {
    final category = prefs.getString('riskCategory');
    print("Checking for risk category: $category"); // Debug print

    if (category != null) {
      print("Risk category found: $category")
      ; // Debug print
      setState(() {
        riskCategory = category;
      });
      break; // stop checking once we have it
    }

    await Future.delayed(const Duration(milliseconds: 500));
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
  child: Center(
    child: riskCategory == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Color(0xFFAAF308),
              ),
              SizedBox(height: 20),
              Text(
                "Calculating your risk profile...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFFAAF308),
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                "Quiz Completed!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "You are $riskCategory",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
  ),
),);
  }
}

