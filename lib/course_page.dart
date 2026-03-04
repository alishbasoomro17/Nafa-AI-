import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// --- YOUR ORIGINAL COLORS ---
const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

// --- DATA ---
final List<Map<String, String>> courseLessons = [
  {'title': 'Lesson 1: Introduction to Stock Market', 'video': 'assets/lesson1.mp4'},
  {'title': 'Lesson 2: Types of Stock Market & Basic Terms', 'video': 'assets/lesson2.mp4'},
  {'title': 'Lesson 3: How to make Stock Market Account', 'video': 'assets/lesson3.mp4'},
  {'title': 'Lesson 4: Which Company to Invest', 'video': 'assets/lesson4.mp4'},
  {'title': 'Lesson 5: Risk Management & Diversification', 'video': 'assets/lesson5.mp4'},
  {'title': 'Lesson 6: Fundamental & Technical Analysis', 'video': 'assets/lesson6.mp4'},
  {'title': 'Lesson 7: Investing Roadmap', 'video': 'assets/lesson7.mp4'},
];

class FinancialCoursePage extends StatefulWidget {
  const FinancialCoursePage({super.key});

  @override
  State<FinancialCoursePage> createState() => _FinancialCoursePageState();
}

class _FinancialCoursePageState extends State<FinancialCoursePage> {
  int selectedTab = 1;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _reviews = ["Very helpful for beginners."];

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

  void _openLesson(int index) {
    _playClickSound();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPlayerScreen(
          lessonIndex: index,
          lessons: courseLessons,
        ),
      ),
    );
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
            padding: const EdgeInsets.only(bottom: 70),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Finance badge removed as requested
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          if (selectedTab == 2)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white12,
                  border: Border(top: BorderSide(color: Colors.white24)),
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

  Widget _title() {
    return const Text("Stock 101 Beginner Course", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _meta() {
    return const Text("Beginner Friendly", style: TextStyle(color: Colors.white60));
  }

  Widget _instructor() {
    return const Row(
      children: [
        CircleAvatar(backgroundColor: purpleAccent, child: Icon(Icons.school, color: Colors.white)),
        SizedBox(width: 10),
        Text("Created by Nafa AI", style: TextStyle(color: Colors.white)),
      ],
    );
  }

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
            border: Border(bottom: BorderSide(color: active ? greenMain : Colors.transparent, width: 2)),
          ),
          child: Text(title, textAlign: TextAlign.center, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _tabView() {
    if (selectedTab == 0) return _aboutTab();
    if (selectedTab == 1) return _lessonsTab();
    return _reviewsTab();
  }

  Widget _aboutTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
      child: const Text("This course introduces the basic concepts of the stock market...", style: TextStyle(color: Colors.white70, height: 1.4)),
    );
  }

  Widget _lessonsTab() {
    return Column(children: List.generate(courseLessons.length, (index) => _lessonCard(index)));
  }

  Widget _lessonCard(int index) {
    final lesson = courseLessons[index];
    return GestureDetector(
      onTap: () => _openLesson(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: purpleAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(lesson['title']!, style: const TextStyle(color: Colors.white))),
            const Text("10:00", style: TextStyle(color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  Widget _reviewsTab() {
    return Column(
      children: _reviews.map((review) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(backgroundColor: purpleAccent, child: Icon(Icons.person, color: Colors.white, size: 16)),
              const SizedBox(width: 8),
              Expanded(child: Text(review, style: const TextStyle(color: Colors.white70))),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/* ---------------- UPDATED CLEAN FULL-SCREEN PLAYER ---------------- */

class LessonPlayerScreen extends StatefulWidget {
  final int lessonIndex;
  final List<Map<String, String>> lessons;

  const LessonPlayerScreen({super.key, required this.lessonIndex, required this.lessons});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.lessonIndex;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.lessons[currentIndex]['video']!);
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,

      // Hides the "Full Screen" button icon you circled
      allowFullScreen: false,

      // Hides the playback speed and other extra options
      allowMuting: true,
      showControls: true,

      aspectRatio: _videoPlayerController.value.aspectRatio,

      materialProgressColors: ChewieProgressColors(
        playedColor: greenMain,
        handleColor: greenMain,
        backgroundColor: Colors.white24,
        bufferedColor: purpleAccent,
      ),
      placeholder: const Center(child: CircularProgressIndicator(color: greenMain)),
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // SafeArea ensures the video doesn't hide behind notches
      body: SafeArea(
        child: Stack(
          children: [
            // 1. The Video Player
            Center(
              child: _chewieController != null && _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
                  : const CircularProgressIndicator(color: greenMain),
            ),

            // 2. Custom Back Button (Replaces the cross/appbar icon)
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}