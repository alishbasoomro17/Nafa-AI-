import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';

// ---------------- THEME ----------------
const Color _kAccentSuccess = Color(0xFFAAF308);
const Color _kPrimaryColor = Color(0xFF6E4BD8);
const Color _kDarkBackground = Colors.black;
const Color _kCardBackground = Color(0xFF1A1A1A);

// ---------------- AUDIO PLAYER ----------------
final AudioPlayer _audioPlayer = AudioPlayer();

void _playClickSound() async {
  try {
    await _audioPlayer.play(AssetSource('success.mp3'));
  } catch (e) {
    print("Error playing sound: $e");
  }
}

// ---------------- FUND VIEW PAGE ----------------
class FundViewPage extends StatefulWidget {
  final String ticker;

  const FundViewPage({super.key, required this.ticker});

  @override
  State<FundViewPage> createState() => _FundViewPageState();
}

class _FundViewPageState extends State<FundViewPage> {
  Map<String, dynamic>? stockData;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchStock();
  }

  Future<void> fetchStock() async {
    try {
      final response =
          await http.get(Uri.parse("http://127.0.0.1:3000/stocks/${widget.ticker}"));

      if (response.statusCode == 200) {
        setState(() {
          stockData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: _kDarkBackground,
        body: Center(
          child: CircularProgressIndicator(color: _kAccentSuccess),
        ),
      );
    }

    if (stockData == null) {
      return const Scaffold(
        backgroundColor: _kDarkBackground,
        body: Center(
          child: Text("Failed to load data",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          stockData!["Ticker"],
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _playClickSound();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text("Skip",
                style: TextStyle(color: _kAccentSuccess)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _fundHeader(),
                  const SizedBox(height: 16),
                  _actionRow(context),
                  const SizedBox(height: 20),
                  _quickInsights(),
                  const SizedBox(height: 20),
                  _marketStats(),
                  const SizedBox(height: 20),
                  _riskSection(),
                ],
              ),
            ),
          ),
          _ctaFooter(context),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _fundHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet,
                color: _kPrimaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stockData!["CompanyName"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "${stockData!["Sector"]} • ${stockData!["Status"]}",
                  style:
                      const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------- ACTION BUTTONS ----------------
  Widget _actionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButton(
          icon: Icons.show_chart,
          label: "Performance",
          color: _kPrimaryColor,
          onTap: () {
            _playClickSound();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const PerformanceGraph()),
            );
          },
        ),
        _iconButton(
          icon: Icons.access_time_rounded,
          label: "Time to Invest",
          color: _kAccentSuccess,
          onTap: () {
            _playClickSound();
            _timeDialog(context);
          },
        ),
      ],
    );
  }

  Widget _iconButton(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ],
      ),
    );
  }

  // ---------------- QUICK INSIGHTS ----------------
  Widget _quickInsights() {
    return Row(
      children: [
        Expanded(
          child: InsightCard(
            title: "Daily Return",
            value: "${stockData!["DailyReturn"]}%",
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InsightCard(
            title: "Market Cap",
            value: formatMarketCap(stockData!["MarketCap"]),
            icon: Icons.payments,
          ),
        ),
      ],
    );
  }

  // ---------------- MARKET STATS ----------------
  Widget _marketStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _metricRow("Open Price", stockData!["OpenPrice"]),
          _metricRow("Close Price", stockData!["ClosePrice"]),
          _metricRow("CAGR", stockData!["CAGR"]),
          _metricRow("Volatility", stockData!["Volatility"]),
        ],
      ),
    );
  }

  // ---------------- RISK ----------------
  Widget _riskSection() {
    double riskValue =
        stockData!["RiskLevel"] == "Low"
            ? 0.3
            : stockData!["RiskLevel"] == "Medium"
                ? 0.6
                : 0.9;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Risk Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: riskValue,
            backgroundColor: Colors.white12,
            color: _kAccentSuccess,
          ),
          const SizedBox(height: 8),
          Text("${stockData!["RiskLevel"]} Risk",
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ---------------- CTA BUTTON ----------------
  Widget _ctaFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.rocket_launch_rounded),
        label: const Text("Invest Now"),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kAccentSuccess,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          _playClickSound();
        },
      ),
    );
  }

  // ---------------- DIALOG ----------------
  void _timeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: _kCardBackground,
        title: Text("Time to Invest",
            style: TextStyle(color: Colors.white)),
        content: Text(
          "Market indicators show positive momentum.\n\nThis is a GOOD time to invest.",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // ---------------- METRIC ROW ----------------
  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Colors.white60, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------- MARKET CAP FORMAT ----------------
  String formatMarketCap(String value) {
    double cap = double.parse(value);

    if (cap >= 1e12) return "${(cap / 1e12).toStringAsFixed(2)}T";
    if (cap >= 1e9) return "${(cap / 1e9).toStringAsFixed(2)}B";
    if (cap >= 1e6) return "${(cap / 1e6).toStringAsFixed(2)}M";

    return cap.toString();
  }
}

// ---------------- INSIGHT CARD ----------------
class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InsightCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: _kAccentSuccess),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }
}

class PerformanceGraph extends StatefulWidget {
  const PerformanceGraph({super.key});

  @override
  State<PerformanceGraph> createState() => _PerformanceGraphState();
}

class _PerformanceGraphState extends State<PerformanceGraph>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController =
      TextEditingController(text: "10000");

  final TextEditingController _monthsController =
      TextEditingController(text: "12");

  double amount = 10000;
  int months = 12;

  final double yearlyRate = 0.12;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _monthsController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<double> get monthlyData =>
      List.generate(months, (i) => amount * (1 + yearlyRate * ((i + 1) / 12)));

  void _updateGraph() {
    setState(() {
      amount = double.tryParse(_amountController.text) ?? 0;
      months = int.tryParse(_monthsController.text) ?? 1;

      if (months < 1) months = 1;
      if (months > 60) months = 60;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Performance Projection",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estimate your returns",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Adjust the values below to see how your money grows over time with a 12% yearly return.",
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _inputField(
                    label: "Investment (PKR)",
                    controller: _amountController,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _inputField(
                    label: "Months",
                    controller: _monthsController,
                    icon: Icons.calendar_month_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Container(
              height: 400,
              padding: const EdgeInsets.fromLTRB(10, 24, 20, 10),
              decoration: BoxDecoration(
                color: _kCardBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "GROWTH CHART",
                          style: TextStyle(
                              color: _kAccentSuccess,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Total: PKR ${monthlyData.last.toStringAsFixed(0)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) => CustomPaint(
                        size: Size.infinite,
                        painter: EnhancedLineChartPainter(
                          data: monthlyData,
                          animationValue: _controller.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
          cursorColor: _kAccentSuccess,
          onChanged: (val) {
            _updateGraph();
            _playClickSound();
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _kPrimaryColor, size: 20),
            filled: true,
            fillColor: _kCardBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kPrimaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

// Placeholder implementation for EnhancedLineChartPainter
class EnhancedLineChartPainter extends CustomPainter {
  final List<double> data;
  final double animationValue;

  EnhancedLineChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Add your chart drawing logic here
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    for (int i = 0; i < data.length - 1; i++) {
      final startX = i * size.width / (data.length - 1);
      final startY = size.height - (data[i] * size.height);
      final endX = (i + 1) * size.width / (data.length - 1);
      final endY = size.height - (data[i + 1] * size.height);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}