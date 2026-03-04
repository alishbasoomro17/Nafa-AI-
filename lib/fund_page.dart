import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';

// ---------------- THEME ----------------
const Color _kAccentSuccess = Color(0xFFAAF308);
const Color _kPrimaryColor = Color(0xFF6E4BD8);
const Color _kDarkBackground = Colors.black;
const Color _kCardBackground = Color(0xFF1A1A1A);
const Color _kDarkerBackground = Color(0xFF0F0F0F);

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
class FundViewPage extends StatelessWidget {
  final String fundName;
  const FundViewPage({super.key, required this.fundName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Ensures arrow is white
        title: Text(
          fundName,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _playClickSound(); // sound added
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: _kAccentSuccess, fontSize: 14),
            ),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Money Market Mutual Fund",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Low risk • Stable • Short-term",
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButton(
          icon: Icons.show_chart,
          label: "Performance",
          color: _kPrimaryColor,
          onTap: () {
            _playClickSound(); // sound added
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerformanceGraph()),
            );
          },
        ),
        _iconButton(
          icon: Icons.access_time_rounded,
          label: "Time to Invest",
          color: _kAccentSuccess,
          onTap: () {
            _playClickSound(); // sound added
            _timeDialog(context);
          },
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
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

  Widget _quickInsights() {
    return Row(
      children: [
        Expanded(
          child: InsightCard(
            title: "Expected Return",
            value: "≈ 12% yearly",
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InsightCard(
            title: "Min Investment",
            value: "PKR 1,000",
            icon: Icons.payments,
          ),
        ),
      ],
    );
  }

  Widget _riskSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Risk Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.25,
            backgroundColor: Colors.white12,
            color: Colors.green,
            minHeight: 6,
          ),
          SizedBox(height: 8),
          Text(
            "Low risk – suitable for conservative investors",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _ctaFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.rocket_launch_rounded, size: 24),
        label: const Text(
          "Invest Now",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kAccentSuccess,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          _playClickSound(); // sound added
        },
      ),
    );
  }

  void _timeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kCardBackground,
        title: const Text("Time to Invest",
            style: TextStyle(color: Colors.white, fontSize: 14)),
        content: const Text(
          "Market indicators show positive momentum.\n\nThis is a GOOD time to invest.",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }
}

// ---------------- INSIGHT CARD ----------------
class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

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
          Icon(icon, color: _kAccentSuccess, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Text(title,
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------- PERFORMANCE GRAPH ----------------
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
        title: const Text("Performance Projection",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                      icon: Icons.account_balance_wallet_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _inputField(
                      label: "Months",
                      controller: _monthsController,
                      icon: Icons.calendar_month_outlined),
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
                        child: Text("GROWTH CHART",
                            style: TextStyle(
                                color: _kAccentSuccess,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold)),
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

  Widget _inputField(
      {required String label,
        required TextEditingController controller,
        required IconData icon}) {
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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          cursorColor: _kAccentSuccess,
          onChanged: (val) {
            _updateGraph();
            _playClickSound(); // sound added
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _kPrimaryColor, size: 20),
            filled: true,
            fillColor: _kCardBackground,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

// ---------------- CUSTOM PAINTER ----------------
class EnhancedLineChartPainter extends CustomPainter {
  final List<double> data;
  final double animationValue;

  EnhancedLineChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 50;
    const double bottomPadding = 40;
    const double topPadding = 10;

    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    final maxY = data.reduce((a, b) => a > b ? a : b);
    final minY = data.reduce((a, b) => a < b ? a : b);
    final range = (maxY - minY).abs() < 1 ? 1 : maxY - minY;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = topPadding + chartHeight * i / 4;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      final value = maxY - (range * i / 4);
      final tp = TextPainter(
        text: TextSpan(
          text: i == 0
              ? "MAX"
              : (value > 1000
              ? "${(value / 1000).toStringAsFixed(1)}k"
              : value.toInt().toString()),
          style:
          const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(5, y - 6));
    }

    final visibleCount = (data.length * animationValue).clamp(1, data.length).toInt();
    final points = <Offset>[];
    for (int i = 0; i < visibleCount; i++) {
      final x = leftPadding + (data.length == 1 ? 0 : chartWidth * i / (data.length - 1));
      final y = topPadding + chartHeight - ((data[i] - minY) / range) * chartHeight;
      points.add(Offset(x, y));
    }

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        final prev = points[i - 1];
        final curr = points[i];
        final cx = (prev.dx + curr.dx) / 2;
        path.cubicTo(cx, prev.dy, cx, curr.dy, curr.dx, curr.dy);
      }

      final fillPath = Path.from(path)
        ..lineTo(points.last.dx, topPadding + chartHeight)
        ..lineTo(points.first.dx, topPadding + chartHeight)
        ..close();

      canvas.drawPath(fillPath, Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_kAccentSuccess.withOpacity(0.2), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

      canvas.drawPath(path, Paint()
        ..shader = const LinearGradient(colors: [_kPrimaryColor, _kAccentSuccess])
            .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);

      if (animationValue > 0.9) {
        canvas.drawCircle(points.last, 6, Paint()..color = _kAccentSuccess.withOpacity(0.3));
        canvas.drawCircle(points.last, 3, Paint()..color = _kAccentSuccess);
      }
    }

    if (data.length > 1) {
      final tpStart = TextPainter(
        text: const TextSpan(
            text: "Month 1",
            style: TextStyle(color: Colors.white38, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tpStart.paint(canvas, Offset(leftPadding, topPadding + chartHeight + 10));

      final tpEnd = TextPainter(
        text: TextSpan(
            text: "Month ${data.length}",
            style: const TextStyle(color: Colors.white38, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tpEnd.paint(canvas, Offset(size.width - tpEnd.width, topPadding + chartHeight + 10));
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedLineChartPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue || oldDelegate.data != data;
}