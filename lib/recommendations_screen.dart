import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class RecommendationScreen extends StatefulWidget {
  final String riskCategory;

  const RecommendationScreen({super.key, required this.riskCategory});


  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isLoading = true;
  List<dynamic> recommendations = [];
  String? errorMessage;
  bool _isRiskDialogVisible = false;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    _showRiskDialog();

    try {
      final response = await http.post(
        Uri.parse('http://13.61.163.243/ai/recommend-by-risk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'risk': widget.riskCategory}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        setState(() {
          recommendations = decoded['recommendations'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server error ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }

    _dismissRiskDialog();
  }

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

  void _showRiskDialog() {
    if (!mounted || _isRiskDialogVisible) return;

    _isRiskDialogVisible = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final risk = widget.riskCategory.isNotEmpty
          ? widget.riskCategory[0].toUpperCase() +
              widget.riskCategory.substring(1)
          : widget.riskCategory;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profile Analyzed 📊",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "You are a $risk risk-level investor.\n\nLet us pick the best stocks for you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85), fontSize: 14),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 10),
              Text(
                "Finding opportunities...",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _dismissRiskDialog() {
    if (!mounted || !_isRiskDialogVisible) return;

    _isRiskDialogVisible = false;

    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {}
  }

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        title: const Text("Skip to Home?",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to go to Home Page?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("No",
                style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Yes",
                style: TextStyle(color: greenMain)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isShariah(dynamic stock) {
    final status = (stock['Status '] ?? '').toString().toLowerCase();

    final bool nonHalal =
        (status.contains('not') && status.contains('halal')) ||
            (status.contains('non') && status.contains('halal'));

    return !nonHalal && status.contains('halal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔹 AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Recommendations",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _showSkipDialog,
            child: const Text(
              "Skip",
              style: TextStyle(
                  color: greenMain,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),

      /// 🔹 Body
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    physics:
                        const BouncingScrollPhysics(),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      final stock = recommendations[index];

                      final title =
                          "${stock['CompanyName']} (${stock['Ticker']})";

                      final subtitle =
                          stock['Sector'] ?? "Unknown";

                      final percent =
                          "${stock['DailyReturn%']?.toStringAsFixed(2) ?? '0'}%";

                      final risk =
                          stock['RiskLevel'] ?? "Medium";

                      final shariah = _isShariah(stock);

                      return GestureDetector(
                        onTap: () {
                          _playSound();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FundViewPage(
                                ticker: stock['Ticker'], // Pass the Ticker value
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 16),
                          padding:
                              const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                const Color(0x1F1A0F2F),
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                            border: Border.all(
                                color: purpleAccent
                                    .withOpacity(0.7)),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: purpleAccent
                                      .withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius
                                          .circular(8),
                                ),
                                child: const Icon(
                                    Icons.trending_up,
                                    color:
                                        purpleAccent),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                              FontWeight
                                                  .bold),
                                    ),
                                    const SizedBox(
                                        height: 4),
                                    Text(
                                      subtitle,
                                      style: const TextStyle(
                                          color: Colors
                                              .white70,
                                          fontSize:
                                              12),
                                    ),
                                    const SizedBox(
                                        height: 6),

                                    Row(
                                      children: [
                                        _tag(
                                            risk,
                                            _riskColor(
                                                risk)),

                                        const SizedBox(
                                            width: 6),

                                        _tag(
                                            shariah
                                                ? "Shariah"
                                                : "Non-Shariah",
                                            shariah
                                                ? greenMain
                                                : Colors
                                                    .redAccent),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                                horizontal:
                                                    10,
                                                vertical:
                                                    5),
                                    decoration:
                                        BoxDecoration(
                                      color: purpleAccent
                                          .withOpacity(
                                              0.2),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  6),
                                    ),
                                    child: Text(
                                      percent,
                                      style: const TextStyle(
                                          color:
                                              purpleAccent,
                                          fontWeight:
                                              FontWeight
                                                  .bold),
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 8),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(6),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          purpleAccent,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  6),
                                    ),
                                    child: const Icon(
                                        Icons
                                            .arrow_forward,
                                        color: Colors
                                            .white,
                                        size: 18),
                                  )
                                ],
                              )
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
      padding: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
