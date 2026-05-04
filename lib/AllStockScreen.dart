import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fund_page.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class AllStocksScreen extends StatefulWidget {
  const AllStocksScreen({super.key});

  @override
  State<AllStocksScreen> createState() => _AllStocksScreenState();
}
class _LogoWithFallback extends StatefulWidget {
  final List<String> urls;
  final String symbol;
  final double size;

  const _LogoWithFallback({
    required this.urls,
    required this.symbol,
    required this.size,
  });

  @override
  State<_LogoWithFallback> createState() => _LogoWithFallbackState();
}

class _LogoWithFallbackState extends State<_LogoWithFallback> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.urls.length) {
      // All URLs failed — show letter avatar
      return _letterAvatar();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        widget.urls[_currentIndex],
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: const Color(0xFF6E4BD8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFAAF308),
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          // Try next URL
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex++);
          });
          return _letterAvatar();
        },
      ),
    );
  }

  Widget _letterAvatar() {
    final symbol = widget.symbol;
    final initials = symbol.length >= 2 ? symbol.substring(0, 2) : symbol;
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: const Color(0xFF6E4BD8).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF6E4BD8).withOpacity(0.4),
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Color(0xFFAAF308),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _AllStocksScreenState extends State<AllStocksScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isLoading = true;
  List<dynamic> allStocks = [];
  List<dynamic> filteredStocks = [];
  String? errorMessage;
  String searchQuery = '';
  String selectedSector = 'All';
  String selectedShariah = 'All';

  @override
  void initState() {
    super.initState();
    fetchAllStocks();
  }

  // ADD this method inside _AllStocksScreenState
 Widget _stockLogo(String symbol, String companyName, {double size = 42}) {
  // Build list of URLs to try in order
  final attempts = [
    // 1. Logo.dev — works for international companies listed on PSX
    'https://img.logo.dev/${_guessDomain(companyName)}?token=pk_free&size=64&format=png',
    // 2. Clearbit — another logo source
    'https://logo.clearbit.com/${_guessDomain(companyName)}',
    // 3. Google favicon service — works for many domains
    'https://www.google.com/s2/favicons?domain=${_guessDomain(companyName)}&sz=64',
  ];

  return _LogoWithFallback(
    urls: attempts,
    symbol: symbol,
    size: size,
  );
}

