import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationScreen extends StatefulWidget {
  final String riskCategory;

  const RecommendationScreen({super.key, required this.riskCategory});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  bool isLoading = true;
  List<dynamic> recommendations = [];
  String? errorMessage;
  bool _isRiskDialogVisible = false;

  @override
  void initState() {
    super.initState();
    debugPrint('riskCategory (from constructor): ${widget.riskCategory}');
    //hwo to check type of riskCategory
    debugPrint('Type of riskCategory: ${widget.riskCategory.runtimeType}');

    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    _showRiskDialog();
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/ai/recommend-by-risk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'risk': widget.riskCategory}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        setState(() {
          recommendations = decoded['recommendations'] ?? [];
          isLoading = false;
        });
        _dismissRiskDialog();
      } else {
        setState(() {
          errorMessage = 'Failed with status ${response.statusCode}';
          isLoading = false;
        });
        _dismissRiskDialog();
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      _dismissRiskDialog();
    }
  }

  void _showRiskDialog() {
    if (!mounted || _isRiskDialogVisible) return;
    _isRiskDialogVisible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final risk = widget.riskCategory.isNotEmpty
              ? (widget.riskCategory[0].toUpperCase() + widget.riskCategory.substring(1))
              : widget.riskCategory;
          return AlertDialog(
  backgroundColor: Colors.black,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "Profile Analyzed 📊",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "You are a $risk risk-level investor.\n\nLet us pick the stocks that best match your profile.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 20),
      const CircularProgressIndicator(
        color: Colors.greenAccent,
      ),
      const SizedBox(height: 10),
      Text(
        "Finding the best opportunities for you...",
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
    ],
  ),
);
 },
      );
    });
  }

  void _dismissRiskDialog() {
    if (!mounted || !_isRiskDialogVisible) return;
    _isRiskDialogVisible = false;
    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {
      // ignore if dialog already dismissed
    }
  }

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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        final stock = recommendations[index];

                        // Normalize status and determine shariah compliance.
                        final status = (stock['Status '] ?? '').toString().toLowerCase();
                        // Treat entries that explicitly say "not"/"non" + "halal" as non-shariah.
                        final bool isExplicitNonHalal = (status.contains('not') && status.contains('halal')) || (status.contains('non') && status.contains('halal'));
                        final bool shariah = !isExplicitNonHalal && status.contains('halal');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _stockCard(
                            title:
                                "${stock[' CompanyName'] ?? 'Unknown'} (${stock['Ticker']})",
                            subtitle: stock['Sector'] ?? 'N/A',
                            percentChange:
                                "${stock['DailyReturn%']?.toStringAsFixed(2) ?? '0'}%",
                            risk: stock['RiskLevel'] ?? 'Moderate',
                            shariah: shariah,
                          ),
                        );
                      },
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
            child: const Icon(Icons.trending_up, color: stockColor, size: 26),
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
                      width:
                          MediaQueryData.fromWindow(
                            WidgetsBinding.instance.window,
                          ).size.width *
                          0.45,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ), // smaller padding
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ), // smaller padding
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
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
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
