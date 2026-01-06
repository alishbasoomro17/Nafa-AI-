import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

// Brand Colors
const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);
const Color darkBg = Color(0xFF1B1B2B);
const Color surfaceDark = Color(0xFF25253D);

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

  final List<Map<String, dynamic>> lessons = [
    {
      "title": "Stock Market 101",
      "subtitle": "Understanding Equity",
      "icon": Icons.trending_up,
      "content": """
The stock market is essentially a marketplace where professional and individual investors come together to buy and sell shares of public companies. 

1. What is a Share?
When you buy a share, you are purchasing a piece of the company’s capital. If a company has 1,000 shares and you own 10, you own 1% of that company.

2. Why do Prices Change?
Stock prices change based on supply and demand. If a company reports high profits, more people want to buy it (demand increases), and the price goes up. If the company loses money, people sell (supply increases), and the price goes down.

3. The Power of Compounding
Albert Einstein called compounding the "eighth wonder of the world." If you reinvest your gains, your money starts making money on its own. Over 10-20 years, this can turn small savings into a fortune.

4. Market Cycles
Markets don't go up in a straight line. They move in "Bull" (rising) and "Bear" (falling) phases. The key to wealth is staying invested during the Bear phases so you can profit during the Bull phases.
      """
    },
    {
      "title": "Mutual Funds",
      "subtitle": "Expert Managed Wealth",
      "icon": Icons.account_balance_wallet,
      "content": """
A Mutual Fund is a pool of money managed by a professional Fund Manager. They take money from thousands of investors and invest it in a variety of stocks or bonds.

Benefits of Mutual Funds:
- Professional Management: You don't need to be an expert; the manager does the research for you.
- Diversification: Even with \$10, you can own a tiny piece of 50 different companies, reducing your risk.
- Liquidity: You can usually withdraw your money anytime you need it.

Types of Funds:
- Equity Funds: Invest in stocks (Higher risk, higher reward).
- Debt Funds: Invest in government bonds (Lower risk, steady income).
- Hybrid Funds: A mix of both for balanced growth.

For beginners, "Index Funds" are often recommended because they simply track the top companies (like the S&P 500) and have very low fees.
      """
    },
    {
      "title": "Risk Management",
      "subtitle": "The Art of Not Losing",
      "icon": Icons.shield_outlined,
      "content": """
Successful investing is not about how much you make, but how much you keep. Risk management is the foundation of professional trading.

1. The 1% Rule
Never risk more than 1% of your total account balance on a single trade. If you have \$1,000, you should only risk losing \$10. This ensures that even a string of losses won't wipe you out.

2. Stop-Loss Orders
A stop-loss is an automatic order to sell a stock when it reaches a certain price. It acts as an "emergency brake" to prevent small losses from becoming catastrophic disasters.

3. Diversification
"Don't put all your eggs in one basket." By spreading your money across different sectors (Tech, Healthcare, Energy), you protect yourself if one industry performs poorly.

4. Emotional Discipline
The market is driven by Fear and Greed. Risk management helps you stay logical when everyone else is panicking.
      """
    },
    {
      "title": "Technical Analysis",
      "subtitle": "Reading Market Psychology",
      "icon": Icons.bar_chart_rounded,
      "content": """
Technical Analysis (TA) is the study of historical price action to predict future movements. It is based on the idea that "History tends to repeat itself."

Key Concepts:
- Support: A price level where a falling stock tends to stop and bounce back up. Think of it as a 'floor.'
- Resistance: A price level where a rising stock tends to hit a ceiling and fall back down.
- Trends: The market moves in trends (Uptrend, Downtrend, or Sideways). The famous saying is: "The trend is your friend."

Common Indicators:
- Moving Averages: Smoothens out price data to see the average direction.
- RSI (Relative Strength Index): Tells you if a stock is 'Overbought' (too expensive) or 'Oversold' (too cheap).

TA isn't a crystal ball, but it gives you a statistical edge to make better entries and exits.
      """
    },
    {
      "title": "Dividend Investing",
      "subtitle": "Passive Income Strategy",
      "icon": Icons.monetization_on_outlined,
      "content": """
Dividend investing is the strategy of buying stocks that pay out a portion of their earnings to shareholders regularly.

Why Dividends?
- Passive Income: It’s like receiving a "rent" check from the companies you own.
- Stability: Companies that pay dividends are usually mature, profitable, and stable.
- Reinvestment: You can use dividends to buy more shares (DRIP), which accelerates your compounding growth.

Yield vs. Growth:
Some companies pay a high "Dividend Yield" (e.g., 5%), but their stock price doesn't grow much. Others grow fast but pay smaller dividends. A healthy portfolio usually has a mix of both. 

Imagine owning a share of a beverage company and getting paid every time someone buys a soda. That is the power of dividends.
      """
    },
    {
      "title": "Crypto Assets",
      "subtitle": "Blockchain Technology",
      "icon": Icons.currency_bitcoin_rounded,
      "content": """
Cryptocurrency is a digital or virtual currency secured by cryptography, making it nearly impossible to counterfeit.

1. Bitcoin (Digital Gold)
Bitcoin was the first cryptocurrency. It is decentralized, meaning no government or bank controls it. Its value comes from its limited supply (only 21 million will ever exist).

2. Ethereum & Smart Contracts
Ethereum is more than just money; it’s a platform. It allows developers to build "Smart Contracts"—self-executing contracts with the terms written into code.

3. High Volatility
Crypto is famous for extreme price swings. It can go up 20% in a day and down 30% the next. Because of this, it is considered a "High Risk, High Reward" asset class.

4. Security
In crypto, you are your own bank. You must use hardware wallets and secure your "Seed Phrase." If you lose your keys, you lose your money forever.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleReaderPage(
                lesson: lesson,
                onComplete: () => _unlockNext(index),
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
                  height: 50, width: 50,
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _progress = (_scrollController.offset / _scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
      });
    });
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
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
          // Scroll Progress Bar at the top
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
      onTap: canFinish ? () {
        widget.onComplete();
        Navigator.pop(context);
      } : null,
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
        setState(() { translatedText = trans.text; showUrdu = true; });
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