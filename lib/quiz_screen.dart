import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'after_quiz_splash.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> submittedAnswers = [];
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) return null;

    final decoded = JwtDecoder.decode(token);

    // Assuming NestJS stored userId as "sub"
    return decoded["id"]?.toString();
  }

  Future<void> submitQuizToBackend() async {
    print("pressed button");
    print(submittedAnswers);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final userId = await getUserId();
    print(userId);

    // --- Start Navigation Logic ---
    // A future to hold the result of the navigation
    Future<void> navigateAfterSubmission;

    // Check if we are on the last question before submitting
    if (currentIndex == questions.length - 1) {
      // Prepare navigation *before* the API call, so we can use `await` on the API call
      // and navigate immediately after the API call completes.
      navigateAfterSubmission = Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AfterQuizSplash(),
        ),
      );
    } else {
      // If somehow this is called before the last question, do nothing.
      navigateAfterSubmission = Future.value();
    }
    // --- End Navigation Logic ---


    try
    {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:3000/quiz/submit-answers/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(submittedAnswers), // MUST be array
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answers submitted successfully!")),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.body}")),
        );
      }
    } catch (e) {
      print("EXCEPTION: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending answers: $e")),
      );
    }

    // Now navigate to the splash screen.
    // We are using `pushReplacement` so the user cannot go back to the quiz.
    await navigateAfterSubmission;
  }

  final List<Map<String, dynamic>> questions =
  [
    {
      "questionId": 1,
      "questionText": "What is my primary investment goal right now?",
      "options": [
        "Capital preservation",
        "Steady income",
        "Moderate growth",
        "High growth",
        "Aggressive speculation"
      ]
    },
    {
      "questionId": 2,
      "questionText": "What is my time horizon for using the money I plan to invest?",
      "options": [
        "Less than 1 year",
        "1–3 years",
        "4–7 years",
        "8–15 years",
        "More than 15 years"
      ]
    },
    {
      "questionId": 3,
      "questionText": "How comfortable am I with short-term fluctuations in my portfolio value?",
      "options": [
        "Not comfortable at all",
        "Slightly uncomfortable",
        "Neutral",
        "Comfortable",
        "Very comfortable"
      ]
    },
    {
      "questionId": 4,
      "questionText": "How would I react if my investments dropped 20% in a few months?",
      "options": [
        "Sell everything to avoid more losses",
        "Sell some to reduce risk",
        "Hold and wait",
        "Buy more at lower price"
      ]
    },
    {
      "questionId": 5,
      "questionText": "How would I describe my current financial stability?",
      "options": [
        "Unstable with high liabilities",
        "Somewhat stable but stressed",
        "Stable",
        "Very stable with low liabilities",
        "Extremely stable with strong savings"
      ]
    },
    {
      "questionId": 6,
      "questionText": "Do I have an emergency fund covering at least 3–6 months of expenses?",
      "options": [
        "No",
        "Partially",
        "Yes"
      ]
    },
    {
      "questionId": 7,
      "questionText": "How much does this investment amount matter to my overall net worth?",
      "options": [
        "Critical portion",
        "Large portion",
        "Moderate portion",
        "Small portion",
        "Very small portion"
      ]
    },
    {
      "questionId": 8,
      "questionText": "How would I rate my knowledge of stock investing?",
      "options": [
        "None",
        "Basic",
        "Intermediate",
        "Advanced",
        "Expert"
      ]
    },
    {
      "questionId": 9,
      "questionText": "Which investment products am I comfortable using?",
      "options": [
        "Savings accounts",
        "Mutual funds / ETFs",
        "Individual stocks",
        "Options / Futures",
        "Margin or leveraged products"
      ]
    },
    {
      "questionId": 10,
      "questionText": "How many years of experience do I have actively investing?",
      "options": [
        "0 years",
        "Less than 1 year",
        "1–3 years",
        "4–7 years",
        "More than 7 years"
      ]
    },
    {
      "questionId": 11,
      "questionText": "How often do I monitor my portfolio?",
      "options": [
        "Multiple times a day",
        "Daily",
        "Weekly",
        "Monthly",
        "Rarely"
      ]
    },
    {
      "questionId": 12,
      "questionText": "How do I typically make investment decisions?",
      "options": [
        "Following tips or influencers",
        "Impulsive decisions",
        "Basic research",
        "Detailed analysis",
        "Highly structured research process"
      ]
    },
    {
      "questionId": 13,
      "questionText": "How do I feel emotionally when markets drop sharply?",
      "options": [
        "Very anxious",
        "Somewhat anxious",
        "Neutral",
        "Calm",
        "Unbothered"
      ]
    },
    {
      "questionId": 14,
      "questionText": "If a single stock in my portfolio drops 50%, what is my likely action?",
      "options": [
        "Sell immediately",
        "Sell part of it",
        "Hold and wait",
        "Buy more",
        "Re-evaluate based on fundamentals"
      ]
    },
    {
      "questionId": 15,
      "questionText": "How dependent am I on this invested money for short-term needs?",
      "options": [
        "Highly dependent",
        "Somewhat dependent",
        "Not very dependent",
        "Not dependent at all"
      ]
    },
    {
      "questionId": 16,
      "questionText": "How would I rate my ability to handle financial losses?",
      "options": [
        "Cannot tolerate losses",
        "Very low tolerance",
        "Moderate tolerance",
        "High tolerance",
        "Very high tolerance"
      ]
    },
    {
      "questionId": 17,
      "questionText": "What percentage of my assets am I comfortable allocating to stocks?",
      "options": [
        "0–20%",
        "21–40%",
        "41–60%",
        "61–80%",
        "81–100%"
      ]
    },
    {
      "questionId": 18,
      "questionText": "How likely am I to follow friends, social media, or hype when investing?",
      "options": [
        "Very likely",
        "Somewhat likely",
        "Neutral",
        "Unlikely",
        "Never"
      ]
    },
    {
      "questionId": 19,
      "questionText": "How would I react if markets stayed volatile for a long period?",
      "options": [
        "Panic and exit the market",
        "Gradually reduce exposure",
        "Stay invested with no changes",
        "Increase exposure to capture opportunities"
      ]
    },
    {
      "questionId": 20,
      "questionText": "What motivates me most to invest in stocks?",
      "options": [
        "Fear of losing money elsewhere",
        "Need income",
        "Desire for long-term growth",
        "Desire to beat the market",
        "Desire for fast high returns"
      ]
    }
  ]
  ;

  int currentIndex = 0;
  String? selectedOption;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance

  // ----- Play sound on option click -----
  void _playOptionSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  // Dispose of the audio player when the widget is removed
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / questions.length;
    final currentQuestion = questions[currentIndex];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 🔹 Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF6E4BD8),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Question ${currentIndex + 1} of ${questions.length}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔹 Question Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentQuestion["questionText"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: currentQuestion["options"].map<Widget>((option) {
                            final isSelected = selectedOption == option;
                            return GestureDetector(
                              onTap: () {
                                _playOptionSound(); // Play sound on option click
                                setState(() {
                                  selectedOption = option;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                width: size.width * 0.8,
                                height: 55,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFAAF308)
                                      : const Color(0xFF1E1E2A),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFAAF308)
                                        : Colors.white10,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: const Color(0xFFAAF308).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.black : Colors.white70,
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 Next / Finish button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E4BD8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFAAF308).withOpacity(0.4),
                    ),
                    onPressed: selectedOption == null
                        ? null
                        : () async { // Changed to async to await API call and navigation
                      // Save current question answer
                      submittedAnswers.add({
                        "questionId": currentQuestion["questionId"],
                        "questionText": currentQuestion["questionText"],
                        "quizAnswer": selectedOption,
                      });

                      if (currentIndex < questions.length - 1) {
                        setState(() {
                          currentIndex++;
                          selectedOption = null;
                        });
                      } else {
                        print("Submitted Answers: $submittedAnswers");
                        await submitQuizToBackend(); // Await API call and navigation
                      }
                    },

                    child: Text(
                      currentIndex == questions.length - 1 ? "Finish" : "Next",
                      style: const TextStyle(
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
      ),
    );
  }
}