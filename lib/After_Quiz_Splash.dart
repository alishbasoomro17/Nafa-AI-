import 'package:flutter/material.dart';
import 'recommendations_screen.dart'; // Import the new destination screen

class AfterQuizSplash extends StatelessWidget {
  const AfterQuizSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // Check icon
                    Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFFAAF308),
                      size: 100,
                    ),
                    SizedBox(height: 20),
                    // Title
                    Text(
                      "Quiz Complete!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Subtitle
                    Text(
                      "We're calculating your risk profile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add a little Spacer before button to move it slightly up
            const SizedBox(height: 20),

            // Green See Recommendations Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAAF308), // Green color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFAAF308).withOpacity(0.4),
                  ),
                  onPressed: () {
                    // Navigate to the recommendations page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RecommendationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "See Recommendations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black, // Black text on green button
                    ),
                  ),
                ),
              ),
            ),

            // Extra bottom padding for spacing from screen edge
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
