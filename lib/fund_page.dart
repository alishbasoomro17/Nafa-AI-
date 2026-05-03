import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'home_page.dart';

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
  Map<String, dynamic>? predictionData;
  bool isLoading = true;
  bool isPredicting = false;

  @override
  void initState() {
    super.initState();
    fetchStock();
    get_prediction();
  }

  Future<void> get_prediction() async {
    setState(() => isPredicting = true);
    try {
      final localUrl = dotenv.env['base_url_local'] ?? 'No API Key Found';
      final prodUrl = dotenv.env['base_url_production'] ?? 'No API Key Found';

      final client = http.Client();
      final response = await client
          .post(
            Uri.parse("$prodUrl/predictor/analyze"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"symbol": widget.ticker}),
          )
          .timeout(const Duration(seconds: 60)); // increase timeout

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        setState(() {
          predictionData = Map<String, dynamic>.from(decoded);
          isPredicting = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() => isPredicting = false);
    }
  }

  Future<void> fetchStock() async {
    try {
      final localUrl = dotenv.env['base_url_local'] ?? 'No API Key Found';
      final prodUrl = dotenv.env['base_url_production'] ?? 'No API Key Found';
      final response = await http.get(
        Uri.parse("$prodUrl/stocks/${widget.ticker}"),
      );
      print("urlresponse: $response");

      if (response.statusCode == 200) {
        setState(() {
          stockData = jsonDecode(response.body);
          isLoading = false;
        });
        print("Fetched stock data: $stockData");
      }
    } catch (e) {
      print("Error fetching stock data: $e");
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
        body: Center(child: CircularProgressIndicator(color: _kAccentSuccess)),
      );
    }

    if (stockData == null) {
      return const Scaffold(
        backgroundColor: _kDarkBackground,
        body: Center(
          child: Text(
            "Failed to load data",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    Widget buildReasoningTile(String desc) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.analytics_outlined,
              color: Color(0xFFFF75C3),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget buildSectionCard({
      required String title,
      required List<Widget> children,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      );
    }

    void showReasoningSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows  the sheet to expand for long text
        backgroundColor:
            Colors.transparent, // Crucial for rounded corners & blur
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75, // 75% of screen
            decoration: BoxDecoration(
              color: const Color(
                0xFF121212,
              ).withOpacity(0.95), // Deep dark glass
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              border: Border.all(color: Colors.white10, width: 0.5),
            ),
            child: Column(
              children: [
                // The Sleek Handle (Matches your reference image)
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Header Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        "Analysis Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Confidence Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03E3E).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "75% Accuracy",
                          style: TextStyle(
                            color: Color(0xFFF03E3E),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 32),

                // Scrollable Reasoning List

                // Inside showReasoningSheet...
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      Text(
                        "WHY '${predictionData?['recommendation'] ?? 'LOADING'}'?",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🟪 INSIGHTS CARD
                      if (predictionData != null &&
                          predictionData!['reasoning'] is List)
                        buildSectionCard(
                          title: "Insights",
                          children: List<Widget>.from(
                            (predictionData!['reasoning'] as List).map((item) {
                              return buildReasoningTile(item.toString());
                            }),
                          ),
                        )
                      else
                        const Center(child: CircularProgressIndicator()),

                      // 🟥 RISKS CARD
                      if (predictionData != null &&
                          predictionData!['risks'] is List)
                        buildSectionCard(
                          title: "Future Risks",
                          children: List<Widget>.from(
                            (predictionData!['risks'] as List).map((item) {
                              return buildReasoningTile(item.toString());
                            }),
                          ),
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          stockData!["symbol"] ?? widget.ticker,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          // Symbol badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kPrimaryColor.withOpacity(0.5)),
            ),
            child: Text(
              widget.ticker,
              style: const TextStyle(
                color: _kPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      // Use a Stack to layer the floating tag OVER the scrollable content
      body: Stack(
        children: [
          // LAYER 1: Your scrollable content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _fundHeader(), // The card is still here
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

          // LAYER 2: The Floating Tag (Pinned to the right)
          // LAYER 2: The Floating Tag
          Positioned(
            right: 0,
            top: 150, // Moved it slightly down
            child: GestureDetector(
              onTap: () {
                _playClickSound();
                showReasoningSheet(
                  context,
                ); // This function is created in Step 2
              },
              child:
                  _stockRecommendationTag(), // This remains your existing pink widget
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundHeader() {
    return Stack(
      alignment: Alignment.centerRight, // Align the tag to the right
      children: [
        Container(
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
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: _kPrimaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stockData!["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${stockData!["sector"]} • ${stockData!["shariah_status"]}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Added a spacer so the text doesn't overlap the tag
              const SizedBox(width: 80),
            ],
          ),
        ),
        // This is your new gradient widget pinned to the right
        // Positioned(
        //   right: 0,
        //   child: _stockRecommendationTag(),
        // ),
      ],
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
            // In _actionRow, update the navigation:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PerformanceGraph(
                  stockName: stockData!["name"] ?? widget.ticker,
                  symbol: stockData!["symbol"] ?? widget.ticker,
                  basePrice: (stockData!["current_price"] ?? 0).toDouble(),
                ),
              ),
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

  Widget _iconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
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
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
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
            title: "Daily Change",
            value: "${stockData!["change"] ?? 0}%",
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InsightCard(
            title: "Volume",
            value: formatVolume(stockData!["volume"]),
            icon: Icons.bar_chart,
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
          _metricRow("Open Price", stockData!["open"]),
          _metricRow("High Price", stockData!["high"]),
          _metricRow("Low Price", stockData!["low"]),
          _metricRow("Current Price", stockData!["current_price"]),
          _metricRow("Beta", stockData!["beta"]),
        ],
      ),
    );
  }

  // ---------------- RISK ----------------
  Widget _riskSection() {
    final risk = stockData!["risk_level"]?.toString() ?? '';
    double riskValue = risk.contains("Low")
        ? 0.3
        : risk.contains("Medium")
        ? 0.6
        : risk.contains("High")
        ? 0.9
        : 0.5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Risk Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: riskValue,
            backgroundColor: Colors.white12,
            color: risk.contains("High")
                ? Colors.redAccent
                : risk.contains("Medium")
                ? Colors.orangeAccent
                : _kAccentSuccess,
          ),
          const SizedBox(height: 8),
          Text(
            risk.isEmpty ? 'Unknown' : risk,
            style: const TextStyle(color: Colors.white70),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          _playClickSound();
          _showBrokerSheet(context);
        },
      ),
    );
  }

  void _showBrokerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Choose a Broker",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Select a platform to invest in ${''}this stock",
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),

            _brokerTile(
              context,
              name: "Meezan Bank",
              subtitle: "Islamic Investment Platform",
              icon: Icons.account_balance,
              color: const Color(0xFF00A651),
              url: "https://www.meezanbank.com",
            ),
            _brokerTile(
              context,
              name: "PMEX",
              subtitle: "Pakistan Mercantile Exchange",
              icon: Icons.show_chart,
              color: const Color(0xFF1565C0),
              url: "https://www.pmex.com.pk",
            ),
            _brokerTile(
              context,
              name: "CDC Pakistan",
              subtitle: "Central Depository Company",
              icon: Icons.business,
              color: const Color(0xFFE53935),
              url: "https://www.cdcpakistan.com",
            ),
            _brokerTile(
              context,
              name: "Arif Habib",
              subtitle: "Online Trading Platform",
              icon: Icons.trending_up,
              color: const Color(0xFFFF8F00),
              url: "https://www.arifhabibltd.com",
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _brokerTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        Navigator.pop(context);
        _launchURL(context, url, name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Open $name?", style: const TextStyle(color: Colors.white)),
        content: Text(
          "You will be redirected to $name's website.\n\n$url",
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAccentSuccess,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text(
              "Open",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DIALOG ----------------
  void _timeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: _kCardBackground,
        title: Text("Time to Invest", style: TextStyle(color: Colors.white)),
        content: Text(
          "Market indicators show positive momentum.\n\nThis is a GOOD time to invest.",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _stockRecommendationTag() {
    print(
      "Building recommendation tag with prediction data: $predictionData",
    ); // Debug log
    // Logic for both user types
    String actionNonHolder = isPredicting
        ? "ANALYZING..."
        : (predictionData?['action_for_non_holder'] ?? "NO DATA");

    String actionHolder = isPredicting
        ? "ANALYZING..."
        : (predictionData?['action_for_existing_holder'] ?? "NO SIGNAL");

    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF75C3), Color(0xFFF03E3E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks container to fit text
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Label: For Non-Holders (New Buyers)
          Text(
            "NEW BUYER: ${actionNonHolder.toUpperCase()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 0.5,
            color: Colors.white30,
          ),

          // Bottom Label: For Existing Holders
          Text(
            "HOLDER: ${actionHolder.toUpperCase()}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          Text(
            value?.toString() ?? '-',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MARKET CAP FORMAT ----------------
  String formatVolume(dynamic value) {
    if (value == null) return 'N/A';
    double v = double.tryParse(value.toString()) ?? 0;
    if (v >= 1e9) return "${(v / 1e9).toStringAsFixed(2)}B";
    if (v >= 1e6) return "${(v / 1e6).toStringAsFixed(2)}M";
    if (v >= 1e3) return "${(v / 1e3).toStringAsFixed(1)}K";
    return v.toStringAsFixed(0);
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
          Icon(icon, color: _kAccentSuccess),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }
}


class PerformanceGraph extends StatefulWidget {
  final String stockName;
  final String symbol;
  final double basePrice;

  const PerformanceGraph({
    super.key,
    required this.stockName,
    required this.symbol,
    required this.basePrice,
  });

  @override
  State<PerformanceGraph> createState() => _PerformanceGraphState();
}

class _PerformanceGraphState extends State<PerformanceGraph>
    with SingleTickerProviderStateMixin {

  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> history = [];
  Map<String, dynamic>? stats;
  String selectedRange = '3mo';
  late AnimationController _animController;

  final List<Map<String, String>> ranges = [
    {'label': '1M',  'value': '1mo'},
    {'label': '3M',  'value': '3mo'},
    {'label': '6M',  'value': '6mo'},
    {'label': '1Y',  'value': '1y'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fetchHistory();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() { isLoading = true; errorMessage = null; });

    try {
      final prodUrl = dotenv.env['base_url_production'] ?? '';
      final response = await http.get(
        Uri.parse('$prodUrl/stocks/history/${widget.symbol}?range=$selectedRange'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          history      = List<Map<String, dynamic>>.from(data['history']);
          stats        = Map<String, dynamic>.from(data['stats']);
          isLoading    = false;
        });
        _animController.forward(from: 0);
      } else {
        setState(() {
          errorMessage = 'Failed to load history (${response.statusCode})';
          isLoading    = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading    = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kDarkBackground,
      appBar: AppBar(
        backgroundColor: _kDarkBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.stockName,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            Text(widget.symbol,
                style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: _kAccentSuccess))
          : errorMessage != null
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
                    const SizedBox(height: 12),
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchHistory,
                      style: ElevatedButton.styleFrom(backgroundColor: _kPrimaryColor),
                      child: const Text('Retry'),
                    ),
                  ],
                ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Stats row ──
                      Row(children: [
                        _statCard('Current',  'PKR ${stats!["lastPrice"]}',  _kAccentSuccess),
                        const SizedBox(width: 10),
                        _statCard('High',     'PKR ${stats!["highest"]}',    Colors.orangeAccent),
                        const SizedBox(width: 10),
                        _statCard('Low',      'PKR ${stats!["lowest"]}',     Colors.redAccent),
                      ]),

                      const SizedBox(height: 12),

                      // ── Change banner ──
                      _changeBanner(),

                      const SizedBox(height: 20),

                      // ── Range selector ──
                      Row(
                        children: ranges.map((r) {
                          final isSelected = selectedRange == r['value'];
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedRange = r['value']!);
                              _fetchHistory();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? _kPrimaryColor : Colors.white10,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(r['label']!,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.white54,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  )),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // ── Chart ──
                      Container(
                        height: 280,
                        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                        decoration: BoxDecoration(
                          color: _kCardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: AnimatedBuilder(
                          animation: _animController,
                          builder: (_, __) => CustomPaint(
                            size: Size.infinite,
                            painter: RealChartPainter(
                              history:        history,
                              animationValue: _animController.value,
                              lineColor:      (stats!['changePct'] as num) >= 0
                                              ? _kAccentSuccess
                                              : Colors.redAccent,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── OHLCV Table ──
                      _sectionTitle('Recent Price Data'),
                      const SizedBox(height: 10),
                      _ohlcvTable(),

                      const SizedBox(height: 20),

                      // ── Analysis ──
                      _sectionTitle('Analysis'),
                      const SizedBox(height: 10),
                      _analysisCard(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _changeBanner() {
    final pct      = (stats!['changePct'] as num).toDouble();
    final change   = (stats!['change'] as num).toDouble();
    final isUp     = pct >= 0;
    final color    = isUp ? _kAccentSuccess : Colors.redAccent;
    final icon     = isUp ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${isUp ? '+' : ''}${pct.toStringAsFixed(2)}%  (${isUp ? '+' : ''}PKR ${change.toStringAsFixed(2)})',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'Over ${stats!['totalDays']} trading days  •  $selectedRange',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ]),
      ]),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold));
  }

  Widget _ohlcvTable() {
    // Show last 7 days
    final recent = history.length > 7 ? history.sublist(history.length - 7) : history;
    return Container(
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              _tableHeader('Date',   flex: 3),
              _tableHeader('Open',   flex: 2),
              _tableHeader('Close',  flex: 2),
              _tableHeader('Vol',    flex: 2),
            ]),
          ),
          const Divider(color: Colors.white10, height: 1),
          ...recent.reversed.map((d) {
            final isUp = (d['close'] ?? 0) >= (d['open'] ?? 0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(children: [
                Expanded(flex: 3, child: Text(d['date'] ?? '-',
                    style: const TextStyle(color: Colors.white54, fontSize: 11))),
                Expanded(flex: 2, child: Text('${d['open'] ?? '-'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11))),
                Expanded(flex: 2, child: Text('${d['close'] ?? '-'}',
                    style: TextStyle(
                      color: isUp ? _kAccentSuccess : Colors.redAccent,
                      fontSize: 11, fontWeight: FontWeight.bold,
                    ))),
                Expanded(flex: 2, child: Text(_formatVol(d['volume']),
                    style: const TextStyle(color: Colors.white38, fontSize: 10))),
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _tableHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(text,
          style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _analysisCard() {
    final pct    = (stats!['changePct'] as num).toDouble();
    final prices = history.map((h) => (h['close'] as num).toDouble()).toList();

    // Simple moving average (last 7 days)
    final sma7 = prices.length >= 7
        ? prices.sublist(prices.length - 7).reduce((a, b) => a + b) / 7
        : prices.last;

    // Volatility (std deviation)
    final mean = prices.reduce((a, b) => a + b) / prices.length;
    final variance = prices.map((p) => pow(p - mean, 2)).reduce((a, b) => a + b) / prices.length;
    final stdDev = sqrt(variance);
    final volatilityPct = ((stdDev / mean) * 100).toStringAsFixed(1);

    final trend = pct > 5 ? 'Strong Uptrend 📈'
                : pct > 0 ? 'Mild Uptrend 📈'
                : pct > -5 ? 'Mild Downtrend 📉'
                : 'Strong Downtrend 📉';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: [
        _analysisRow('Trend',          trend),
        _analysisRow('7-Day SMA',      'PKR ${sma7.toStringAsFixed(2)}'),
        _analysisRow('Volatility',     '$volatilityPct%'),
        _analysisRow('Period Change',  '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%'),
        _analysisRow('Trading Days',   '${stats!['totalDays']}'),
        _analysisRow('Price Range',    'PKR ${stats!['lowest']} – ${stats!['highest']}'),
      ]),
    );
  }

  Widget _analysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatVol(dynamic v) {
    if (v == null) return '-';
    final n = (v as num).toDouble();
    if (n >= 1e6) return '${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1e3) return '${(n / 1e3).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}

// ── Real Chart Painter ──
class RealChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;
  final double animationValue;
  final Color lineColor;

  RealChartPainter({
    required this.history,
    required this.animationValue,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final prices = history
        .map((h) => (h['close'] as num?)?.toDouble() ?? 0.0)
        .toList();

    final minPrice = prices.reduce(min);
    final maxPrice = prices.reduce(max);
    final range    = maxPrice - minPrice;
    final padded   = range == 0 ? 1.0 : range;

    final int pointCount = (prices.length * animationValue).ceil().clamp(1, prices.length);

    Offset getPoint(int i) {
      final x = i * size.width / (prices.length - 1);
      final y = size.height - ((prices[i] - minPrice) / padded) * size.height * 0.85 - size.height * 0.05;
      return Offset(x, y);
    }

    // ── Gradient fill ──
    final fillPath = Path()..moveTo(0, size.height);
    for (int i = 0; i < pointCount; i++) {
      fillPath.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    fillPath.lineTo(getPoint(pointCount - 1).dx, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.35), lineColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // ── Line ──
    final linePath = Path()..moveTo(getPoint(0).dx, getPoint(0).dy);
    for (int i = 1; i < pointCount; i++) {
      linePath.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    canvas.drawPath(linePath, Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);

    // ── Y labels ──
    for (int i = 0; i <= 3; i++) {
      final val = minPrice + (padded * i / 3);
      final y   = size.height - (i / 3 * size.height * 0.85) - size.height * 0.05;
      TextPainter(
        text: TextSpan(
          text: val.toStringAsFixed(0),
          style: const TextStyle(color: Colors.white24, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout()..paint(canvas, Offset(4, y - 8));
    }
  }

  @override
  bool shouldRepaint(RealChartPainter old) =>
      old.animationValue != animationValue || old.history != history;
}