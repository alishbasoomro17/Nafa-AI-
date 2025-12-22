import 'package:flutter/material.dart';
import 'home_page.dart';
import 'recommendation_page.dart';
import 'customer_support_page.dart';
import 'signup.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Shehnila Narejo";
  String email = "shehnila@example.com";
  String profilePic = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Removed default back arrow
        title: const Text(
          "",
          style: TextStyle(color: Colors.white),
          
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE IMAGE
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[900],
                  child: const Icon(Icons.person, size: 60, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Feature coming soon")),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: purpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _infoField("Username", username),
            const SizedBox(height: 18),
            _infoField("Email", email),
            const SizedBox(height: 18),
            _optionButton("Change Password", Icons.lock, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Feature coming soon")),
              );
            }),
            const SizedBox(height: 18),
            _optionButton("Privacy Policy", Icons.privacy_tip, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyScreen(),
                ),
              );
            }),
            const SizedBox(height: 18),
            _optionButton("Delete Account", Icons.delete_forever, () {
              _showConfirmationDialog(
                context,
                title: "Delete Account",
                content: "Are you sure you want to delete your account?",
                onConfirm: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
              );
            }),
            const SizedBox(height: 18),
            _optionButton("Logout", Icons.logout, () {
              _showConfirmationDialog(
                context,
                title: "Logout",
                content: "Are you sure you want to logout?",
                onConfirm: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context, 3),
    );
  }

  Widget _infoField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: purpleAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const Icon(Icons.edit, color: purpleAccent),
        ],
      ),
    );
  }

  Widget _optionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: purpleAccent.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: purpleAccent),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context,
      {required String title,
      required String content,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Yes", style: TextStyle(color: Color(0xFFAAF308))),
          ),
        ],
      ),
    );
  }
}

// =================== MODERN PRIVACY POLICY ===================

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: greenMain),
            ),
            const SizedBox(width: 8),
            const Text("Privacy Policy",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ModernPolicyCard(
            title: "What is Nafa AI?",
            content:
                "Nafa AI is a smart financial assistant that helps users make informed investment decisions.",
          ),
          SizedBox(height: 16),
          ModernPolicyCard(
            title: "How is your data used?",
            content:
                "Your data is securely stored and used only to improve your experience.",
          ),
          SizedBox(height: 16),
          ModernPolicyCard(
            title: "Contact Us",
            content: "Phone: +92 300 1234567\nEmail: support@nafa.ai",
          ),
          SizedBox(height: 16),
          ModernPolicyCard(
            title: "Security Policy",
            content:
                "We follow industry standards to protect your personal information.",
          ),
        ],
      ),
    );
  }
}

class ModernPolicyCard extends StatefulWidget {
  final String title;
  final String content;

  const ModernPolicyCard({super.key, required this.title, required this.content});

  @override
  State<ModernPolicyCard> createState() => _ModernPolicyCardState();
}

class _ModernPolicyCardState extends State<ModernPolicyCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: purpleAccent.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: purpleAccent.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                RotationTransition(
                  turns: _arrowAnimation,
                  child: const Icon(Icons.keyboard_arrow_down,
                      color: purpleAccent, size: 26),
                )
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Text(
                widget.content,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== BOTTOM NAV ===================

Widget _bottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      if (index == currentIndex) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RecommendationPage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CustomerSupportPage()));
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
