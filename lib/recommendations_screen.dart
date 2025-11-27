import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 24), // Top padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  iconSize: 22,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Recommendations",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Top Picks For You",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFFAAF308),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _stockCard(
                    title: "Hub Power Company (HUBC)",
                    subtitle: "Power generation & distribution",
                    percentChange: "+1.2%",
                    risk: "Low",
                    shariah: true,
                  ),
                  const SizedBox(height: 10),
                  _stockCard(
                    title: "Lucky Cement (LUCK)",
                    subtitle: "Cement manufacturing",
                    percentChange: "+3.5%",
                    risk: "Medium",
                    shariah: true,
                  ),
                  const SizedBox(height: 10),
                  _stockCard(
                    title: "Pakistan Petroleum (PPL)",
                    subtitle: "Oil & Gas Exploration",
                    percentChange: "-0.8%",
                    risk: "High",
                    shariah: false,
                  ),
                  const SizedBox(height: 10),
                  _stockCard(
                    title: "Engro Corporation (ENGRO)",
                    subtitle: "Fertilizers & Chemicals",
                    percentChange: "+2.1%",
                    risk: "Medium",
                    shariah: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockCard({
    required String title,
    required String subtitle,
    required String percentChange,
    required String risk,
    required bool shariah,
  }) {
    const Color stockColor = Color(0xFF6E4BD8);
    final Color bgColor = const Color(0x1F1A0F2F);

    // Risk color mapping
    Color riskColor;
    switch (risk) {
      case "High":
        riskColor = Colors.redAccent;
        break;
      case "Medium":
        riskColor = Colors.yellowAccent.shade700;
        break;
      case "Low":
      default:
        riskColor = Colors.blueAccent;
    }

    // Shariah Label
    Color shariahBg = shariah ? Colors.green.shade800 : Colors.brown.shade500;
    String shariahText = shariah ? "Shariah" : "Non-Shariah";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stockColor.withOpacity(0.7), width: 1),
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
          // Stock Icon Circle
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: stockColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.trending_up,
              color: stockColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          // Stock Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Risk + Shariah Label
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width * 0.45,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12, // Title slightly smaller
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // smaller padding
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        risk,
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 9, // smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // smaller padding
                      decoration: BoxDecoration(
                        color: shariahBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shariahText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9, // smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Percentage Change
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: stockColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              percentChange,
              style: const TextStyle(
                color: stockColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Apply / Visit Arrow
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: stockColor,
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
    );
  }
}
