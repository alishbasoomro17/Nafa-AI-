
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:op/AllStockScreen.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'GuidelinesPage.dart';
import 'course_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Sound error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _playSound();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              "Aaghi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            // const SizedBox(width: 8),
            // Container(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(6),
            //     color: greenMain.withOpacity(0.15),
            //     border: Border.all(color: greenMain.withOpacity(0.4)),
            //   ),
            //   // child: const Text(
            //   //   "Learning",
            //   //   style: TextStyle(
            //   //     color: greenMain,
            //   //     fontWeight: FontWeight.w700,
            //   //     fontSize: 11,
            //   //     letterSpacing: 1,
            //   //   ),
            //   // ),
            // ),
          ],
        ),
      ),
      body: _coursesBody(context),
      bottomNavigationBar: _bottomNavBar(context, 2, _playSound),
    );
  }

  Widget _coursesBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          _heroBanner(),
          const SizedBox(height: 28),
          _sectionLabel("COURSES"),
          const SizedBox(height: 14),
          _courseCard(
            context,
            icon: Icons.trending_up_rounded,
            title: "Stock Market Basics",
            subtitle:
                "Understand how markets work, what stocks are, and how to read charts.",
            tag: "Beginner",
            tagColor: greenMain,
            duration: "20 min",
            lessons: "6 lessons",
            onTap: () {
              _playSound();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GuidelinesPage()));
            },
          ),
          const SizedBox(height: 14),
          _courseCard(
            context,
            icon: Icons.school_rounded,
            title: "Stock 101 Beginner Course",
            subtitle:
                "Portfolios, risk, and picking your first stock explained simply.",
            tag: "Beginner",
            tagColor: greenMain,
            duration: "44 min",
            lessons: "7 lessons",
            onTap: () {
              _playSound();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FinancialCoursePage()));
            },
          ),
          const SizedBox(height: 28),
          _sectionLabel("QUICK TIPS"),
          const SizedBox(height: 14),
          _tipCard(
            icon: Icons.lightbulb_rounded,
            tip:
                "Diversify your portfolio to reduce risk across sectors.",
          ),
          const SizedBox(height: 10),
          _tipCard(
            icon: Icons.show_chart_rounded,
            tip:
                "Don't time the market — time IN the market is what matters.",
          ),
          const SizedBox(height: 10),
          _tipCard(
            icon: Icons.savings_rounded,
            tip:
                "Invest regularly, even small amounts compound significantly over time.",
          ),
        ],
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.7),
            const Color(0xFF110D2A),
          ],
        ),
        border: Border.all(color: purpleAccent.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "آگاہی سے کامیابی",
                  style: TextStyle(
                    color: greenMain.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Knowledge is\nyour best asset",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Free courses to build your financial literacy.",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                  color: Colors.white.withOpacity(0.15), width: 1.5),
            ),
            child: const Icon(Icons.auto_stories_rounded,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.35),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.5,
      ),
    );
  }

  Widget _courseCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required String duration,
    required String lessons,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: purpleAccent.withOpacity(0.18),
                    border:
                        Border.all(color: purpleAccent.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: purpleAccent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white24, size: 14),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _pill(tag, tagColor),
                const SizedBox(width: 8),
                _pill(lessons, Colors.white38),
                const SizedBox(width: 8),
                _pill(duration, Colors.white38),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color == Colors.white38 ? Colors.white38 : color,
            fontSize: 10,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _tipCard({required IconData icon, required String tip}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: greenMain.withOpacity(0.05),
        border: Border.all(color: greenMain.withOpacity(0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greenMain.withOpacity(0.15),
            ),
            child: Icon(icon, color: greenMain, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ── BOTTOM NAV ── */
Widget _bottomNavBar(
    BuildContext context, int currentIndex, VoidCallback playSound) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white38,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
    onTap: (index) {
      playSound();
      if (index == currentIndex) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AllStocksScreen()));
          break;
        case 2:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const CustomerSupportPage()));
          break;
        case 3:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(Icons.star_outline),
          activeIcon: Icon(Icons.star),
          label: "Recommendation"),
      BottomNavigationBarItem(
          icon: Icon(Icons.auto_stories_outlined),
          activeIcon: Icon(Icons.auto_stories),
          label: "Aaghi"),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile"),
    ],
  );
}


















// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:op/AllStockScreen.dart';
// import 'home_page.dart';
// // import 'recommendations_screen.dart';
// import 'profile_page.dart';

// const Color purpleAccent = Color(0xFF6E4BD8);
// const Color greenMain = Color(0xFFAAF308);

// class CustomerSupportPage extends StatefulWidget {
//   const CustomerSupportPage({super.key});

//   @override
//   State<CustomerSupportPage> createState() => _CustomerSupportPageState();
// }

