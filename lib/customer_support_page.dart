import 'package:flutter/material.dart';
import 'home_page.dart';
import 'recommendation_page.dart';
import 'profile_page.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({super.key});

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "from": "advisor",
      "text": "Hello 👋 I’m your financial advisor. How can I help you?",
      "isImage": false,
    },
  ];

  void _sendMessage({String? text, bool isImage = false}) {
    if ((text == null || text.isEmpty) && !isImage) return;

    setState(() {
      messages.add({
        "from": "customer",
        "text": text,
        "isImage": isImage,
      });

      messages.add({
        "from": "advisor",
        "text": "Thanks for reaching out. Please share more details.",
        "isImage": false,
      });
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Customer Support",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.lightGreenAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Audio call coming soon")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isCustomer = msg["from"] == "customer";

                return Align(
                  alignment:
                  isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isCustomer ? Colors.lightGreenAccent : Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg["isImage"]
                        ? const Icon(Icons.image, size: 40, color: Colors.black)
                        : Text(
                      msg["text"],
                      style: TextStyle(
                        color: isCustomer ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey[900],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.lightGreenAccent),
                  onPressed: () {
                    // 🔹 Show feature coming soon message instead of uploading
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Feature coming soon")),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.lightGreenAccent),
                  onPressed: () {
                    _sendMessage(text: _messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(context, 2),
    );
  }
}

Widget _bottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.lightGreenAccent,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
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
      BottomNavigationBarItem(icon: Icon(Icons.insights), label: "Recommendation"),
      BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}