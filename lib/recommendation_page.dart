import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'customer_support_page.dart';

/// ORIGINAL COLORS FROM FIRST UI
const Color greenMain = Color(0xFFAAF308);
const Color primaryColor = Color(0xFF7B61FF);
const Color cardColor = Color(0xFF171717);
const Color greenColor = Color(0xFF00C853);
const Color redColor = Color(0xFFD50000);
const Color blueColor = Color(0xFF2979FF);
const Color goldColor = Color(0xFFFFC107);

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
      debugPrint("Sound error: $e");
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

  Icon _riskArrow(String risk) {
    switch (risk) {
      case "High":
        return const Icon(Icons.arrow_downward, color: redColor);
      case "Medium":
        return const Icon(Icons.arrow_forward, color: blueColor);
      case "Low":
        return const Icon(Icons.arrow_upward, color: goldColor);
      default:
        return const Icon(Icons.remove);
    }
  }

  Color _percentColor(String percent) {
    return percent.contains("-") ? redColor : greenColor;
  }

  Widget _tag(bool isShariah) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isShariah ? greenColor.withOpacity(.15) : redColor.withOpacity(.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isShariah ? "Shariah" : "Non-Shariah",
        style: TextStyle(
          color: isShariah ? greenColor : redColor,
          fontSize: 11,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _playSound();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: const Text(
          "Personalized Stock Recommendations",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        // Skip button removed
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return GestureDetector(
            onTap: () {
              _playSound();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FundViewPage(fundName: stock["title"])),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.show_chart, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stock["title"],
                            style: const TextStyle(color: Colors.white)),
                        Text(stock["subtitle"],
                            style: const TextStyle(color: Colors.white54)),
                        const SizedBox(height: 4),
                        _tag(stock["shariah"]),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _riskArrow(stock["risk"]),
                      Text(
                        stock["percentChange"],
                        style:
                            TextStyle(color: _percentColor(stock["percentChange"])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _bottomNavBar(context, 1, _playSound),
    );
  }
}

// Bottom Navigation Bar with Sound
Widget _bottomNavBar(BuildContext context, int currentIndex, VoidCallback playSound) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      playSound();
      if (index == currentIndex) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const RecommendationPage()));
          break;
        case 2:
          Navigator.pushReplacement(context,
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