// class _CustomerSupportPageState extends State<CustomerSupportPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   final AudioPlayer _audioPlayer = AudioPlayer();

//   void _playSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('success.mp3'));
//     } catch (e) {
//       debugPrint("Error playing sound: $e");
//     }
//   }

//   // Messages list (newest at index 0)
//   final List<Map<String, dynamic>> messages = [
//     {
//       "from": "advisor",
//       "text": "Hello 👋 I’m your financial advisor. How can I help you today?",
//       "isImage": false,
//     },
//   ];

//   void _sendMessage({String? text}) {
//     if (text == null || text.trim().isEmpty) return;

//     // Add user message
//     setState(() {
//       messages.insert(0, {"from": "customer", "text": text, "isImage": false});
//     });

//     _messageController.clear();
//     _scrollToTop();

//     // Add AI reply after delay
//     Future.delayed(const Duration(milliseconds: 300), () {
//       setState(() {
//         messages.insert(0, {
//           "from": "advisor",
//           "text": "Thanks for reaching out! Can you provide more details?",
//           "isImage": false,
//         });
//       });
//       _scrollToTop();
//     });
//   }

//   void _scrollToTop() {
//     Future.delayed(const Duration(milliseconds: 50), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 _playSound();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HomePage()),
//                 );
//               },
//               child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Customer Support",
//               style: TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Messages list (reversed)
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               controller: _scrollController,
//               padding: const EdgeInsets.all(12),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isCustomer = msg["from"] == "customer";

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: Row(
//                     mainAxisAlignment: isCustomer
//                         ? MainAxisAlignment.end
//                         : MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       // AI avatar
//                       if (!isCustomer)
//                         CircleAvatar(
//                           radius: 16,
//                           backgroundColor: Colors.grey[850],
//                           child: const Icon(
//                             Icons.support_agent,
//                             color: greenMain,
//                             size: 24,
//                           ),
//                         ),
//                       if (!isCustomer) const SizedBox(width: 8),
//                       // Message bubble
//                       Flexible(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                           decoration: BoxDecoration(
//                             color: isCustomer ? purpleAccent : Colors.grey[850],
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 offset: const Offset(2, 2),
//                                 blurRadius: 4,
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             msg["text"],
//                             style: TextStyle(
//                               color: isCustomer ? Colors.white : Colors.white70,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (isCustomer) const SizedBox(width: 8),
//                       // User avatar
//                       if (isCustomer)
//                         const CircleAvatar(
//                           radius: 16,
//                           backgroundColor: purpleAccent,
//                           child: Icon(Icons.person, color: Colors.white, size: 18),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Input field
//           Container(
//             padding: const EdgeInsets.all(8),
//             color: Colors.grey[900],
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxHeight: 120),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[850],
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 4),
//                             child: Icon(Icons.image, color: purpleAccent),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextField(
//                               controller: _messageController,
//                               maxLines: null,
//                               textInputAction: TextInputAction.newline,
//                               style: const TextStyle(color: Colors.white),
//                               decoration: const InputDecoration(
//                                 hintText: "Type a message...",
//                                 hintStyle: TextStyle(color: Colors.white70),
//                                 border: InputBorder.none,
//                                 isDense: true,
//                                 contentPadding:
//                                     EdgeInsets.symmetric(vertical: 10),
//                               ),
//                               onSubmitted: (value) {
//                                 _sendMessage(text: value);
//                               },
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               _sendMessage(text: _messageController.text);
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 4),
//                               child: Icon(Icons.send, color: purpleAccent),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _bottomNavBar(context, 2, _playSound),
//     );
//   }
// }

// // Bottom navigation with sound
// // AudioPlayer instance

// // Function to play click sound

// // Bottom navigation with sound
// Widget _bottomNavBar(
//     BuildContext context, int currentIndex, VoidCallback playSound) {
//   return BottomNavigationBar(
//     backgroundColor: Colors.black,
//     selectedItemColor: greenMain,
//     unselectedItemColor: Colors.white,
//     currentIndex: currentIndex,
//     type: BottomNavigationBarType.fixed,
//     onTap: (index) {
//       // 🔊 Play the tune whenever a tab is tapped
//       playSound();

//       // Do nothing if tapping the current tab
//       if (index == currentIndex) return;

//       switch (index) {
//         case 0:
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => const HomePage()));
//           break;
//         case 1:
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => const AllStocksScreen()));
//           break;
//         case 2:
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => const CustomerSupportPage()));
//           break;
//         case 3:
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => const ProfilePage()));
//           break;
//       }
//     },
//     items: const [
//       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       BottomNavigationBarItem(icon: Icon(Icons.star), label: "Recommendation"),
//       BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
//       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//     ],
//   );
// }