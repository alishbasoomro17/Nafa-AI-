import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';

/// KEEPING YOUR ORIGINAL GREEN COLOR
const Color greenMain = Color(0xFFAAF308);

/// NEW UI COLORS
const Color primaryColor = Color(0xFF7B61FF);
const Color cardColor = Color(0xFF171717);
const Color greenColor = Color(0xFF00C853);
const Color redColor = Color(0xFFD50000);
const Color blueColor = Color(0xFF2979FF);
const Color goldColor = Color(0xFFFFC107);

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() =>
      _RecommendationScreenState();
}

class _RecommendationScreenState
    extends State<RecommendationScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('success.mp3'),
      );
    } catch (e) {
      debugPrint("Sound error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// YOUR ORIGINAL STOCK LIST
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

  /// RISK ARROW
  Icon _riskArrow(String risk) {

    switch (risk) {

      case "High":
        return const Icon(
            Icons.arrow_downward,
            color: redColor);

      case "Medium":
        return const Icon(
            Icons.arrow_forward,
            color: blueColor);

      case "Low":
        return const Icon(
            Icons.arrow_upward,
            color: goldColor);

      default:
        return const Icon(Icons.remove);
    }
  }

  /// PERCENT COLOR
  Color _percentColor(String percent) {

    return percent.contains("-")
        ? redColor
        : greenColor;
  }

  /// SHARIAH TAG
  Widget _tag(bool isShariah) {

    return Container(

      padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3),

      decoration: BoxDecoration(

        color: isShariah
            ? greenColor.withOpacity(.15)
            : redColor.withOpacity(.15),

        borderRadius:
            BorderRadius.circular(6),
      ),

      child: Text(

        isShariah
            ? "Shariah"
            : "Non-Shariah",

        style: TextStyle(

          color: isShariah
              ? greenColor
              : redColor,

          fontSize: 11,
        ),
      ),
    );
  }

  /// SKIP DIALOG (GREEN SAME AS YOUR APP)
  void _showSkipDialog() {

    showDialog(

      context: context,

      builder: (_) => AlertDialog(

        backgroundColor:
            const Color(0xFF0D0D0D),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),

        title: const Text(
          "Skip to Home?",
          style:
              TextStyle(color: Colors.white),
        ),

        content: const Text(
          "Are you sure you want to go to Home Page?",
          style: TextStyle(
              color: Colors.white70),
        ),

        actions: [

          TextButton(

            onPressed: () =>
                Navigator.pop(context),

            child: const Text(
              "No",
              style: TextStyle(
                  color: Colors.white54),
            ),
          ),

          /// YES BUTTON GREEN MAIN
          TextButton(

            onPressed: () {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const HomePage(),
                ),
              );
            },

            child: const Text(
              "Yes",
              style: TextStyle(
                color: greenMain,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
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

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(

          "Personalized Stock Recommendations",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),

        /// SKIP BUTTON GREEN MAIN
        actions: [

          TextButton(

            onPressed:
                _showSkipDialog,

            child: const Text(

              "Skip",

              style: TextStyle(
                color: greenMain,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: ListView.builder(

        padding:
            const EdgeInsets.all(16),

        itemCount:
            stocks.length,

        itemBuilder:
            (context, index) {

          final stock =
              stocks[index];

          return GestureDetector(

            onTap: () {

              _playSound();

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      FundViewPage(
                    fundName:
                        stock["title"],
                  ),
                ),
              );
            },

            child: Container(

              padding:
                  const EdgeInsets.all(
                      14),

              margin:
                  const EdgeInsets.only(
                      bottom: 12),

              decoration:
                  BoxDecoration(

                color: cardColor,

                borderRadius:
                    BorderRadius.circular(
                        12),
              ),

              child: Row(

                children: [

                  const Icon(
                    Icons.show_chart,
                    color:
                        primaryColor,
                  ),

                  const SizedBox(
                      width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(

                          stock[
                              "title"],

                          style:
                              const TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),

                        Text(

                          stock[
                              "subtitle"],

                          style:
                              const TextStyle(
                            color: Colors
                                .white54,
                          ),
                        ),

                        const SizedBox(
                            height: 4),

                        _tag(stock[
                            "shariah"]),
                      ],
                    ),
                  ),

                  Column(

                    children: [

                      _riskArrow(
                          stock[
                              "risk"]),

                      Text(

                        stock[
                            "percentChange"],

                        style:
                            TextStyle(

                          color:
                              _percentColor(
                                  stock[
                                      "percentChange"]),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}