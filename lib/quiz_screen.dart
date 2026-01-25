import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'After_Quiz_Splash.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> submittedAnswers = [];
  int currentIndex = 0;
  String? selectedOption;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> questions = [
    {
      "questionId": 1,
      "questionText": "What is your primary investment goal?",
      "options": [
        "Preserve capital with minimal risk",
        "Generate steady income",
        "Achieve balanced growth",
        "Maximize long-term capital growth"
      ]
    },
    {
      "questionId": 2,
      "questionText": "How long do you plan to keep this money invested?",
      "options": ["Less than 1 year", "1–3 years", "3–5 years", "More than 5 years"]
    },
    {
      "questionId": 3,
      "questionText": "How comfortable are you with fluctuations in investment value?",
      "options": [
        "Not comfortable with losses",
        "Slightly uncomfortable",
        "Comfortable with moderate fluctuations",
        "Comfortable with significant fluctuations"
      ]
    },
    {
      "questionId": 4,
      "questionText": "If your portfolio declines by 20% in a short period, what would you most likely do?",
      "options": [
        "Exit investments to prevent further loss",
        "Reduce exposure",
        "Hold and wait for recovery",
        "Increase investment at lower valuations"
      ]
    },
    {
      "questionId": 5,
      "questionText": "How would you describe your current financial position?",
      "options": [
        "Unstable with high financial obligations",
        "Stable but with limited savings",
        "Stable with sufficient savings",
        "Very stable with strong financial reserves"
      ]
    },
    {
      "questionId": 6,
      "questionText": "Do you have an emergency fund covering at least 3–6 months of expenses?",
      "options": ["No", "Partially", "Yes"]
    },
    {
      "questionId": 7,
      "questionText": "What best describes your investment experience?",
      "options": ["No prior experience", "Limited experience", "Moderate experience", "Extensive experience"]
    },
    {
      "questionId": 8,
      "questionText": "How do you typically make investment decisions?",
      "options": [
        "Rely on tips or market sentiment",
        "Basic personal judgment",
        "Structured analysis",
        "Data-driven and disciplined strategy"
      ]
    },
    {
      "questionId": 9,
      "questionText": "What portion of your assets are you comfortable allocating to stocks?",
      "options": ["Less than 30%", "30–50%", "50–70%", "More than 70%"]
    },
    {
      "questionId": 10,
      "questionText": "How do you generally feel during prolonged market volatility?",
      "options": ["Highly anxious", "Somewhat anxious", "Neutral", "Calm and confident"]
    },
  ];

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return null;
    final decoded = JwtDecoder.decode(token);
    return decoded["id"]?.toString();
  }

  Future<void> submitQuizToBackend() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = await getUserId();

    if (userId == null || token == null) return;

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:3000/quiz/submit-answers/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(submittedAnswers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Answers submitted successfully");
      } else {
        print("Failed: ${response.body}");
      }
    } catch (e) {
      print("Error sending answers: $e");
    }
  }

  void _playOptionSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final currentQuestion = questions[currentIndex];

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
      // Navigate immediately
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AfterQuizSplash()),
      );
      // Submit answers in background
      submitQuizToBackend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentIndex];
    final double progress = (currentIndex + 1) / questions.length;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress Bar
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
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Question Text
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

                        // Options
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: currentQuestion["options"].map<Widget>((option) {
                            final isSelected = selectedOption == option;
                            return GestureDetector(
                              onTap: () {
                                _playOptionSound();
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

              // Next / Finish Button
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
                    onPressed: selectedOption == null ? null : _onNextPressed,
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