String _guessDomain(String companyName) {
  final cleaned = companyName
      .toLowerCase()
      .replaceAll(RegExp(r'\(.*?\)'), '')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
      .trim();

  // Map known PSX companies to their actual domains
  const domainMap = {
    'habib bank': 'hbl.com',
    'national bank': 'nbp.com.pk',
    'meezan bank': 'meezanbank.com',
    'united bank': 'ubldigital.com',
    'mcb bank': 'mcb.com.pk',
    'allied bank': 'abl.com',
    'bank alfalah': 'bankalfalah.com',
    'engro': 'engro.com',
    'lucky cement': 'luckycement.com',
    'nestle': 'nestle.com.pk',
    'unilever': 'unilever.com',
    'honda atlas': 'hondaatlas.com.pk',
    'indus motor': 'toyota.com.pk',
    'pakistan petroleum': 'ppl.com.pk',
    'oil gas development': 'ogdcl.com',
    'pakistan state oil': 'psopk.com',
    'hub power': 'hubpower.com',
    'fauji fertilizer': 'ffc.com.pk',
    'fatima fertilizer': 'fatimafertilizer.com',
    'systems limited': 'systemsltd.com',
    'netsol': 'netsol.com',
    'pakistan tobacco': 'paktobacco.com',
    'colgate': 'colgate.com',
    'glaxosmithkline': 'gsk.com',
    'abbott': 'abbott.com',
    'searle': 'searlecompany.com',
    'bestway cement': 'bestway.com.pk',
    'maple leaf': 'mapleleafcement.com',
    'fauji cement': 'faujicement.com.pk',
    'kohat cement': 'kohatcement.com.pk',
    'attock cement': 'attockcement.com.pk',
    'siemens': 'siemens.com.pk',
    'pakistan cables': 'pakistancables.com',
    'interloop': 'interloop.com.pk',
    'airlink': 'airlink.com.pk',
    'tpl': 'tpl.com.pk',
    'packages': 'packages.com.pk',
    'k electric': 'ke.com.pk',
    'sui northern': 'sngpl.com.pk',
    'sui southern': 'ssgc.com.pk',
    'ptcl': 'ptcl.com.pk',
    'hum network': 'humtv.com',
    'pakistan stock exchange': 'psx.com.pk',
    'psx': 'psx.com.pk',
  };

  // Check domain map first
  for (final entry in domainMap.entries) {
    if (cleaned.contains(entry.key)) return entry.value;
  }

  // Fallback: guess from first word
  final firstWord = cleaned.split(' ').first;
  return '$firstWord.com.pk';
}
  Future<void> fetchAllStocks() async {
    try {
      final prodUrl = dotenv.env['base_url_production'] ?? '';
      final response = await http.get(
        Uri.parse('$prodUrl/stocks/all-stocks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          allStocks = decoded;
          filteredStocks = decoded;
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
  }

  void _applyFilters() {
    setState(() {
      filteredStocks = allStocks.where((stock) {
        final matchSearch =
            stock['name'].toString().toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            stock['symbol'].toString().toLowerCase().contains(
              searchQuery.toLowerCase(),
            );

        final matchSector =
            selectedSector == 'All' || stock['sector'] == selectedSector;

        final matchShariah =
            selectedShariah == 'All' ||
            stock['shariah_status'] == selectedShariah;

        return matchSearch && matchSector && matchShariah;
      }).toList();
    });
  }

  List<String> get sectors {
    final s = allStocks.map((e) => e['sector'].toString()).toSet().toList();
    s.sort();
    return ['All', ...s];
  }

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Sound error: $e");
    }
  }

  String _shariahLabel(String status) {
    final s = status.toLowerCase();
    if (s.contains('non')) return 'Non-Shariah Compliant';
    if (s.contains('compliant')) return 'Shariah Compliant';
    return 'Unknown';
  }

  Color _riskColor(String? risk) {
    if (risk == null) return Colors.white38;
    if (risk.contains('High')) return Colors.redAccent;
    if (risk.contains('Medium')) return Colors.orangeAccent;
    if (risk.contains('Low')) return greenMain;
    return Colors.white38;
  }

  Color _shariahColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('non')) return Colors.redAccent;
    if (s.contains('compliant')) return greenMain;
    return Colors.white54;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "All Stocks",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: purpleAccent))
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                // ── Search Bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search by name or symbol...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: purpleAccent),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      searchQuery = val;
                      _applyFilters();
                    },
                  ),
                ),

                // ── Filters Row ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      // Sector dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedSector,
                          dropdownColor: const Color(0xFF1A1A2E),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          items: sectors
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            selectedSector = val!;
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Shariah dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedShariah,
                          dropdownColor: const Color(0xFF1A1A2E),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          items: ['All', 'Compliant', 'Non-Compliant']
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (val) {
                            selectedShariah = val!;
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Stock Count ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${filteredStocks.length} stocks found",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // ── List ──
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredStocks.length,
                    itemBuilder: (context, index) {
                      final stock = filteredStocks[index];
                      final changeVal = (stock['change'] ?? 0).toDouble();
                      final isPositive = changeVal >= 0;

                      return GestureDetector(
                        onTap: () {
                          _playSound();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FundViewPage(ticker: stock['symbol']),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: purpleAccent.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon
                              // Container(
                              //   width: 42,
                              //   height: 42,
                              //   decoration: BoxDecoration(
                              //     color: purpleAccent.withOpacity(0.15),
                              //     borderRadius: BorderRadius.circular(8),
                              //   ),
                              //   child: const Icon(
                              //     Icons.show_chart,
                              //     color: purpleAccent,
                              //     size: 22,
                              //   ),
                              // ),

                             _stockLogo(stock['symbol'] ?? '', stock['name'] ?? '', size: 42),
                              const SizedBox(width: 12),

                              // Info
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${stock['name']} (${stock['symbol']})",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      stock['sector'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        // ── Shariah tag ──
                                        _tag(
                                          _shariahLabel(
                                            stock['shariah_status'] ?? '',
                                          ),
                                          _shariahColor(
                                            stock['shariah_status'] ?? '',
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // ── Risk Level tag ──
                                        if (stock['risk_level'] != null)
                                          _tag(
                                            stock['risk_level'],
                                            _riskColor(stock['risk_level']),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Price & Change
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Rs ${stock['current_price'] ?? '-'}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPositive
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${isPositive ? '+' : ''}${changeVal.toStringAsFixed(2)}%",
                                      style: TextStyle(
                                        color: isPositive
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
