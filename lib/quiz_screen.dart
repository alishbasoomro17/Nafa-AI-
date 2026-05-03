import 'package:flutter/material.dart';
import 'package:op/recommendations_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for sound
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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


Future<void> submitRisk(String riskCategory) async {
    print("Submitting risk category: $riskCategory");
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString("token");

    final userId = await getUserId();
    print("User ID for risk submission: $userId");

    try {
      final localUrl = dotenv.env['base_url_local'] ?? 'No API Key Found';
      final prodUrl = dotenv.env['base_url_production'] ?? 'No API Key Found';

      final response = await http.post(
        Uri.parse("$prodUrl/quiz/risk-update/$userId/$riskCategory"),
      );

      print("Risk Submission Status Code: ${response.statusCode}");
      print("Risk Submission Response: ${response.body}");
    } catch (e) {
      print("Error submitting risk category: $e");
    }
  }
//   Future<void> submitQuizToBackend() async {
//     print("pressed button");
//     print(submittedAnswers);
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     final userId = await getUserId();
//     print(userId);

//     try {
//       final local_url = dotenv.env['base_url_local'] ?? 'No API Key Found';
//       final prod_url = dotenv.env['base_url_production'] ?? 'No API Key Found';

//       final response = await http.post(
//         Uri.parse("$prod_url/quiz/submit-answers/$userId"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//        body: jsonEncode({
//   "answers": submittedAnswers,
//   "riskCategory": riskCategory,
// }), // MUST be array
//       );

//       print("Status Code: ${response.statusCode}");
//       print("Response: ${response.body}");

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Answers submitted successfully!")),
//         );
//         // parse response body for riskCategory

//         String riskCategory = '';
//         try {
//           final body = jsonDecode(response.body);
//           if (body is Map) {
//             riskCategory =
//                 (body['riskCategory'] ??
//                         body['risk'] ??
//                         body['category'] ??
//                         body['risk_category'] ??
//                         '')
//                     .toString();
//           }
//         } catch (e) {
//           print('Error parsing quiz response: $e');
//         }

//         // store riskCategory in SharedPreferences for later use
//         if (riskCategory.isNotEmpty) {
//           await prefs.setString('riskCategory', riskCategory);
//         }
//         // store full response body for recommendations use
//         await prefs.setString('quiz_result_body', response.body);

//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => RecommendationScreen(riskCategory: riskCategory),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
//       }
//     } catch (e) {
//       print("EXCEPTION: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error sending answers: $e")));
//     }
//   }

final Map<int, Map<String, dynamic>> scoring = {
  1: {"scores": [1, 2, 3, 4], "weight": 1.5},
  2: {"scores": [1, 2, 3, 4], "weight": 1.5},
  3: {"scores": [1, 2, 3, 4, 5], "weight": 1.0},
  4: {"scores": [1, 2, 3, 4, 5], "weight": 1.5},
  5: {"scores": [1, 2, 3, 4], "weight": 1.2},
  6: {"scores": [1, 2, 3, 4], "weight": 1.2},
  7: {"scores": [1, 2, 3, 4], "weight": 1.2},
  8: {"scores": [1, 2, 3], "weight": 1.0},
  9: {"scores": [1, 2, 3, 4], "weight": 1.0},
  10: {"scores": [1, 2, 3, 4], "weight": 1.5},
};
 
 final List<Map<String, dynamic>> questions = [
  {
    "questionId": 1,
    "questionText": "After paying your household expenses and loan installments, how much of your monthly income typically remains?",
    "options": [
      "Nothing or I run short",
      "Less than 20% remains",
      "Around 20–40% remains",
      "More than 40% remains",
    ],
  },
  {
    "questionId": 2,
    "questionText": "How stable is your primary source of income?",
    "options": [
      "Very unstable or irregular",
      "Somewhat unstable",
      "Stable salaried income",
      "Very stable with multiple income sources",
    ],
  },
  {
    "questionId": 3,
    "questionText": "What is your investment objective?",
    "options": [
      "Preserve capital (avoid losses)",
      "Generate regular income",
      "Balance income and growth",
      "Grow wealth over time",
      "Maximize long-term growth (accept high volatility)",
    ],
  },
  {
    "questionId": 4,
    "questionText": "I plan to begin taking money from my investments in:",
    "options": [
      "Less than 1 year",
      "1–3 years",
      "4–6 years",
      "7–10 years",
      "More than 10 years",
    ],
  },
  {
    "questionId": 5,
    "questionText": "Today, how much do you rely on income from your investments?",
    "options": [
      "Heavily",
      "Moderately",
      "Slightly",
      "Not at all",
    ],
  },
  {
    "questionId": 6,
    "questionText": "How would you feel if your investments dropped 10% in one month?",
    "options": [
      "Very worried – I would sell immediately",
      "A little concerned, but I would wait",
      "Not very concerned – I understand markets fluctuate",
      "Not concerned at all – short-term drops do not affect me",
    ],
  },
  {
    "questionId": 7,
    "questionText": "If your investments lost 20% of their value in a few days, how would you react?",
    "options": [
      "Sell all investments and move to cash",
      "Shift to more conservative investments",
      "Wait and review after some time",
      "Invest more to take advantage of lower prices",
    ],
  },
  {
    "questionId": 8,
    "questionText": "Which investment would you prefer?",
    "options": [
      "Low returns with minimal or no risk",
      "Moderate returns with some risk",
      "High returns with significant risk",
    ],
  },
  {
    "questionId": 9,
    "questionText": "What is your level of investment experience?",
    "options": [
      "No experience",
      "Basic (e.g., savings accounts, prize bonds)",
      "Moderate (e.g., mutual funds, occasional stock investing)",
      "Advanced (active investing/trading experience)",
    ],
  },
  {
    "questionId": 10,
    "questionText": "How much emergency savings do you have (in terms of monthly expenses)?",
    "options": [
      "None",
      "Less than 3 months",
      "3–6 months",
      "More than 6 months",
    ],
  },
];
  
  String calculateRisk() {
  double totalScore = 0;

  for (var answer in submittedAnswers) {
    int qId = answer["questionId"];
    String selected = answer["quizAnswer"];

    final question = questions.firstWhere(
      (q) => q["questionId"] == qId,
    );

    int optionIndex = question["options"].indexOf(selected);

    int score = scoring[qId]!["scores"][optionIndex];
    double weight = scoring[qId]!["weight"];

    totalScore += score * weight;
  }

  print("TOTAL SCORE: $totalScore");

  if (totalScore <= 25) return "Low";
  if (totalScore <= 40) return "Moderate";
  return "High";
}
  
  
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
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                          children: currentQuestion["options"].map<Widget>((
                            option,
                          ) {
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
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
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
                                        color: const Color(
                                          0xFFAAF308,
                                        ).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white70,
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
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
    : () async {
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

          String riskCategory = calculateRisk();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('riskCategory', riskCategory);
          submitRisk(riskCategory);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RecommendationScreen(riskCategory: riskCategory),
            ),
          );
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
