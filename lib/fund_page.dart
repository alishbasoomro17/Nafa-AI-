import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your HomePage

// --- Theme Constants for Consistency ---
const Color _kAccentSuccess = Color(0xFFAAF308); // Neon Green
const Color _kPrimaryColor = Color(0xFF6E4BD8); // Primary Purple
const Color _kDarkBackground = Colors.black;
const Color _kCardBackground = Color(0xFF1A1A1A); // Slightly lighter black for cards
const Color _kDarkerBackground = Color(0xFF0F0F0F); // Even darker for input fields/inner containers

// ---------------- FUND VIEW PAGE ----------------
class FundViewPage extends StatefulWidget {
  final String fundName;
  const FundViewPage({super.key, required this.fundName});

  @override
  State<FundViewPage> createState() => _FundViewPageState();
}

class _FundViewPageState extends State<FundViewPage> {
  double investAmount = 0;
  int investMonths = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: _buildAppBar(),

      // Use Padding and Column/Expanded to fit content
      body: Column(
        children: [
          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Row 1: Fund Header
                  _buildFundHeader(),
                  const SizedBox(height: 16),

                  // Row 2: Core Actions (Redesigned)
                  _buildActionButtonsRow(),
                  const SizedBox(height: 16),

                  // Row 3: Analysis (Risk & Calculator)
                  _buildAnalysisSection(),
                  const SizedBox(height: 24), // Extra space before CTAs
                ],
              ),
            ),
          ),

          // Row 4: Primary CTAs (Fixed Height at the bottom)
          _buildCTAFooter(),
        ],
      ),
    );
  }

  // --- Widgets ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _kDarkBackground,
      title: Text(
        widget.fundName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _showSkipDialog,
          child: const Text(
            "Skip",
            style: TextStyle(color: _kAccentSuccess, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRiskBarometer(),
        const SizedBox(height: 24),

        const Text("Investment Calculator",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        _buildCalculator(),
      ],
    );
  }

  Widget _buildFundHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: _kPrimaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: _kPrimaryColor, size: 30),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.fundName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                const Text("Money Market Mutual Fund",
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- REDESIGNED ACTION BUTTONS ROW ---
  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _iconActionButton(
          title: "Performance",
          icon: Icons.timeline_rounded,
          color: _kPrimaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerformanceGraph()),
            );
          },
        ),
        _iconActionButton(
          title: "Asset Allocation",
          icon: Icons.pie_chart_outline_rounded,
          color: _kAccentSuccess,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AssetPieChart()),
            );
          },
        ),
        _iconActionButton(
          title: "Details",
          icon: Icons.info_outline_rounded,
          color: Colors.blueAccent,
          onTap: () {
            // Placeholder for a new screen
          },
        ),
      ],
    );
  }

  Widget _iconActionButton(
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.4), width: 1),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // --- REDESIGNED RISK BAROMETER ---
  Widget _buildRiskBarometer() {
    const String currentRisk = "Low";
    final Map<String, Color> riskColors = {
      "Low": Colors.green.shade500,
      "Medium": Colors.orange.shade500,
      "High": Colors.red.shade500,
    };

    int riskIndex = riskColors.keys.toList().indexOf(currentRisk);
    // 0 = Low, 1 = Medium, 2 = High
    double positionFactor = riskIndex / 2.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kPrimaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Risk Profile",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the width for the track
              final double trackWidth = constraints.maxWidth;
              // Indicator position calculation
              // Subtract the indicator's radius from both ends for full movement
              const double indicatorRadius = 6.0;
              final double maxTravel = trackWidth - 2 * indicatorRadius;
              final double indicatorX = indicatorRadius + (positionFactor * maxTravel);

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Gradient Track
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            colors: [
                              riskColors["Low"]!,
                              riskColors["Medium"]!,
                              riskColors["High"]!
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Indicator (Styled as a glow)
                      Positioned(
                        left: indicatorX - indicatorRadius,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: riskColors[currentRisk]!, width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: riskColors[currentRisk]!
                                      .withOpacity(0.9),
                                  blurRadius: 5,
                                  spreadRadius: 2),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: riskColors.keys
                        .map((label) => Text(label,
                        style: TextStyle(
                            color: riskColors[label],
                            fontSize: 11,
                            fontWeight: label == currentRisk
                                ? FontWeight.w900
                                : FontWeight.w600)))
                        .toList(),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 10),
          Text(
              "Current classification: $currentRisk Risk. Suitable for conservative investors.",
              style: const TextStyle(color: Colors.white70, fontSize: 12))
        ],
      ),
    );
  }

  Widget _buildCalculator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: _inputDecoration("Amount (PKR)"),
                  onChanged: (v) =>
                      setState(() => investAmount = double.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: _inputDecoration("Months"),
                  onChanged: (v) =>
                      setState(() => investMonths = int.tryParse(v) ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (investAmount > 0 && investMonths > 0) _buildCalcResult(),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white12, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kAccentSuccess, width: 2),
      ),
      filled: true,
      fillColor: _kDarkerBackground, // Use darker background for input
    );
  }

  // --- COMPACT CALCULATOR RESULT ---
  Widget _buildCalcResult() {
    double rate = 0.12;
    double profit = investAmount * rate * (investMonths / 12);
    double total = investAmount + profit;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: _kDarkerBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kAccentSuccess.withOpacity(0.3))),
      child: Column(
        children: [
          // Profit Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Expected Profit (@12% p.a.):",
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text("+ PKR ${profit.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: _kAccentSuccess,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white10, height: 16),
          // Total Value Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Estimated Maturity Value:",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              Text("PKR ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  // --- CTA FOOTER (COMBINED) ---
  Widget _buildCTAFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: _kDarkBackground,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        children: [
          // Primary CTA - Invest Now
          _buildInvestButton(),
          const SizedBox(height: 12),

          // Secondary CTA - Check Timing
          _buildGoodTimeButton(),
        ],
      ),
    );
  }

  Widget _buildGoodTimeButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.verified_user_rounded, color: _kPrimaryColor, size: 20),
        label: const Text("Check Investment Timing",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        style: TextButton.styleFrom(
          foregroundColor: _kPrimaryColor,
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: _kPrimaryColor, width: 1.5)),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: _kCardBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text("Investment Timing",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              content: const Text(
                  "Market conditions indicate this is a **GOOD TIME** to invest.\n\nExpected yield increasing over next 3 months.",
                  style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close",
                        style: TextStyle(color: _kAccentSuccess))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvestButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.rocket_launch_rounded, color: _kDarkBackground, size: 22),
      label: const Text("Invest Now",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _kAccentSuccess,
        foregroundColor: _kDarkBackground,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: _kAccentSuccess.withOpacity(0.5),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: _kCardBackground,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Coming Soon",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: const Text("Investment feature will be available soon.",
                style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK", style: TextStyle(color: _kAccentSuccess))),
            ],
          ),
        );
      },
    );
  }

  // ------------------- Skip Confirmation Dialog -------------------
  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _kCardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Skip to Home?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to go to the Home Page?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: const Text("Yes", style: TextStyle(color: _kAccentSuccess)),
          ),
        ],
      ),
    );
  }
}

