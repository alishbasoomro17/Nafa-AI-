import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';
import 'home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      final local_url = dotenv.env['base_url_local'] ?? 'No API Key Found';
      final prod_url = dotenv.env['base_url_production'] ?? 'No API Key Found';

      final response = await http.post(
        Uri.parse('$prod_url/ai/recommend-by-risk'),
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
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profile Analyzed 📊",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You are a $risk risk-level investor.\n\nLet us pick the best stocks for you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.greenAccent),
              const SizedBox(height: 10),
              Text(
                "Finding opportunities...",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
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
    if (risk.contains("Low")) return Colors.greenAccent;
    if (risk.contains("High")) return Colors.redAccent;
    if (risk.contains("Medium")) return Colors.orangeAccent;
    return Colors.white;
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
            child: const Text("No", style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Yes", style: TextStyle(color: greenMain)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // bool _isShariah(dynamic stock) {
  //   final status = (stock['Status '] ?? '').toString().toLowerCase();

  //   final bool nonHalal =
  //       (status.contains('not') && status.contains('halal')) ||
  //           (status.contains('non') && status.contains('halal'));

  //   return !nonHalal && status.contains('halal');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔹 AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        
        title: const Text(
          "Recommendations",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _showSkipDialog,
            child: const Text(
              "Skip",
              style: TextStyle(color: greenMain, fontWeight: FontWeight.bold),
            ),
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final stock = recommendations[index];

                  final title = "${stock['name']} (${stock['symbol']})";

                  final subtitle = stock['sector'] ?? "Unknown";

                  final changeValue = (stock['change'] ?? 0).toDouble();
                  final percent = "${changeValue.toStringAsFixed(2)}%";
                  final risk = stock['risk_level'] ?? "Medium";

                  final shariahStatus = stock['shariah_status'] ?? "Unknown";
                  final isShariah =
                      shariahStatus.toLowerCase().contains("compliant") &&
                      !shariahStatus.toLowerCase().contains("non");

                  return GestureDetector(
                    onTap: () {
                      _playSound();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FundViewPage(
                            ticker: stock['symbol'], // Pass the symbol value
                          ),
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
                        ),
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
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
  "Rs ${(stock['current_price'] ?? 0).toString()}",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
),

                                const SizedBox(height: 6),
                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    _tag(risk, _riskColor(risk)),

                                    const SizedBox(width: 6),

                                    _tag(
                                      isShariah
                                          ? "Shariah Compliant"
                                          : "Non-Shariah Compliant",
                                      isShariah ? greenMain : Colors.redAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Replace the Column with children in the card's right side:
                          // Replace the existing Column on the right side of the card:
Row(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    // Column 1: Sparkline graph
    MiniSparkline(symbol: stock['symbol'] ?? ''),

    const SizedBox(width: 8),

    // Column 2: % change badge + arrow button
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: changeValue >= 0
                ? Colors.green.withOpacity(0.15)
                : Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: changeValue >= 0
                  ? Colors.greenAccent.withOpacity(0.4)
                  : Colors.redAccent.withOpacity(0.4),
            ),
          ),
          child: Text(
            percent,
            style: TextStyle(
              color: changeValue >= 0
                  ? Colors.greenAccent
                  : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 11,
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
),     ],
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

class MiniSparkline extends StatefulWidget {
  final String symbol;
  const MiniSparkline({super.key, required this.symbol});

  @override
  State<MiniSparkline> createState() => _MiniSparklineState();
}

class _MiniSparklineState extends State<MiniSparkline> {
  List<double> prices = [];
  bool isLoading = true;
  bool isUp = true;

  @override
  void initState() {
    super.initState();
    _fetchSparkline();
  }

  Future<void> _fetchSparkline() async {
    try {
      final prodUrl = dotenv.env['base_url_production'] ?? '';
      final response = await http.get(
        Uri.parse('$prodUrl/stocks/history/${widget.symbol}?range=1mo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final history = List<Map<String, dynamic>>.from(data['history']);
        final closes = history
            .map((h) => (h['close'] as num?)?.toDouble() ?? 0.0)
            .where((v) => v > 0)
            .toList();

        if (closes.isNotEmpty) {
          setState(() {
            prices = closes;
            isUp = closes.last >= closes.first;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        // Fallback to DB history
        final response2 = await http.get(
          Uri.parse('$prodUrl/stocks/db-history/${widget.symbol}'),
        );
        if (response2.statusCode == 200) {
          final data = jsonDecode(response2.body);
          final history = List<Map<String, dynamic>>.from(data['history']);
          final closes = history
              .map((h) => (h['close'] as num?)?.toDouble() ?? 0.0)
              .where((v) => v > 0)
              .toList();
          setState(() {
            prices = closes;
            isUp = closes.isNotEmpty ? closes.last >= closes.first : true;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 60,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.white24,
            ),
          ),
        ),
      );
    }

    if (prices.isEmpty) {
      return SizedBox(
        width: 60,
        height: 36,
        child: Center(
          child: Text(
            '—',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ),
      );
    }

    final color = isUp ? const Color(0xFFAAF308) : Colors.redAccent;

    return SizedBox(
      width: 64,
      height: 36,
      child: CustomPaint(
        painter: _SparklinePainter(prices: prices, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> prices;
  final Color color;

  _SparklinePainter({required this.prices, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.length < 2) return;

    final minP = prices.reduce((a, b) => a < b ? a : b);
    final maxP = prices.reduce((a, b) => a > b ? a : b);
    final range = maxP - minP == 0 ? 1.0 : maxP - minP;

    Offset getPoint(int i) {
      final x = i * size.width / (prices.length - 1);
      final y =
          size.height -
          ((prices[i] - minP) / range) * size.height * 0.85 -
          size.height * 0.05;
      return Offset(x, y);
    }

    // Gradient fill
    final fillPath = Path()..moveTo(0, size.height);
    for (int i = 0; i < prices.length; i++) {
      fillPath.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path()..moveTo(getPoint(0).dx, getPoint(0).dy);
    for (int i = 1; i < prices.length; i++) {
      linePath.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // End dot
    final last = getPoint(prices.length - 1);
    canvas.drawCircle(last, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.prices != prices;
}
