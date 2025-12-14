import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? selectedCardIndex;

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
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
  ];

  Color _riskColor(String risk) {
    switch (risk) {
      case "Low":
        return Colors.greenAccent.shade400;
      case "Medium":
        return Colors.orangeAccent.shade100;
      case "High":
        return Colors.redAccent.shade100;
      default:
        return Colors.white;
    }
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Skip to Home?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to go to Home Page?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text("Yes", style: TextStyle(color: Colors.lightGreenAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 24,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Recommendations",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Top Picks For You",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _showSkipDialog,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: stocks.length,
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    final isSelected = selectedCardIndex == index;

                    return GestureDetector(
                      onTap: () {
                        _playSound();
                        setState(() {
                          selectedCardIndex = index;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FundViewPage(fundName: stock["title"]),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        // Inside the AnimatedContainer decoration:
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.lightGreenAccent.shade400 // changed from greenAccent.shade400
                              : const Color(0x1F1A0F2F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF6E4BD8).withOpacity(0.7), // purple stays
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6E4BD8).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: Color(0xFF6E4BD8),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stock["title"],
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    stock["subtitle"],
                                    style: TextStyle(
                                      color: isSelected ? Colors.black87 : Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _riskColor(stock["risk"]),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          stock["risk"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: stock["shariah"]
                                              ? Colors.greenAccent
                                              : Colors.redAccent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          stock["shariah"]
                                              ? "Shariah"
                                              : "Non-Shariah",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6E4BD8).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    stock["percentChange"],
                                    style: const TextStyle(
                                      color: Color(0xFF6E4BD8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6E4BD8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
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
      ),
    );
  }
}