// --- ENHANCED PLACEHOLDER SCREENS (CHARTS) ---
// (These remain largely the same, but the chart areas are inherently complex
// and will benefit from a visual representation)

class PerformanceGraph extends StatelessWidget {
  const PerformanceGraph({super.key});

  final List<double> chartData = const [12.0, 15.5, 14.0, 18.0, 20.5];
  final List<String> labels = const ['2021', '2022', '2023', '2024', '2025'];

  Widget _buildChartLegend({required Color color, required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        title: const Text("Performance Graph",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "5-Year Return: +20.5%",
              style: TextStyle(
                  color: _kAccentSuccess,
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tracked value of PKR 10,000 invested over time.",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                decoration: BoxDecoration(
                  color: _kCardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: LineChartPainter(chartData, _kPrimaryColor),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels
                  .map((label) => Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            _buildChartLegend(
              color: _kPrimaryColor,
              label: "Fund Performance",
            ),
          ],
        ),
      ),
    );
  }
}

// --- LINE CHART PAINTER (UNCHANGED) ---
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  LineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final double minVal = data.reduce((a, b) => a < b ? a : b);
    final double range = maxVal - minVal;

    final double dx = size.width / (data.length - 1);
    const double padding = 10;

    final path = Path();
    path.moveTo(0, _getY(data.first, size, maxVal, minVal, range, padding));

    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final y = _getY(data[i], size, maxVal, minVal, range, padding);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(0, _getY(data.first, size, maxVal, minVal, range, padding));
    for (int i = 1; i < data.length; i++) {
      linePath.lineTo(
          i * dx, _getY(data[i], size, maxVal, minVal, range, padding));
    }
    canvas.drawPath(linePath, linePaint);

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _kCardBackground
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final y = _getY(data[i], size, maxVal, minVal, range, padding);
      canvas.drawCircle(Offset(x, y), 5, borderPaint);
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
  }

  double _getY(
      double value, Size size, double maxVal, double minVal, double range, double padding) {
    if (range == 0) return size.height / 2;
    return size.height -
        padding -
        ((value - minVal) / range) * (size.height - 2 * padding);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.color != color;
}

// --- ASSET PIE CHART (SLIGHTLY ENHANCED) ---
class AssetPieChart extends StatelessWidget {
  const AssetPieChart({super.key});

  final List<Map<String, dynamic>> assetData = const [
    {'label': 'Bonds (Govt/AAA)', 'value': 50.0, 'color': _kPrimaryColor},
    {'label': 'Corporate Debt', 'value': 30.0, 'color': _kAccentSuccess},
    {'label': 'Short-Term Paper', 'value': 20.0, 'color': Color(0xFFE8C200)},
  ];

  @override
  Widget build(BuildContext context) {
    final double total =
    assetData.map((e) => e['value'] as double).reduce((a, b) => a + b);

    //
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        title: const Text("Asset Allocation",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Current Fund Holdings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _kCardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(260, 260),
                        painter: DonutChartPainter(assetData),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Total Assets",
                              style: TextStyle(color: Colors.white60, fontSize: 16)),
                          Text(
                            "100%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                      color: _kAccentSuccess.withOpacity(0.2),
                                      blurRadius: 10),
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Allocation Breakdown",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),

            ...assetData.map((data) {
              final color = data['color'] as Color;
              final label = data['label'] as String;
              final value = data['value'] as double;
              final percentage = (value / total * 100).toStringAsFixed(0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Text(
                      "$percentage%",
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// --- DONUT CHART PAINTER (UNCHANGED) ---
class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double strokeWidth = 35.0; // Increased width for better visual impact

  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final double total = data.map((e) => e['value'] as double).reduce((a, b) => a + b);
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2);

    double currentAngle = -90;

    for (final item in data) {
      final value = item['value'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (value / total) * 360;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        currentAngle * (3.14159265 / 180),
        sweepAngle * (3.14159265 / 180),
        false,
        paint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => true;
}