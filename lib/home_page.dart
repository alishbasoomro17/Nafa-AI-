import 'package:flutter/material.dart';
import 'recommendation_page.dart';
import 'customer_support_page.dart';
import 'profile_page.dart';
import 'GuidelinesPage.dart';

const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

class HomePage extends StatelessWidget {
const HomePage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
// Removed AppBar from here to eliminate the top space
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Added a small top padding to avoid sticking to the very edge of the screen/status bar
const SizedBox(height: 40),
_welcomeCard(),
const SizedBox(height: 20),
_profileBox(context),
const SizedBox(height: 20),
_actionGrid(context),
const SizedBox(height: 20),
_learningBox(context),
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
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [purpleAccent, Colors.black]),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.purpleAccent.withOpacity(0.3),
          offset: const Offset(0, 5),
          blurRadius: 10,
        ),
      ],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Nafa AI",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Your personal financial guidance platform for smart and safe investments.",
          style: TextStyle(color: Colors.white70, fontSize: 14),
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
  return Card(
    color: Colors.white10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: greenMain),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      onTap: () => _infoDialog(context, title, detail),
    ),
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
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.black12],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

/* ---------------- LEARNING MODULE ---------------- */
Widget _learningBox(BuildContext context) {
  return _sectionBox(
    title: "Learning Module",
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GuidelinesPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: purpleAccent),
        ),
        child: Row(
          children: [
            const Icon(Icons.school, color: purpleAccent, size: 30),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Start Learning",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: purpleAccent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Go",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/* ---------------- SECTION WRAPPER ---------------- */
Widget _sectionBox({Widget? titleWidget, required Widget child, String? title}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget ??
            Text(
              title ?? '',
              style: const TextStyle(
                  color: greenMain, fontSize: 18, fontWeight: FontWeight.bold),
            ),
        const SizedBox(height: 12),
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
