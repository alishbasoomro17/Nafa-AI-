import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ---------------- THEME ----------------
const Color _kAccentSuccess = Color(0xFFAAF308);
const Color _kPrimaryColor = Color(0xFF6E4BD8);
const Color _kDarkBackground = Colors.black;
const Color _kCardBackground = Color(0xFF1A1A1A);

// ---------------- PAGE ----------------
class FundViewPage extends StatefulWidget {
  final String ticker;

  const FundViewPage({super.key, required this.ticker});

  @override
  State<FundViewPage> createState() => _FundViewPageState();
}

class _FundViewPageState extends State<FundViewPage> {
  Map<String, dynamic>? stockData;
  bool isLoading = true;

  final String BASE_URL = "http://127.0.0.1:3000";

  @override
  void initState() {
    super.initState();
    fetchStock();
  }

  // ---------------- API CALL ----------------
  Future<void> fetchStock() async {
    try {
      final response =
          await http.get(Uri.parse("$BASE_URL/stocks/${widget.ticker}"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          stockData = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load stock");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // ---------------- UI ----------------
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
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _companyHeader(),
            const SizedBox(height: 20),
            _marketStats(),
            const SizedBox(height: 20),
            _financialMetrics(),
            const SizedBox(height: 20),
            _riskSection(),
          ],
        ),
      ),
    );
  }

  // ---------------- COMPANY HEADER ----------------
  Widget _companyHeader() {
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
            child:
                const Icon(Icons.account_balance, color: _kPrimaryColor),
          ),
          const SizedBox(width: 12),
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
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
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
          _metricRow("Daily Return", "${stockData!["DailyReturn"]}%"),
          _metricRow("Market Cap",
              formatMarketCap(stockData!["MarketCap"])),
        ],
      ),
    );
  }

  // ---------------- FINANCIAL METRICS ----------------
  Widget _financialMetrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _metricRow("CAGR", stockData!["CAGR"]),
          _metricRow("Volatility", stockData!["Volatility"]),
          _metricRow("Risk Score", stockData!["RiskScore"]),
          _metricRow("Shares Outstanding",
              stockData!["SharesOutstanding"]),
        ],
      ),
    );
  }

  // ---------------- RISK SECTION ----------------
  Widget _riskSection() {
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
            value: stockData!["RiskLevel"] == "Low"
                ? 0.3
                : stockData!["RiskLevel"] == "Medium"
                    ? 0.6
                    : 0.9,
            backgroundColor: Colors.white12,
            color: _kAccentSuccess,
          ),
          const SizedBox(height: 8),
          Text(
            "${stockData!["RiskLevel"]} Risk",
            style:
                const TextStyle(color: Colors.white70, fontSize: 12),
          )
        ],
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
              style: const TextStyle(
                  color: Colors.white60, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------- FORMAT MARKET CAP ----------------
  String formatMarketCap(String value) {
    double cap = double.parse(value);

    if (cap >= 1e12) {
      return "${(cap / 1e12).toStringAsFixed(2)}T";
    } else if (cap >= 1e9) {
      return "${(cap / 1e9).toStringAsFixed(2)}B";
    } else if (cap >= 1e6) {
      return "${(cap / 1e6).toStringAsFixed(2)}M";
    }
    return cap.toString();
  }
}