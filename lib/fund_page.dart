import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your HomePage

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
    const Color accent1 = Color(0xFFAAF308);
    const Color accent2 = Color(0xFF6E4BD8);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.fundName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BANK HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accent2.withOpacity(0.7)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: accent2.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.fundName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      const Text("Money Market Mutual Fund",
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            // BUTTONS ROW
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    title: "Performance",
                    icon: Icons.show_chart,
                    color: accent2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PerformanceGraph()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    title: "Asset Allocation",
                    icon: Icons.pie_chart,
                    color: accent1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AssetPieChart()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _riskBarometer(),
            const SizedBox(height: 20),

            const Text("Investment Calculator",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _calculator(),
            const SizedBox(height: 20),

            _goodTimeButton(),
            const SizedBox(height: 20),

            _investButton(),
            const SizedBox(height: 20),

            // ------------------- Skip button at bottom -------------------
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _showSkipDialog,
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- Skip Confirmation Dialog -------------------
  void _showSkipDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Skip to Home?", style: TextStyle(color: Colors.white)),
        content: const Text(
            "Are you sure you want to go to the Home Page?",
            style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: const Text("Yes", style: TextStyle(color: Color(0xFFAAF308))),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _riskBarometer() {
    const Color accent2 = Color(0xFF6E4BD8);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Risk Barometer",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          Row(
            children: [
              _riskLevel("Low", Colors.blueAccent),
              _riskLevel("Medium", Colors.yellowAccent),
              _riskLevel("High", Colors.redAccent),
            ],
          ),
          const SizedBox(height: 10),
          const Text("This fund is classified as LOW RISK.",
              style: TextStyle(color: Colors.white70, fontSize: 12))
        ],
      ),
    );
  }

  Widget _riskLevel(String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(height: 8, color: color.withOpacity(0.7)),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  // ------------------- Calculator -------------------
  Widget _calculator() {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: _input("Enter Amount (PKR)"),
          onChanged: (v) => setState(() => investAmount = double.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: _input("Months"),
          onChanged: (v) => setState(() => investMonths = int.tryParse(v) ?? 0),
        ),
        const SizedBox(height: 12),
        if (investAmount > 0 && investMonths > 0) _calcResult(),
      ],
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFAAF308))),
    );
  }

  Widget _calcResult() {
    double rate = 0.12; // 12% annual
    double profit = investAmount * rate * (investMonths / 12);
    double total = investAmount + profit;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Expected Profit: PKR ${profit.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white)),
          Text("Total Value: PKR ${total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _goodTimeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6E4BD8),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text("Investment Timing", style: TextStyle(color: Colors.white)),
            content: const Text(
                "Market conditions indicate this is a GOOD TIME to invest.\n\nExpected yield increasing over next 3 months.",
                style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close", style: TextStyle(color: Color(0xFFAAF308)))),
            ],
          ),
        );
      },
      child: const Text("Check if it’s good time to invest"),
    );
  }

  // ------------------- Invest Now -------------------
  Widget _investButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFAAF308),
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text("Coming Soon", style: TextStyle(color: Colors.white)),
            content: const Text("Investment feature will be available soon.",
                style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK", style: TextStyle(color: Color(0xFFAAF308)))),
            ],
          ),
        );
      },
      child: const Text("Invest Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------- PERFORMANCE GRAPH ----------------
class PerformanceGraph extends StatelessWidget {
  const PerformanceGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [5, 10, 8, 12, 15];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Performance Graph", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: data
              .map((val) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: val * 15.0,
                      color: Colors.blueAccent,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ---------------- ASSET PIE CHART ----------------
class AssetPieChart extends StatelessWidget {
  const AssetPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [50.0, 30.0, 20.0];
    final colors = [Colors.blueAccent, Colors.green, Colors.yellow];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Asset Allocation", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              for (int i = 0; i < data.length; i++)
                PieSlice(
                  startAngle: i == 0 ? 0 : data.sublist(0, i).reduce((a, b) => a + b) / 100 * 360,
                  sweepAngle: data[i] / 100 * 360,
                  color: colors[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// PIE SLICE WIDGET
class PieSlice extends StatelessWidget {
  final double startAngle;
  final double sweepAngle;
  final Color color;
  const PieSlice(
      {super.key, required this.startAngle, required this.sweepAngle, required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: sweepAngle),
      duration: const Duration(milliseconds: 500),
      builder: (context, angle, child) => Transform.rotate(
        angle: startAngle * 3.14159265 / 180,
        child: CustomPaint(
          size: const Size(200, 200),
          painter: PiePainter(angle, color),
        ),
      ),
    );
  }
}

class PiePainter extends CustomPainter {
  final double sweep;
  final Color color;
  PiePainter(this.sweep, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..color = color;
    canvas.drawArc(rect, 0, sweep * 3.14159265 / 180, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
