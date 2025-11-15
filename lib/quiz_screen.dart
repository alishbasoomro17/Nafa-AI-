import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Added for sound

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      "questionId": 1,
      "questionText": "What is your age group?",
      "options": [
        "Under 18",
        "18–24",
        "25–34",
        "35–44",
        "45 and above",
      ],
    },
    {
      "questionId": 2,
      "questionText": "What is your primary investment goal?",
      "options": [
        "Short-term profits",
        "Long-term wealth",
        "Retirement planning",
        "Education fund",
        "Not sure yet",
      ],
    },
    {
      "questionId": 3,
      "questionText": "How much experience do you have in investing?",
      "options": [
        "None",
        "Beginner",
        "Intermediate",
        "Expert",
      ],
    },
    {
      "questionId": 5,
      "questionText": "Which type of investments interest you the most?",
      "options": [
        "Stocks",
        "Mutual Funds",
        "Crypto",
        "Real Estate",
        "Bonds",
      ],
    },
  ];

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
                        : () {
                      if (currentIndex < questions.length - 1) {
                        setState(() {
                          currentIndex++;
                          selectedOption = null;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Quiz completed! Welcome to Nafa AI 🎉"),
                            backgroundColor: Color(0xFF6E4BD8),
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
