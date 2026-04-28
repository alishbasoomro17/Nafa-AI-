import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'recommendations_screen.dart';
import 'customer_support_page.dart';
import 'profile_page.dart';

import 'GuidelinesPage.dart';
import 'course_page.dart';

const Color greenMain = Color(0xFFAAF308);
const Color purpleAccent = Color(0xFF6E4BD8);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String riskLevel = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchRisk();
  }

  Future<void> fetchRisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        setState(() {
          riskLevel = "No token found";
        });
        return;
      }

      // Decode JWT payload to get user id
      final parts = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final userId = payload["id"];

      final baseUrl = dotenv.env['base_url_production'];

      final url = Uri.parse("$baseUrl/users/user/$userId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("risk response: ${response.body}");
  final data = jsonDecode(response.body);

  // ✅ Handle both array and object responses
  final user = data is List ? data[0] : data;

  setState(() {
    riskLevel = user["riskCategory"] ?? "Unknown";
  });
      } else {
        setState(() {
          riskLevel = "Failed to load";
        });
      }
    } catch (e) {
      setState(() {
        riskLevel = "Error loading risk";
      });
      debugPrint("Risk fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(color: greenMain, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: purpleAccent),
            onPressed: () {
              _playClickSound();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _welcomeCard(),
            const SizedBox(height: 20),
            _profileBox(context, riskLevel),
            const SizedBox(height: 20),
            _actionGrid(context),
            const SizedBox(height: 20),
            _learningModule(context),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context, 0),
    );
  }
}

/* ---------------- AUDIO ---------------- */
final AudioPlayer _audioPlayer = AudioPlayer();

void _playClickSound() async {
  try {
    await _audioPlayer.play(AssetSource('success.mp3'));
  } catch (e) {
    debugPrint("Error playing sound: $e");
  }
}

/* ---------------- WELCOME CARD ---------------- */
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
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Nafa AI",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
Widget _profileBox(BuildContext context, String riskLevel){
  return _sectionBox(
    title: "Your Investment Profile",
    child: Column(
      children: [
        _profileTile(
          context,
          Icons.security,
          "Risk Level",
          riskLevel,
          "Based on your quiz responses, you fall under a specific risk category.",
        ),
        _profileTile(
          context,
          Icons.flag,
          "Financial Goal",
          "Long-term Growth",
          "Your primary goal is long-term wealth creation.",
        ),
      ],
    ),
  );
}

Widget _profileTile(BuildContext context, IconData icon, String title,
    String value, String detail) {
  return Card(
    color: Colors.white10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: greenMain),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      onTap: () {
        _playClickSound();
        _infoDialog(context, title, detail);
      },
    ),
  );
}

/* ---------------- ACTION GRID ---------------- */
Widget _actionGrid(BuildContext context) {
  return Row(
    children: [
      const SizedBox(width: 12),
      _actionBox(
        icon: Icons.support_agent,
        title: "Customer Support",
        color: greenMain,
        onTap: () {
          _playClickSound();
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CustomerSupportPage()));
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
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ],
        ),
      ),
    ),
  );
}

/* ---------------- LEARNING MODULE ---------------- */
Widget _learningModule(BuildContext context) {
  return _sectionBox(
    title: "Learning Module",
    child: Column(
      children: [
        _moduleBox(
          context,
          icon: Icons.school,
          title: "Stock Market Basics",
          onTap: () {
            _playClickSound();
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const GuidelinesPage()));
          },
        ),
        const SizedBox(height: 16),
        _moduleBox(
          context,
          icon: Icons.monetization_on,
          title: "Stock 101 Beginner Course",
          onTap: () {
            _playClickSound();
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FinancialCoursePage()));
          },
        ),
      ],
    ),
  );
}

Widget _moduleBox(BuildContext context,
    {required IconData icon,
    required String title,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: purpleAccent),
      ),
      child: Row(
        children: [
          Icon(icon, color: purpleAccent, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}

/* ---------------- SECTION WRAPPER ---------------- */
Widget _sectionBox(
    {Widget? titleWidget, required Widget child, String? title}) {
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
            Text(title ?? '',
                style: const TextStyle(
                    color: greenMain,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

/* ---------------- DIALOG ---------------- */
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
          child:
              const Text("OK", style: TextStyle(color: purpleAccent)),
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
      _playClickSound();
      if (index == currentIndex) return;

      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 2:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const CustomerSupportPage()));
          break;
        case 3:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(Icons.star), label: "Recommendation"),
      BottomNavigationBarItem(
          icon: Icon(Icons.support_agent), label: "Support"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}