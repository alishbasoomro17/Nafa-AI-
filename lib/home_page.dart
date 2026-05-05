import 'package:op/AllStockScreen.dart';
import 'package:op/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'recommendations_screen.dart';
import 'customer_support_page.dart';
import 'profile_page.dart';
import 'GuidelinesPage.dart';
import 'course_page.dart';

const Color greenMain    = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

final AudioPlayer _audioPlayer = AudioPlayer();

void _playClickSound() async {
  try {
    await _audioPlayer.play(AssetSource('success.mp3'));
  } catch (e) {
    debugPrint("Error playing sound: $e");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String riskLevel = "Loading...";
  String username  = "";

  @override
  void initState() {
    super.initState();
    fetchRisk();
  }

  Future<void> fetchRisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        setState(() => riskLevel = "No token found");
        return;
      }

      // Decode JWT to get user id
      final parts   = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final userId = payload["id"];
      final baseUrl = dotenv.env['base_url_production'];
      final url     = Uri.parse("$baseUrl/users/user/$userId");

      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data is List ? data[0] : data;
        if (user["riskCategory"].isEmpty || user["riskCategory"] == "Unknown" || user["riskCategory"] == "null") {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    }
    return;
  }
        setState(() {
          riskLevel = user["riskCategory"] ?? "Unknown";
          username  = user["username"]     ?? "";
        });
        
      } else {
        setState(() => riskLevel = "Failed to load");
      }
    } catch (e) {
      setState(() => riskLevel = "Error");
      debugPrint("Risk fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset('assets/logo1.png', height: 32, errorBuilder: (_, __, ___) =>
                const Icon(Icons.show_chart, color: greenMain, size: 28)),
            const SizedBox(width: 10),
           
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white70),
            onPressed: _playClickSound,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: greenMain,
        onRefresh: fetchRisk,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcomeCard(),
              const SizedBox(height: 30),
              _sectionHeader("INVESTMENT PROFILE", Icons.analytics_outlined),
              const SizedBox(height: 12),
              _profileBox(context, riskLevel),
              const SizedBox(height: 30),
         
              const SizedBox(height: 30),
              _sectionHeader("LEARNING PROGRESS", Icons.school_outlined),
              const SizedBox(height: 12),
              _learningModule(context),
              const SizedBox(height: 30),
              _sectionHeader("MARKET INSIGHTS", Icons.lightbulb_outline),
              const SizedBox(height: 12),
              _tipCard(
                icon: Icons.pie_chart_outline_rounded,
                tip: "Diversify your portfolio to reduce risk across sectors.",
              ),
              const SizedBox(height: 12),
              _tipCard(
                icon: Icons.savings_rounded,
                tip: "Small consistent investments compound significantly over time.",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 0),
    );
  }

  // ── Section header ──
  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Welcome card ──
  Widget _welcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.3),
            const Color(0xFF0A0A0F),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: purpleAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (username.isNotEmpty)
            Text(
              "Hello, $username 👋",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (username.isNotEmpty) const SizedBox(height: 6),
          const Text(
            "Portfolio\nOverview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Track your investment category and grow your financial knowledge.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile box ──
 Widget _profileBox(BuildContext context, String riskLevel) {
  final isUnknown = riskLevel.isEmpty ||
      riskLevel == "Unknown" ||
      riskLevel == "null" ||
      riskLevel == "Loading..." ||
      riskLevel == "Error" ||
      riskLevel == "Failed to load";

  final riskColor = riskLevel.contains('High')
      ? Colors.redAccent
      : riskLevel.contains('Medium')
          ? Colors.orangeAccent
          : greenMain;

  return Column(
    children: [
      // ── Risk tile ──
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnknown
                ? Colors.orangeAccent.withOpacity(0.4)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: isUnknown
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.quiz_outlined,
                            color: Colors.orangeAccent, size: 20),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Risk Category",
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("Not assessed yet",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Take the risk assessment quiz to get personalized stock recommendations.",
                    style: TextStyle(
                        color: Colors.white38, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.assignment_outlined, size: 18),
                      label: const Text("Take Risk Quiz",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        _playClickSound();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QuizScreen()),
                        );
                      },
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => _infoDialog(
                  context,
                  "Current Risk Category",
                  "This category is calculated based on your risk tolerance quiz.",
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shield_outlined,
                          color: riskColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Current Risk Category",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(riskLevel,
                                  style: TextStyle(
                                      color: riskColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: riskColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  riskLevel.contains('High')
                                      ? 'Aggressive'
                                      : riskLevel.contains('Medium')
                                          ? 'Balanced'
                                          : 'Conservative',
                                  style: TextStyle(
                                      color: riskColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white24),
                  ],
                ),
              ),
      ),

      const SizedBox(height: 12),

      // ── Financial objective tile (always shown) ──
      _profileTile(
        context,
        Icons.track_changes_rounded,
        "Financial Objective",
        "Long-term Wealth",
        purpleAccent,
        "Your profile is optimized for sustainable, long-term growth.",
      ),
    ],
  );
}
  Widget _profileTile(BuildContext context, IconData icon, String title,
      String value, Color color, String detail) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        _infoDialog(context, title, detail);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  // ── Action grid ──
 
  Widget _learningModule(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerSupportPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [const Color(0xFF1A1A2E), const Color(0xFF0A0A0F)],
          ),
          border: Border.all(color: purpleAccent.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: purpleAccent,
              child: Icon(Icons.menu_book_rounded, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Aaghi Learning Hub", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text("Master the art of investing", 
                    style: TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: greenMain),
          ],
        ),
      ),
    );
  }

  /* ── TIP CARD ── */
  Widget _tipCard({required IconData icon, required String tip}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: greenMain, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  void _infoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111118),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: greenMain, fontSize: 18)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got it", style: TextStyle(color: purpleAccent))),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: greenMain,
      unselectedItemColor: Colors.white38,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _playClickSound();
        if (index == currentIndex) return;
        switch (index) {
          case 0: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())); break;
          case 1: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AllStocksScreen())); break;
          case 2: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerSupportPage())); break;
          case 3: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage())); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: "Recommendations"),
        BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: "Aaghi"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "Profile"),
      ],
    );
  }
}