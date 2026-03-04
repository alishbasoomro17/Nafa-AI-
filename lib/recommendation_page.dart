import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'customer_support_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> stocks = [
    {
      "title": "Hub Power Company (HUBC)",
      "subtitle": "Power generation & distribution",
      "percentChange": "+1.2%",
      "risk": "Low",
      "shariah": true,
    },
    {
      "title": "Lucky Cement (LUCK)",
      "subtitle": "Cement manufacturing",
      "percentChange": "+3.5%",
      "risk": "Medium",
      "shariah": true,
    },
    {
      "title": "Pakistan Petroleum (PPL)",
      "subtitle": "Oil & Gas Exploration",
      "percentChange": "-0.8%",
      "risk": "High",
      "shariah": false,
    },
    {
      "title": "Engro Corporation (ENGRO)",
      "subtitle": "Fertilizers & Chemicals",
      "percentChange": "+2.1%",
      "risk": "Medium",
      "shariah": true,
    },
    {
      "title": "Bank Al Habib",
      "subtitle": "Banking & Financial Services",
      "percentChange": "+0.9%",
      "risk": "Low",
      "shariah": true,
    },
    {
      "title": "Meezan Bank",
      "subtitle": "Islamic Banking Services",
      "percentChange": "+1.1%",
      "risk": "Low",
      "shariah": true,
    },
  ];

  Color _riskColor(String risk) {
    switch (risk) {
      case "Low":
        return Colors.greenAccent;
      case "Medium":
        return Colors.orangeAccent;
      case "High":
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _playSound();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Recommendations for you",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return GestureDetector(
                    onTap: () {
                      _playSound();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FundViewPage(fundName: stock["title"]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0x1F1A0F2F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: purpleAccent.withOpacity(0.7),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: purpleAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: purpleAccent,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stock["title"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  stock["subtitle"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _tag(stock["risk"],
                                        _riskColor(stock["risk"])),
                                    const SizedBox(width: 6),
                                    _tag(
                                      stock["shariah"]
                                          ? "Shariah"
                                          : "Non-Shariah",
                                      stock["shariah"]
                                          ? greenMain
                                          : Colors.redAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: purpleAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  stock["percentChange"],
                                  style: const TextStyle(
                                    color: purpleAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: purpleAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavBar(context, 1, _playSound),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Bottom Navigation Bar with Sound
Widget _bottomNavBar(
    BuildContext context, int currentIndex, VoidCallback playSound) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      playSound(); // 🔊 play sound on every tab tap
      if (index == currentIndex) return; // do nothing if same tab
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
