import 'package:flutter/material.dart';
import 'package:op/recommendations_screen.dart';
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
      "questionText": " What is your major investment objective? ",
      "options": [
       "Preserve my capital with steady, low-risk returns." ,
" Achieve moderate growth, accepting short-term declines ",
"Pursue higher returns even with significant volatility. ",
      ]
    },
    {
      "questionId": 2,
      "questionText": " What is your intended investment time frame? ",
      "options": [
        "Short-term (under 3 years) for quick growth",
        "Medium-term (3 to 10 years)",
        "Long-term (over 10 years) for high returns"
      ]
    },
    {
      "questionId": 3,
      "questionText": "How important is access to your invested funds (liquidity)?",
      "options": [
        "Very important: I may need to withdraw a significant portion within 1–2 years",
        "Moderately important: I may need partial access if required, but not urgently",
        "Low importance: I do not expect to need these funds for several years",
        "Not a concern: I can remain fully invested for the long term without liquidity needs"
      ]
    },
    {
      "questionId": 4,
      "questionText": "What is your primary financial goal in investment?",
      "options": [
        "Wealth Preservation ",
" Building an Emergency Fund ",
" Saving for a Major Purchase ",
" Paying Off Debt ",
"  Education Funding for Children ",
"  Retirement planning ",
" Build long term wealth"

      ]
    },
    {
      "questionId": 5,
      "questionText": "If the stock market declines by 25% in a short period and the value of your investment falls from PKR 10,000 to PKR 7,500, how would you most likely respond? ",
      "options": [
         "Would sell all my stocks to avoid further losses, as capital preservation is my priority.",
         "I would wait for the investment to recover to my original amount and then sell, even if it takes time.",
         "I would sell stocks that have declined significantly and retain relatively stable holdings.",
         "I would remain invested, closely monitor the market, and avoid selling, as I believe short-term declines are part of long-term growth.",
" I would consider investing additional funds to take advantage of lower prices, viewing market downturns as long-term opportunities. "
      ]
    },
    {
      "questionId": 6,
      "questionText": "How does your domestic debt compare to your monthly income? ",
      "options": ["No debt at all ", "Low debt (under half of monthly income) ", "Moderate debt (around half) ", "High debt (more than monthly income)"]
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

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answers submitted successfully!")),
        );
        // parse response body for riskCategory
   
        String riskCategory = '';
        try {
          final body = jsonDecode(response.body);
          if (body is Map) {
            riskCategory = (body['riskCategory'] ?? body['risk'] ?? body['category'] ?? body['risk_category'] ?? '').toString();
          }
        } catch (e) {
          print('Error parsing quiz response: $e');
        }

        // store riskCategory in SharedPreferences for later use
        if (riskCategory.isNotEmpty) {
          await prefs.setString('riskCategory', riskCategory);
        }
        // store full response body for recommendations use
        await prefs.setString('quiz_result_body', response.body);
        if (!mounted) return;

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => RecommendationScreen( riskCategory: riskCategory)),
          );
        });
      } else {
        print("Failed: ${response.body}");
      }
    } catch (e) {
      print("Error sending answers: $e");
      if (!mounted) return;
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

  Future<void> _onNextPressed() async {
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
        MaterialPageRoute(builder: (context) =>const  AfterQuizSplash()),
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
                                    fontSize: 9,
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
