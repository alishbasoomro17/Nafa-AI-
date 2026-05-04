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
  int selectedTab = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (_) {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> lessons = [
    {
      "title": "What is the Stock Market?",
      "duration": "6 min",
      "desc": "Learn the basics of what a stock market is and why it exists.",
    },
    {
      "title": "What are Stocks & Shares?",
      "duration": "5 min",
      "desc": "Understand ownership, shares, and how companies raise capital.",
    },
    {
      "title": "How Stock Prices Move",
      "duration": "7 min",
      "desc": "Discover supply, demand, and what causes price changes.",
    },
    {
      "title": "Types of Investors",
      "duration": "5 min",
      "desc": "Retail vs institutional investors and their roles.",
    },
    {
      "title": "Risk & Return",
      "duration": "6 min",
      "desc": "The core trade-off every investor must understand.",
    },
    {
      "title": "Building a Portfolio",
      "duration": "8 min",
      "desc": "Diversification, asset classes, and balancing risk.",
    },
    {
      "title": "Getting Started",
      "duration": "7 min",
      "desc": "Your first steps to investing safely and smartly.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _courseHeader(),
                  const SizedBox(height: 24),
                  _tabRow(),
                  const SizedBox(height: 20),
                  _tabContent(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ---------------- APP BAR ---------------- */

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF0A0A0F),
      leading: GestureDetector(
        onTap: () {
          _playClickSound();
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                purpleAccent.withOpacity(0.8),
                const Color(0xFF0A0A0F),
              ],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 90, 20, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Stock 101\nBeginner Course",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ---------------- HEADER ---------------- */

  Widget _courseHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Created by Shehnila Narejo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          "Certified Financial Educator",
          style: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }

  /* ---------------- TABS ---------------- */

  Widget _tabRow() {
    final tabs = ["About", "Lessons"];

    return Row(
      children: List.generate(tabs.length, (i) {
        final active = selectedTab == i;

        return GestureDetector(
          onTap: () {
            _playClickSound();
            setState(() => selectedTab = i);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: active ? purpleAccent : Colors.white10,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                color: active ? Colors.white : Colors.white54,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _tabContent() {
    return selectedTab == 0 ? _aboutTab() : _lessonsTab();
  }

  /* ---------------- ABOUT TAB (FIXED) ---------------- */

  Widget _aboutTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        "This course introduces stock market basics in a simple way.\n\n"
        "You will learn how stocks work, how prices move, risk vs return, "
        "and how to start investing safely.",
        style: TextStyle(color: Colors.white70, height: 1.6),
      ),
    );
  }

  /* ---------------- LESSONS ---------------- */

  Widget _lessonsTab() {
    return Column(
      children: List.generate(lessons.length, (index) {
        final lesson = lessons[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: purpleAccent,
                child: Text("${index + 1}"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson["title"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      lesson["desc"],
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                lesson["duration"],
                style: const TextStyle(color: greenMain),
              ),
            ],
          ),
        );
      }),
    );
  }
}





















// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// const Color greenMain = Color(0xFFAAF308);
// const Color purpleAccent = Color(0xFF6E4BD8);

// class FinancialCoursePage extends StatefulWidget {
//   const FinancialCoursePage({super.key});

//   @override
//   State<FinancialCoursePage> createState() => _FinancialCoursePageState();
// }

// class _FinancialCoursePageState extends State<FinancialCoursePage> {
//   int selectedTab = 1; // 0 = About, 1 = Lessons, 2 = Reviews
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final TextEditingController _reviewController = TextEditingController();
//   final List<String> _reviews = [
//     "Very helpful for beginners.",
//   ];

//   void _playClickSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('success.mp3'));
//     } catch (_) {}
//   }

//   void _addReview() {
//     final reviewText = _reviewController.text.trim();
//     if (reviewText.isNotEmpty) {
//       setState(() {
//         _reviews.add(reviewText);
//         _reviewController.clear();
//       });
//       _playClickSound();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: const BackButton(color: Colors.white),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 70), // Space for input
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _badge(),
//                   const SizedBox(height: 12),
//                   _title(),
//                   const SizedBox(height: 6),
//                   _meta(),
//                   const SizedBox(height: 14),
//                   _instructor(),
//                   const SizedBox(height: 24),
//                   _tabs(),
//                   const SizedBox(height: 16),
//                   _tabView(),
//                   const SizedBox(height: 80), // Extra padding to prevent overlap
//                 ],
//               ),
//             ),
//           ),

//           // Bottom input field only in Reviews tab
//           if (selectedTab == 2)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white12,
//                   border: const Border(
//                     top: BorderSide(color: Colors.white24),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       backgroundColor: purpleAccent,
//                       child: Icon(Icons.person, color: Colors.white),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextField(
//                         controller: _reviewController,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: "Write a review...",
//                           hintStyle: TextStyle(color: Colors.white54),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send, color: greenMain),
//                       onPressed: _addReview,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   /* ---------------- HEADER ---------------- */

//   Widget _badge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         gradient: const LinearGradient(
//           colors: [purpleAccent, Colors.deepPurple],
//         ),
//       ),
//     );
//   }

//   Widget _title() {
//     return const Text(
//       "Stock 101 Beginner Course",
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 22,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _meta() {
//     return const Text(
//       "Beginner Friendly",
//       style: TextStyle(color: Colors.white60),
//     );
//   }

//   Widget _instructor() {
//     return const Row(
//       children: [
//         CircleAvatar(
//           backgroundColor: purpleAccent,
//           child: Icon(Icons.school, color: Colors.white),
//         ),
//         SizedBox(width: 10),
//         Text(
//           "Created by Nafa AI",
//           style: TextStyle(color: Colors.white),
//         ),
//       ],
//     );
//   }

//   /* ---------------- TABS ---------------- */

//   Widget _tabs() {
//     return Row(
//       children: [
//         _tabItem("What you'll learn", 0),
//         _tabItem("Course content", 1),
//         _tabItem("Reviews", 2),
//       ],
//     );
//   }

//   Widget _tabItem(String title, int index) {
//     final bool active = selectedTab == index;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           _playClickSound();
//           setState(() => selectedTab = index);
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: active ? greenMain : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//           ),
//           child: Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: active ? Colors.white : Colors.white54,
//               fontWeight: active ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /* ---------------- TAB CONTENT ---------------- */

//   Widget _tabView() {
//     if (selectedTab == 0) return _aboutTab();
//     if (selectedTab == 1) return _lessonsTab();
//     return _reviewsTab();
//   }

//   /* ---------------- ABOUT ---------------- */

//   Widget _aboutTab() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white10,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: const Text(
//         "This course introduces the basic concepts of the stock market. Youwill learn key terms and definitions such as stocks, shares, market types, risk, returns, and investment fundamentals. It explains how the stock market works and how prices move, using simple theory and examples. The course is designed only to build understanding and does not require any prior financial knowledge. ",
//         style: TextStyle(color: Colors.white70, height: 1.4),
//       ),
//     );
//   }

//   /* ---------------- LESSONS ---------------- */

//   Widget _lessonsTab() {
//     return Column(
//       children: List.generate(7, (index) {
//         return _lessonCard("Lesson ${index + 1}");
//       }),
//     );
//   }

//   Widget _lessonCard(String title) {
//     return GestureDetector(
//       onTap: _playClickSound,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white12,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.play_circle_outline,
//                 color: purpleAccent, size: 28),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             const Text("--:--", style: TextStyle(color: Colors.white38)),
//           ],
//         ),
//       ),
//     );
//   }

//   /* ---------------- REVIEWS ---------------- */

//   Widget _reviewsTab() {
//     return Column(
//       children: _reviews.map((review) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: Colors.white10,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CircleAvatar(
//                 backgroundColor: purpleAccent,
//                 child: Icon(Icons.person, color: Colors.white, size: 16),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   review,
//                   style: const TextStyle(color: Colors.white70),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }