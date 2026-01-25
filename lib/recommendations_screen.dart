import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
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

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Skip to Home?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to go to Home Page?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text("Yes", style: TextStyle(color: greenMain)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // 🔹 AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, // pointed arrow
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Recommendations",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _showSkipDialog,
            child: const Text(
              "Skip",
              style: TextStyle(
                color: greenMain,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // 🔹 Body
      body: Padding(
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
                    // Icon
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

                    // Text
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

                    // Right side
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
