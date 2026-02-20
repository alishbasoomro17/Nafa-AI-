import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';
import 'recommendation_page.dart';
import 'profile_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  // Messages list (newest at index 0)
  final List<Map<String, dynamic>> messages = [
    {
      "from": "advisor",
      "text": "Hello 👋 I’m your financial advisor. How can I help you today?",
      "isImage": false,
    },
  ];

  void _sendMessage({String? text}) {
    if (text == null || text.trim().isEmpty) return;

    // Add user message
    setState(() {
      messages.insert(0, {"from": "customer", "text": text, "isImage": false});
    });

    _messageController.clear();
    _scrollToTop();

    // Add AI reply after delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        messages.insert(0, {
          "from": "advisor",
          "text": "Thanks for reaching out! Can you provide more details?",
          "isImage": false,
        });
      });
      _scrollToTop();
    });
  }

  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
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
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            const Text(
              "Customer Support",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list (reversed)
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isCustomer = msg["from"] == "customer";

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: isCustomer
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // AI avatar
                      if (!isCustomer)
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[850],
                          child: const Icon(
                            Icons.support_agent,
                            color: greenMain,
                            size: 24,
                          ),
                        ),
                      if (!isCustomer) const SizedBox(width: 8),
                      // Message bubble
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isCustomer ? purpleAccent : Colors.grey[850],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            msg["text"],
                            style: TextStyle(
                              color: isCustomer ? Colors.white : Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (isCustomer) const SizedBox(width: 8),
                      // User avatar
                      if (isCustomer)
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: purpleAccent,
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.image, color: purpleAccent),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                              ),
                              onSubmitted: (value) {
                                _sendMessage(text: value);
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendMessage(text: _messageController.text);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.send, color: purpleAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(context, 2, _playSound),
    );
  }
}

// Bottom navigation with sound
// AudioPlayer instance
final AudioPlayer _audioPlayer = AudioPlayer();

// Function to play click sound
void _playClickSound() async {
  try {
    await _audioPlayer.play(AssetSource('success.mp3')); // your tune here
  } catch (e) {
    debugPrint("Error playing sound: $e");
  }
}

// Bottom navigation with sound
Widget _bottomNavBar(
    BuildContext context, int currentIndex, VoidCallback playSound) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      // 🔊 Play the tune whenever a tab is tapped
      playSound();

      // Do nothing if tapping the current tab
      if (index == currentIndex) return;

      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const RecommendationPage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const CustomerSupportPage()));
          break;
        case 3:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.star), label: "Recommendation"),
      BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}
