import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

class FinancialCoursePage extends StatefulWidget {
  const FinancialCoursePage({super.key});

  @override
  State<FinancialCoursePage> createState() => _FinancialCoursePageState();
}

class _FinancialCoursePageState extends State<FinancialCoursePage> {
  int selectedTab = 1; // 0 = About, 1 = Lessons, 2 = Reviews
  final AudioPlayer _audioPlayer = AudioPlayer();

  final TextEditingController _reviewController = TextEditingController();
  final List<String> _reviews = [
    "Very helpful for beginners.",
  ];

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (_) {}
  }

  void _addReview() {
    final reviewText = _reviewController.text.trim();
    if (reviewText.isNotEmpty) {
      setState(() {
        _reviews.add(reviewText);
        _reviewController.clear();
      });
      _playClickSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70), // Space for input
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _badge(),
                  const SizedBox(height: 12),
                  _title(),
                  const SizedBox(height: 6),
                  _meta(),
                  const SizedBox(height: 14),
                  _instructor(),
                  const SizedBox(height: 24),
                  _tabs(),
                  const SizedBox(height: 16),
                  _tabView(),
                  const SizedBox(height: 80), // Extra padding to prevent overlap
                ],
              ),
            ),
          ),

          // Bottom input field only in Reviews tab
          if (selectedTab == 2)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  border: const Border(
                    top: BorderSide(color: Colors.white24),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: purpleAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _reviewController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Write a review...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: greenMain),
                      onPressed: _addReview,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /* ---------------- HEADER ---------------- */

  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [purpleAccent, Colors.deepPurple],
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Stock 101 Beginner Course",
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _meta() {
    return const Text(
      "Beginner Friendly",
      style: TextStyle(color: Colors.white60),
    );
  }

  Widget _instructor() {
    return const Row(
      children: [
        CircleAvatar(
          backgroundColor: purpleAccent,
          child: Icon(Icons.school, color: Colors.white),
        ),
        SizedBox(width: 10),
        Text(
          "Created by Nafa AI",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  /* ---------------- TABS ---------------- */

  Widget _tabs() {
    return Row(
      children: [
        _tabItem("What you'll learn", 0),
        _tabItem("Course content", 1),
        _tabItem("Reviews", 2),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    final bool active = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _playClickSound();
          setState(() => selectedTab = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? greenMain : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.white54,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /* ---------------- TAB CONTENT ---------------- */

  Widget _tabView() {
    if (selectedTab == 0) return _aboutTab();
    if (selectedTab == 1) return _lessonsTab();
    return _reviewsTab();
  }

  /* ---------------- ABOUT ---------------- */

  Widget _aboutTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "This course introduces the basic concepts of the stock market. Youwill learn key terms and definitions such as stocks, shares, market types, risk, returns, and investment fundamentals. It explains how the stock market works and how prices move, using simple theory and examples. The course is designed only to build understanding and does not require any prior financial knowledge. ",
        style: TextStyle(color: Colors.white70, height: 1.4),
      ),
    );
  }

  /* ---------------- LESSONS ---------------- */

  Widget _lessonsTab() {
    return Column(
      children: List.generate(7, (index) {
        return _lessonCard("Lesson ${index + 1}");
      }),
    );
  }

  Widget _lessonCard(String title) {
    return GestureDetector(
      onTap: _playClickSound,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline,
                color: purpleAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Text("--:--", style: TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  /* ---------------- REVIEWS ---------------- */

  Widget _reviewsTab() {
    return Column(
      children: _reviews.map((review) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: purpleAccent,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
