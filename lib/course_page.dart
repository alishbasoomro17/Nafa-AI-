import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';

const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);
const Color darkCard = Color(0xFF1A1A1A);

class FinancialCoursePage extends StatefulWidget {
  const FinancialCoursePage({super.key});

  @override
  State<FinancialCoursePage> createState() => _FinancialCoursePageState();
}

class _FinancialCoursePageState extends State<FinancialCoursePage> {
  int selectedTab = 1;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> lessons = [
    {"title": "What is the Stock Market?", "asset": "assets/lesson1.mp4"},
    {"title": "Types of Stocks aur Shares", "asset": "assets/lesson2.mp4"},
    {"title": "Stock price kese move karte hain", "asset": "assets/lesson3.mp4"},
    {"title": "Risk & Return Basics", "asset": "assets/lesson4.mp4"},
    {"title": "What is diversification?", "asset": "assets/lesson5.mp4"},
     {"title": "Stock market mein sabr aur sahi faisle", "asset": "assets/lesson6.mp4"},
      {"title": "Stock market mein long term investing vs short term", "asset": "assets/lesson7.mp4"},
  ];

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (_) {}
  }

  void _openLesson(BuildContext context, int index) {
    _playClickSound();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonPlayerPage(
          lessonNumber: index + 1,
          title: lessons[index]["title"]!,
          assetPath: lessons[index]["asset"]!,
          allLessons: lessons,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const BackButton(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.5,
            colors: [Color(0xFF121212), Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              const SizedBox(height: 8),
              _meta(),
              const SizedBox(height: 24),
              _instructor(),
              const SizedBox(height: 32),
              _tabs(),
              const SizedBox(height: 24),
              _tabView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Stock 101\nBeginner Course",
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        height: 1.1,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _meta() {
    return Row(
      children: [
        const Icon(Icons.bolt, color: greenMain, size: 16),
        const SizedBox(width: 4),
        const Text(
          "Beginner Friendly • 5 Lessons",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _instructor() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: purpleAccent,
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
              SizedBox(width: 12),
              Text(
                "Created by Nafa AI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabItem("Overview", 0),
          _tabItem("Lessons", 1),
        ],
      ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? greenMain : Colors.white,
              fontSize: 14,
              fontWeight: active ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabView(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: selectedTab == 0 ? _aboutTab() : _lessonsTab(context),
    );
  }

  Widget _aboutTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Text(
        "This course introduces the basic concepts of the stock market. You will learn key terms and definitions such as stocks, shares, market types, risk, and investment fundamentals.",
        style: TextStyle(
          color: Colors.white,
          height: 1.6,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _lessonsTab(BuildContext context) {
    return Column(
      children: lessons.asMap().entries.map((entry) {
        return _lessonCard(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _lessonCard(
      BuildContext context, int index, Map<String, String> lesson) {
    final int number = index + 1;
    return GestureDetector(
      onTap: () => _openLesson(context, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: purpleAccent.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    purpleAccent.withOpacity(0.5),
                    purpleAccent.withOpacity(0.2)
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: greenMain, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MODULE 0$number",
                    style: const TextStyle(
                        color: purpleAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LESSON PLAYER PAGE
// ─────────────────────────────────────────────

class LessonPlayerPage extends StatefulWidget {
  final int lessonNumber;
  final String title;
  final String assetPath;
  final List<Map<String, String>> allLessons;

  const LessonPlayerPage({
    super.key,
    required this.lessonNumber,
    required this.title,
    required this.assetPath,
    required this.allLessons,
  });

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initVideo(widget.assetPath);
  }

  void _initVideo(String path) {
    _controller = VideoPlayerController.asset(path)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
        }
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _navigateToLesson(BuildContext context, int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LessonPlayerPage(
          lessonNumber: index + 1,
          title: widget.allLessons[index]["title"]!,
          assetPath: widget.allLessons[index]["asset"]!,
          allLessons: widget.allLessons,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const BackButton(color: Colors.white),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MODULE 0${widget.lessonNumber}",
              style: const TextStyle(
                  color: purpleAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2),
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.5,
            colors: [Color(0xFF121212), Colors.black],
          ),
        ),
        child: Column(
          children: [
            // ── VIDEO PLAYER ──────────────────────────────
            _videoSection(),

            // ── LESSON LIST ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Up Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.allLessons.asMap().entries.map((entry) {
                      final isActive =
                          entry.key + 1 == widget.lessonNumber;
                      return _lessonCard(context, entry.key, entry.value,
                          isActive);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoSection() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        margin: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: purpleAccent.withOpacity(0.25),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video or loading background
                if (_isInitialized)
                  VideoPlayer(_controller)
                else
                  Container(color: const Color(0xFF0D0D0D)),

                // Loading indicator
                if (!_isInitialized)
                  const CircularProgressIndicator(
                    color: greenMain,
                    strokeWidth: 2.5,
                  ),

                // Overlay controls
                if (_isInitialized && _showControls)
                  _videoOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoOverlay() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    final progress =
        duration.inMilliseconds > 0 ? position.inMilliseconds / duration.inMilliseconds : 0.0;

    return Container(
      color: Colors.black.withOpacity(0.45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          // Play/pause button
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 1.5),
              ),
              child: Icon(
                _controller.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: greenMain,
                size: 40,
              ),
            ),
          ),
          // Bottom progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                // Custom slim progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(greenMain),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(position),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lessonCard(BuildContext context, int index,
      Map<String, String> lesson, bool isActive) {
    final int number = index + 1;
    return GestureDetector(
      onTap: isActive ? null : () => _navigateToLesson(context, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? purpleAccent.withOpacity(0.15)
              : darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? purpleAccent
                : purpleAccent.withOpacity(0.4),
            width: isActive ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [purpleAccent, purpleAccent.withOpacity(0.6)]
                      : [
                          purpleAccent.withOpacity(0.5),
                          purpleAccent.withOpacity(0.2)
                        ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: greenMain,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MODULE 0$number",
                    style: TextStyle(
                      color: isActive ? greenMain : purpleAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson["title"]!,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: greenMain.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: greenMain.withOpacity(0.4)),
                ),
                child: const Text(
                  "Playing",
                  style: TextStyle(
                      color: greenMain,
                      fontSize: 11,
                      fontWeight: FontWeight.w800),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded,
                  color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }
}