import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:audioplayers/audioplayers.dart';

// Brand Colors
const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);
const Color darkBg = Color(0xFF1B1B2B);
const Color surfaceDark = Color.fromRGBO(37, 37, 61, 1);

void main() {
  runApp(const MaterialApp(
    home: GuidelinesPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class GuidelinesPage extends StatefulWidget {
  const GuidelinesPage({super.key});

  @override
  State<GuidelinesPage> createState() => _GuidelinesPageState();
}

class _GuidelinesPageState extends State<GuidelinesPage> {
  List<bool> unlockedLessons = [true, false, false, false, false, false];
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> lessons = [
    {
      "title": "Stock Market 101",
      "subtitle": "Understanding Equity",
      "icon": Icons.trending_up,
      "content": """
The stock market is a marketplace where investors trade ownership of companies through shares. It allows you to grow wealth over time, provided you understand the fundamentals.

1. What is a Share?
A share represents a small ownership of a company. Owning shares gives you a claim on profits and dividends. Understanding the difference between common and preferred shares is essential.

2. Why Prices Fluctuate
Prices change due to supply and demand, corporate performance, economic indicators, and investor sentiment. Positive news increases demand, raising prices; negative news increases supply, lowering prices.

3. Market Participants
- Retail Investors: Individuals trading for personal gain.
- Institutional Investors: Banks, funds, and organizations managing large portfolios.
- Market Makers: Ensure liquidity by buying and selling continuously.

4. Stock Exchanges
Stocks trade on exchanges such as NYSE, NASDAQ, and LSE. These provide a regulated environment with transparency and rules.

5. Power of Compounding
Reinvesting profits and dividends can grow your money exponentially over time. A small investment can grow into substantial wealth over decades.

6. Market Cycles
Markets move in Bull (rising) and Bear (falling) cycles. Staying invested during downturns can maximize long-term gains.

7. Investor Psychology
Fear and greed drive many market decisions. Emotional discipline is as important as knowledge.

8. Investment Strategies
- Diversification: Spread across sectors and asset classes.
- Long-term Focus: Avoid panic selling during dips.
- Education: Keep learning via books, articles, and reports.

9. Example Scenario
Investing \$1,000 at \$50/share, if price rises to \$75, grows to \$1,500. Reinvested dividends increase growth further.

10. Further Reading
- "The Intelligent Investor" by Benjamin Graham
- Investopedia: Stock Market Basics

The stock market is a combination of knowledge, strategy, and patience. Understanding fundamentals, cycles, and investor psychology helps you manage risks and make informed decisions.
"""
    },
    {
      "title": "Mutual Funds",
      "subtitle": "Expert Managed Wealth",
      "icon": Icons.account_balance_wallet,
      "content": """
Mutual Funds pool money from multiple investors to invest in a diversified portfolio of stocks, bonds, or other assets, managed by professional fund managers.

1. Benefits of Mutual Funds
- Professional Management: Experts make investment decisions for you.
- Diversification: Spreads risk across multiple assets.
- Liquidity: Easy to redeem your units.
- Affordability: Start investing with small amounts.

2. Types of Funds
- Equity Funds: Primarily stocks for growth.
- Debt Funds: Bonds and fixed income for stability.
- Hybrid Funds: Mix of equity and debt for balanced risk.
- Index Funds: Track market indices with low fees.
- Sector Funds: Focus on specific industries.

3. How Mutual Funds Work
Investors buy units in the fund, and fund managers allocate money based on strategy. The NAV (Net Asset Value) reflects fund performance.

4. Risks
- Market Risk: Value fluctuates with markets.
- Management Risk: Dependence on fund manager’s decisions.
- Inflation Risk: Returns may not always beat inflation.

5. Choosing a Fund
- Assess risk tolerance.
- Examine historical performance.
- Review fees and expenses.
- Align with goals: wealth growth, retirement, or income.

6. Example
Investing \$100 monthly in an equity mutual fund at 12% annual returns could grow to over \$22,000 in 10 years.

7. Tips
- Start early to leverage compounding.
- Use systematic investment plans (SIPs) regularly.
- Diversify across fund types.

Mutual funds are an excellent choice for beginners and experienced investors who want expert management and diversified exposure without monitoring individual stocks.
"""
    },
    {
      "title": "Risk Management",
      "subtitle": "The Art of Not Losing",
      "icon": Icons.shield_outlined,
      "content": """
Risk Management is crucial in investing. Success is not about making the most profit, but protecting capital and minimizing losses.

1. Core Principles
- The 1% Rule: Never risk more than 1% of your portfolio on a single trade.
- Stop-Loss Orders: Predefined exit points prevent catastrophic losses.
- Diversification: Spread investments to reduce exposure.
- Emotional Discipline: Avoid impulsive decisions driven by fear or greed.

2. Types of Risks
- Market Risk: Changes in asset prices.
- Credit Risk: Default of bonds or loans.
- Liquidity Risk: Difficulty converting investments to cash.
- Inflation Risk: Returns might not beat inflation.

3. Tools
- Value at Risk (VaR): Estimate potential losses.
- Beta: Measures volatility relative to market.
- Sharpe Ratio: Assesses risk-adjusted returns.

4. Strategies
- Maintain emergency funds before investing.
- Regularly rebalance portfolio.
- Avoid over-leveraging.
- Continuously educate yourself about new instruments.

5. Examples
Investing \$10,000 in multiple assets with proper stop-losses may limit potential loss to \$500 while allowing growth opportunities.

Risk management ensures sustainability in investing and protects your portfolio against unpredictable market changes. Even small disciplined steps can prevent catastrophic losses over time.
"""
    },
    {
      "title": "Technical Analysis",
      "subtitle": "Reading Market Psychology",
      "icon": Icons.bar_chart_rounded,
      "content": """
Technical Analysis (TA) studies past price and volume patterns to forecast future market movements. It is widely used by traders and investors.

1. Key Concepts
- Support: Price level where a stock tends to stop falling.
- Resistance: Price level where it tends to stop rising.
- Trendlines: Lines connecting highs or lows to determine trend direction.
- Indicators: Tools like RSI, MACD, Bollinger Bands measure momentum and volatility.

2. Chart Patterns
- Head & Shoulders: Predicts reversal.
- Double Top/Bottom: Signals trend changes.
- Triangles & Flags: Continuation patterns.

3. Combining TA with Fundamentals
- Fundamental analysis provides company health, earnings, and sector insight.
- TA helps with timing buy/sell decisions.

4. Common Mistakes
- Ignoring market sentiment.
- Over-relying on a single indicator.
- Trading without a plan.

5. Tips
- Start simple with 1–2 indicators.
- Test strategies on paper first.
- Prioritize risk management.

6. Example
A stock has support at \$50 and resistance at \$65. Buying near support and selling near resistance can optimize returns.

Technical Analysis helps traders make informed short-term decisions while complementing long-term fundamental strategies.
"""
    },
    {
      "title": "Dividend Investing",
      "subtitle": "Passive Income Strategy",
      "icon": Icons.monetization_on_outlined,
      "content": """
Dividend Investing focuses on buying stocks that pay regular dividends, generating passive income while building long-term wealth.

1. Why Dividends Matter
- Provides consistent cash flow.
- Adds stability during volatile markets.
- Can be reinvested for compounding.

2. Selecting Dividend Stocks
- Companies with a consistent dividend history.
- Reasonable payout ratio and growth rate.
- Diversify across sectors.

3. Strategies
- High Yield: Focus on companies with high dividend payouts.
- Dividend Growth: Companies increasing dividends consistently.
- Reinvestment: Reinvest dividends to accelerate wealth.

4. Risks
- Over-reliance on dividends without growth potential.
- Dividend cuts in economic downturns.

5. Example
Investing \$10,000 in dividend-paying stocks at 4% annual yield generates \$400 per year. Reinvesting accelerates growth over time.

Dividend investing is ideal for those seeking steady income alongside long-term capital growth.
"""
    },
    {
      "title": "Crypto Assets",
      "subtitle": "Blockchain Technology",
      "icon": Icons.currency_bitcoin_rounded,
      "content": """
Cryptocurrencies are digital assets secured by blockchain technology, providing decentralized and transparent transactions.

1. Key Cryptocurrencies
- Bitcoin: First decentralized currency, store of value.
- Ethereum: Platform for smart contracts and decentralized apps.

2. High Volatility
Cryptos experience large price swings, requiring mental preparation and risk tolerance.

3. Security
Store crypto in cold wallets or hardware wallets. Use two-factor authentication.

4. Investment Approaches
- Buy and Hold: Long-term investments in established coins.
- Trading: Short-term buy/sell based on market trends.
- Diversification: Spread across multiple coins to reduce risk.

5. Risks
- Regulatory: Governments may restrict usage.
- Market: Prices may fall sharply.
- Security: Vulnerable to hacks if improperly stored.

6. Example
Investing \$1,000 in Bitcoin in 2015 could grow exponentially by 2021. Timing and security are critical.

Cryptocurrencies offer unique opportunities but require careful research, strategy, and risk management.
"""
    },
  ];

  void _unlockNext(int index) {
    if (index + 1 < unlockedLessons.length) {
      setState(() {
        unlockedLessons[index + 1] = true;
      });
    }
  }

  Future<void> _playTune() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      print("Error playing tune: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Learning Path",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          bool isUnlocked = unlockedLessons[index];
          return _buildLessonCard(index, isUnlocked);
        },
      ),
    );
  }

  Widget _buildLessonCard(int index, bool isUnlocked) {
    var lesson = lessons[index];
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _playTune();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleReaderPage(
                lesson: lesson,
                onComplete: () {
                  _unlockNext(index);
                  _playTune();
                },
              ),
            ),
          );
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isUnlocked ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isUnlocked ? purpleAccent.withOpacity(0.5) : Colors.white10,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(lesson['icon'], color: isUnlocked ? greenMain : Colors.white24, size: 28),
                ),
                const Spacer(),
                Text(lesson['title'],
                    style: TextStyle(
                        color: isUnlocked ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(lesson['subtitle'],
                    style: const TextStyle(color: Colors.white38, fontSize: 11)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(isUnlocked ? Icons.check_circle : Icons.lock, size: 14, color: isUnlocked ? greenMain : Colors.white24),
                    const SizedBox(width: 4),
                    Text(isUnlocked ? "Available" : "Locked", style: TextStyle(color: isUnlocked ? greenMain : Colors.white24, fontSize: 11)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================== ARTICLE READER PAGE ==================
class ArticleReaderPage extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final VoidCallback onComplete;

  const ArticleReaderPage({super.key, required this.lesson, required this.onComplete});

  @override
  State<ArticleReaderPage> createState() => _ArticleReaderPageState();
}

class _ArticleReaderPageState extends State<ArticleReaderPage> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0;
  final translator = GoogleTranslator();
  bool showUrdu = false;
  String translatedText = "";
  bool loading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _progress = (_scrollController.offset / _scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
      });
    });
  }

  Future<void> _playTune() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      print("Error playing tune: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 150,
                pinned: true,
                backgroundColor: darkBg,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    onPressed: _translate,
                    icon: loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: greenMain))
                        : Icon(showUrdu ? Icons.translate : Icons.g_translate, color: purpleAccent),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(widget.lesson["title"], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  background: Container(color: darkBg),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: purpleAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(widget.lesson["subtitle"].toUpperCase(), style: const TextStyle(color: purpleAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        showUrdu ? translatedText : widget.lesson["content"],
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18, height: 1.8, letterSpacing: 0.3),
                      ),
                      const SizedBox(height: 60),
                      _buildCompleteButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 56,
            left: 0, right: 0,
            child: Container(
              height: 3,
              color: Colors.white.withOpacity(0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: MediaQuery.of(context).size.width * _progress,
                  color: greenMain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    bool canFinish = _progress > 0.9;
    return GestureDetector(
      onTap: canFinish
          ? () {
        widget.onComplete();
        _playTune();
        Navigator.pop(context);
      }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: canFinish ? greenMain : surfaceDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: canFinish ? [BoxShadow(color: greenMain.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))] : [],
        ),
        child: Center(
          child: Text(
            canFinish ? "MARK AS FINISHED" : "SCROLL TO FINISH",
            style: TextStyle(color: canFinish ? Colors.black : Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }

  Future<void> _translate() async {
    if (translatedText.isEmpty) {
      setState(() => loading = true);
      try {
        var trans = await translator.translate(widget.lesson["content"], to: 'ur');
        setState(() {
          translatedText = trans.text;
          showUrdu = true;
        });
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setState(() => loading = false);
      }
    } else {
      setState(() => showUrdu = !showUrdu);
    }
  }
}