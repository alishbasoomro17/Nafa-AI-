import 'package:flutter/material.dart';
import 'recommendation_page.dart';
import 'customer_support_page.dart';
import 'profile_page.dart';
import 'GuidelinesPage.dart'; // <-- New page for full guidelines

const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeCard(),
            const SizedBox(height: 20),
            _profileBox(context),
            const SizedBox(height: 20),
            _actionGrid(context),
            const SizedBox(height: 20),
            _guidelinesBox(context),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context, 0),
    );
  }
}

/* ---------------- WELCOME BOX ---------------- */
Widget _welcomeCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [purpleAccent, Colors.black],
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Nafa AI",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Your personal financial guidance platform for smart and safe investments.",
          style: TextStyle(color: Colors.white70),
        ),
      ],
    ),
  );
}

/* ---------------- PROFILE BOX ---------------- */
Widget _profileBox(BuildContext context) {
  return _sectionBox(
    title: "Your Investment Profile",
    child: Column(
      children: [
        _profileTile(
          context,
          Icons.security,
          "Risk Level",
          "Moderate",
          "Based on your quiz responses, you fall under the moderate risk category, allowing balanced investment decisions.",
        ),
        _profileTile(
          context,
          Icons.flag,
          "Financial Goal",
          "Long-term Growth",
          "Your primary goal is long-term wealth creation through consistent and diversified investments.",
        ),
      ],
    ),
  );
}

Widget _profileTile(
  BuildContext context,
  IconData icon,
  String title,
  String value,
  String detail,
) {
  return ListTile(
    leading: Icon(icon, color: greenMain),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
    onTap: () => _infoDialog(context, title, detail),
  );
}

/* ---------------- ACTION GRID ---------------- */
Widget _actionGrid(BuildContext context) {
  return Row(
    children: [
      _actionBox(
        icon: Icons.trending_up,
        title: "Recommendations",
        color: purpleAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecommendationPage()),
          );
        },
      ),
      const SizedBox(width: 12),
      _actionBox(
        icon: Icons.support_agent,
        title: "Customer Support",
        color: greenMain,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerSupportPage()),
          );
        },
      ),
    ],
  );
}

Widget _actionBox({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/* ---------------- GUIDELINES (Q&A) ---------------- */
Widget _guidelinesBox(BuildContext context) {
  return _sectionBox(
    titleWidget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Investment Guidelines",
          style: TextStyle(
            color: greenMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GuidelinesPage()),
            );
          },
          child: const Text(
            "View All",
            style: TextStyle(
              color: purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
    child: Column(
      children: [
        _qaTile(
          context,
          "What is the Stock Market?",
          "The stock market is a platform where investors buy and sell shares of publicly listed companies. In Pakistan, this is conducted through the Pakistan Stock Exchange (PSX).",
        ),
        _qaTile(
          context,
          "What are Mutual Funds?",
          "Mutual funds collect money from multiple investors and invest it in diversified assets such as stocks and bonds. They are suitable for beginners due to lower risk.",
        ),
        _qaTile(
          context,
          "What is Risk vs Return?",
          "Risk and return are directly related. Investments with higher potential returns usually involve higher risk. Understanding this helps in informed decision-making.",
        ),
        
        _qaTile(
          context,
          "What are Bonds?",
          "Bonds are debt instruments where you lend money to a company or government for a fixed period in exchange for regular interest payments and principal return.",
        ),
        _qaTile(
          context,
          "What is Asset Allocation?",
          "Asset allocation is the process of dividing investments among asset categories like stocks, bonds, and cash to balance risk and reward.",
        ),
      ],
    ),
  );
}

Widget _qaTile(BuildContext context, String question, String answer) {
  return ListTile(
    leading: const Icon(Icons.help_outline, color: purpleAccent),
    title: Text(question, style: const TextStyle(color: Colors.white)),
    onTap: () => _infoDialog(context, question, answer),
  );
}

/* ---------------- SECTION WRAPPER ---------------- */
Widget _sectionBox({Widget? titleWidget, required Widget child, String? title}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget ??
            Text(
              title ?? '',
              style: const TextStyle(
                color: greenMain,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

/* ---------------- INFO DIALOG ---------------- */
void _infoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text(title, style: const TextStyle(color: greenMain)),
      content: Text(message, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK", style: TextStyle(color: purpleAccent)),
        ),
      ],
    ),
  );
}

/* ---------------- BOTTOM NAV ---------------- */
Widget _bottomNavBar(BuildContext context, int currentIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const RecommendationPage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const CustomerSupportPage()));
          break;
        case 3:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.star), label: "Recommendation"),
      BottomNavigationBarItem(
          icon: Icon(Icons.support_agent), label: "Support"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}
