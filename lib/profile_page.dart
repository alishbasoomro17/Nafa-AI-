import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';
import 'signup.dart';
import 'customer_support_page.dart';
import 'recommendation_page.dart';

const Color purpleColor = Color(0xFF7B61FF); // purple shade
const Color primaryColor = Color.fromARGB(255, 23, 7, 26); // primary background
const Color greenMain = Color(0xFFAAF308); // light green for bottom nav & success icons

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Shehnila Narejo";
  String email = "shehnila@example.com";

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    usernameController.text = username;
    emailController.text = email;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void _updateField(TextEditingController controller, String field) {
    _playClickSound();
    setState(() {
      if (field == "username") username = controller.text;
      if (field == "email") email = controller.text;
    });
  }

  void _showUpdatePrompt(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: greenMain, width: 2),
        ),
        content: SizedBox(
          width: 200,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: greenMain, size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _avatar(),
            const SizedBox(height: 30),
            _editableInfoField(
                label: "Username",
                controller: usernameController,
                fieldName: "username"),
            const SizedBox(height: 16),
            _editableInfoField(
                label: "Email",
                controller: emailController,
                fieldName: "email"),
            const SizedBox(height: 24),
            // ================== Options ==================
            _optionButton("Notifications", Icons.notifications, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()));
            }),
            const SizedBox(height: 16),
            _optionButton("Change Password", Icons.lock, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChangePasswordScreen(onSuccess: _passwordUpdated),
                ),
              );
            }),
            const SizedBox(height: 16),
            _optionButton("FAQs", Icons.help_outline, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const FaqsScreen()));
            }),
            const SizedBox(height: 16),
            _optionButton("Share App", Icons.share, () {
              // TODO: implement share functionality
            }),
            const SizedBox(height: 16),
            _optionButton("Delete Account", Icons.delete_forever, () {
              _confirmDialog(
                title: "Delete Account",
                content: "Are you sure you want to delete your account?",
                onConfirm: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()));
                },
              );
            }),
            const SizedBox(height: 16),
            _optionButton("Logout", Icons.logout, () {
              _confirmDialog(
                title: "Logout",
                content: "Are you sure you want to logout?",
                onConfirm: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()));
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context, 3, _playClickSound),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          _playClickSound();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        },
      ),
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xFF7B61FF),
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 18, color: Color(0xFF7B61FF)),
          ),
        ),
      ],
    );
  }

  Widget _editableInfoField({
  required String label,
  required TextEditingController controller,
  required String fieldName,
}) {
  bool editing = false;

  return StatefulBuilder(
    builder: (context, setStateSB) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900], // dark grey background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: purpleColor, width: 2), // purple outline
        ),
        child: Row(
          children: [
            Expanded(
              child: editing
                  ? TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: label,
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: purpleColor), // purple border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: purpleColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: purpleColor, width: 2),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(controller.text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ],
                    ),
            ),
            IconButton(
              icon: Icon(
                editing ? Icons.check : Icons.edit,
                color: editing ? greenMain : purpleColor,
              ),
              onPressed: () {
                if (editing) {
                  _updateField(controller, fieldName);
                  _showUpdatePrompt("$label updated successfully");
                }
                setStateSB(() {
                  editing = !editing;
                });
              },
            ),
          ],
        ),
      );
    },
  );
}

  Widget _optionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF7B61FF)),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: primaryColor.withOpacity(0.5)),
    );
  }

  void _confirmDialog(
      {required String title,
      required String content,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Yes", style: TextStyle(color: greenMain)),
          ),
        ],
      ),
    );
  }

  void _passwordUpdated() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ProfilePage()));
  }
}

/* ================= CHANGE PASSWORD SCREEN ================== */
class ChangePasswordScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const ChangePasswordScreen({super.key, required this.onSuccess});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showNew = false;
  bool showConfirm = false;

  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Change Password",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _passwordField("Current Password", controller: currentController),
            const SizedBox(height: 16),
            _passwordField(
              "New Password",
              controller: newController,
              isVisible: showNew,
              toggle: () => setState(() => showNew = !showNew),
            ),
            const SizedBox(height: 16),
            _passwordField(
              "Confirm New Password",
              controller: confirmController,
              isVisible: showConfirm,
              toggle: () => setState(() => showConfirm = !showConfirm),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenMain,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updatePassword,
                child: const Text(
                  "Update Password",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField(String hint,
      {bool isVisible = false, VoidCallback? toggle, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70),
                onPressed: toggle,
              )
            : null,
      ),
    );
  }

  void _updatePassword() {
    _playClickSound();
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: greenMain, width: 2),
        ),
        content: SizedBox(
          width: 200,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: greenMain, size: 48),
              const SizedBox(height: 12),
              const Text(
                "Password Updated successfully",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
      widget.onSuccess();
    });
  }
}

/* ================== NOTIFICATIONS SCREEN ================== */
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationCard("Welcome!", "Thank you for joining Nafa AI!"),
          const SizedBox(height: 12),
          _notificationCard("New Feature", "Check out the latest recommendations feature."),
        ],
      ),
    );
  }

  Widget _notificationCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

/* ================= FAQs SCREEN ================= */
class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("FAQs", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FaqCard("What is Nafa AI?", "NAFA IA is a stock investment recommendation app that provides personalized stock recommendations based on your profile."),
          FaqCard("Can I perform transactions through NAFA IA?", "No, NAFA IA only provides stock recommendations. It does not allow buying or selling of stocks."),
          FaqCard("How are the recommendations personalized?", "The app analyzes your investment profile and suggests stocks that suit your preferences and risk level."),
          FaqCard("Is NAFA IA easy to use?", "Absolutely! NAFA IA is designed to be simple and user-friendly, making it easy for anyone to get personalized stock recommendations."),
          FaqCard("Can I learn about stock investing through the app?", "Yes, NAFA IA has a learning module where you can easily learn about investing and how to use the app effectively."),
          FaqCard("How do I contact for app realted issues", "You can contact customer support via WhatsApp at 0318-8975730 for any queries or app-related issues."),
          FaqCard("Who can I contact for financial details?", "For any financial-related questions, you can use support feature"),
          FaqCard("What if I forgot my password?", "You can reset your password directly from the signup page."),
        ],
      ),
    );
  }
}

class FaqCard extends StatefulWidget {
  final String title;
  final String content;
  const FaqCard(this.title, this.content, {super.key});

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => open = !open),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: primaryColor),
              ],
            ),
            if (open)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(widget.content,
                    style: const TextStyle(color: Colors.white70)),
              ),
          ],
        ),
      ),
    );
  }
}

/* ================= AUDIO PLAYER ================= */
final AudioPlayer _audioPlayer = AudioPlayer();

void _playSound() async {
  try {
    await _audioPlayer.play(AssetSource('tune.mp3'));
  } catch (e) {
    debugPrint("Error playing tune: $e");
  }
}

/* ================= BOTTOM NAVIGATION WITH SOUND ================= */
Widget _bottomNavBar(BuildContext context, int currentIndex, VoidCallback playSound) {
  return BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: greenMain,
    unselectedItemColor: Colors.white,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      playSound();

      if (index == currentIndex) return;

      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const RecommendationPage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const CustomerSupportPage()));
          break;
        case 3:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.star), label: "Recommendation"),
      BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Support"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}
