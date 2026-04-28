import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'signup.dart';
import 'customer_support_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain = Color(0xFFAAF308);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isLoading = true;
  String? errorMessage;

  // User data from API
  String username = '';
  String email = '';
  String role = '';
  String riskCategory = '';
  int? userId;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── Fetch user profile from backend ──
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          errorMessage = 'No token found. Please login again.';
          isLoading = false;
        });
        return;
      }

      // Decode JWT to get user id
      final parts = token.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final id = payload['id'];

      final prodUrl = dotenv.env['base_url_production'] ?? '';
      final response = await http.get(
        Uri.parse('$prodUrl/users/user/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final raw = jsonDecode(response.body);
        // Handle both array and object responses
        final data = raw is List ? raw[0] : raw;

        setState(() {
          userId       = data['id'];
          username     = data['username'] ?? '';
          email        = data['email'] ?? '';
          role         = data['role'] ?? '';
          riskCategory = data['riskCategory'] ?? 'Not assessed';
          usernameController.text = username;
          emailController.text    = email;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      debugPrint('Profile load error: $e');
    }
  }

  void _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('success.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _showUpdatePrompt(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: greenMain, width: 2),
        ),
        content: SizedBox(
          width: 200,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: greenMain, size: 48),
              const SizedBox(height: 12),
              Text(message,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  void _confirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Yes', style: TextStyle(color: greenMain)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SignupScreen()));
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
          onPressed: () {
            _playClickSound();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
        ),
        title: const Text('Profile',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: purpleAccent))
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _loadUserProfile();
                        },
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ── Avatar ──
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: purpleAccent,
                            child:
                                Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: purpleAccent, shape: BoxShape.circle),
                              child: const Icon(Icons.edit,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Role & Risk badges ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _badge(role.toUpperCase(), purpleAccent),
                          const SizedBox(width: 8),
                          _badge(
                            'Risk: $riskCategory',
                            riskCategory == 'High'
                                ? Colors.redAccent
                                : riskCategory == 'Medium'
                                    ? Colors.orangeAccent
                                    : greenMain,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Editable fields ──
                      _editableInfoField(
                          label: 'Username',
                          controller: usernameController,
                          fieldName: 'username'),
                      const SizedBox(height: 16),
                      _editableInfoField(
                          label: 'Email',
                          controller: emailController,
                          fieldName: 'email'),

                      const SizedBox(height: 24),

                      // ── Options ──
                      _optionButton('Notifications', Icons.notifications, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage()));
                      }),
                      const SizedBox(height: 16),
                      _optionButton('Change Password', Icons.lock, () {
                     Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage()));
                      }),
                      const SizedBox(height: 16),
                      _optionButton('FAQs', Icons.help_outline, () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage()));
                      }),
                      const SizedBox(height: 16),
                      _optionButton('Share App', Icons.share, () {}),
                      const SizedBox(height: 16),
                      _optionButton('Delete Account', Icons.delete_forever, () {
                        _confirmDialog(
                          title: 'Delete Account',
                          content:
                              'Are you sure you want to delete your account?',
                          onConfirm: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen())),
                        );
                      }),
                      const SizedBox(height: 16),
                      _optionButton('Logout', Icons.logout, () {
                        _confirmDialog(
                          title: 'Logout',
                          content: 'Are you sure you want to logout?',
                          onConfirm: _logout,
                        );
                      }),
                    ],
                  ),
                ),
      // bottomNavigationBar: _bottomNavBar(context, 3, _playClickSound),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
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
          decoration: _boxDecoration(),
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
                              borderSide: BorderSide.none),
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
                icon: Icon(editing ? Icons.check : Icons.edit,
                    color: editing ? greenMain : purpleAccent),
                onPressed: () {
                  if (editing) {
                    _showUpdatePrompt('$label updated successfully');
                  }
                  setStateSB(() => editing = !editing);
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
            Icon(icon, color: purpleAccent),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: purpleAccent.withOpacity(0.5)),
    );
  }
}