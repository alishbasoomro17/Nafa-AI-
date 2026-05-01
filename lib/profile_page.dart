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
  bool isSaving = false;
  String? errorMessage;

  // User data
  int? userId;
  String role = '';

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRisk = 'Low';

  bool _passwordVisible = false;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── Load profile ──
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() { errorMessage = 'No token found. Please login again.'; isLoading = false; });
        return;
      }

      final parts   = token.split('.');
      final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final id      = payload['id'];

      final prodUrl  = dotenv.env['base_url_production'] ?? '';
      final response = await http.get(
        Uri.parse('$prodUrl/users/user/$id'),
        headers: { 'Authorization': 'Bearer $token', 'Content-Type': 'application/json' },
      );

      if (response.statusCode == 200) {
        final raw  = jsonDecode(response.body);
        final data = raw is List ? raw[0] : raw;

        setState(() {
          userId     = data['id'];
          role       = data['role'] ?? '';
          usernameController.text = data['username']     ?? '';
          emailController.text    = data['email']        ?? '';
          selectedRisk            = data['riskCategory'] ?? 'Low';
          isLoading  = false;
        });
      } else {
        setState(() { errorMessage = 'Failed to load profile (${response.statusCode})'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'Error: $e'; isLoading = false; });
    }
  }

  // ── Save updated profile ──
  Future<void> _saveProfile() async {
    print('Saving profile...');
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final prefs   = await SharedPreferences.getInstance();
      final token   = prefs.getString('token');
      final prodUrl = dotenv.env['base_url_production'] ?? '';

      // Only send password if user typed something
      final Map<String, dynamic> body = {
        'username':     usernameController.text.trim(),
        'email':        emailController.text.trim(),
        'riskCategory': selectedRisk,
      };
      if (passwordController.text.isNotEmpty) {
        body['password'] = passwordController.text;
      }
      print('Request body: $body');
      print("url: $prodUrl/users/update/$userId");

    
      final url = Uri.parse("$prodUrl/users/update/$userId");

      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Update response: ${response}');

      if (response.statusCode == 200) {
        // Update SharedPreferences with new values
        await prefs.setString('username',     usernameController.text.trim());
        await prefs.setString('riskCategory', selectedRisk);

        passwordController.clear();
        setState(() { _isEditing = false; isSaving = false; });
        _showSuccessDialog('Profile updated successfully!');
      } else {
        final err = jsonDecode(response.body);
        print('Error response: $err');
        setState(() => isSaving = false);
        _showErrorSnack(err['message'] ?? 'Update failed');
      }
    } catch (e) {
      print('Network error: $e');
      setState(() => isSaving = false);
      _showErrorSnack('Network error: $e');
    }
  }

  void _playClickSound() async {
    try { await _audioPlayer.play(AssetSource('success.mp3')); } catch (_) {}
  }

  void _showSuccessDialog(String message) {
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
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: greenMain, size: 48),
              const SizedBox(height: 12),
              Text(message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1500), () => Navigator.of(context).pop());
  }

  void _showErrorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  void _confirmDialog({ required String title, required String content, required VoidCallback onConfirm }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No', style: TextStyle(color: Colors.red))),
          TextButton(
            onPressed: () { Navigator.pop(context); onConfirm(); },
            child: const Text('Yes', style: TextStyle(color: greenMain)),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  // ── Validators ──
  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    if (v.trim().length < 6)  return 'At least 6 characters';
    if (v.trim().length > 20) return 'At most 20 characters';
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v.trim())) return 'Letters and spaces only';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return null; // optional — blank = keep existing
    if (v.length < 6)  return 'At least 6 characters';
    if (v.length > 15) return 'At most 15 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add a number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) return 'Add a special character';
    return null;
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
          onPressed: () { _playClickSound(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())); },
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (!isLoading && errorMessage == null)
            TextButton(
              onPressed: () {
                _playClickSound();
                if (_isEditing) {
                  // Cancel — reload original data
                  setState(() { _isEditing = false; });
                  _loadUserProfile();
                } else {
                  setState(() { _isEditing = true; });
                }
              },
              child: Text(
                _isEditing ? 'Cancel' : 'Edit',
                style: const TextStyle(color: greenMain, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: purpleAccent))
          : errorMessage != null
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () { setState(() { isLoading = true; errorMessage = null; }); _loadUserProfile(); },
                      child: const Text('Retry'),
                    ),
                  ],
                ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ── Avatar ──
                        Stack(children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: purpleAccent,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: purpleAccent, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, size: 18, color: Colors.white),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 12),

                        // ── Role badge ──
                        _badge(role.toUpperCase(), purpleAccent),

                        const SizedBox(height: 24),

                        // ── Username ──
                        _fieldBox(
                          label: 'Username',
                          child: TextFormField(
                            controller: usernameController,
                            enabled: _isEditing,
                            validator: _validateUsername,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Enter username'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Email ──
                        _fieldBox(
                          label: 'Email',
                          child: TextFormField(
                            controller: emailController,
                            enabled: _isEditing,
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Enter email'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Password ──
                        _fieldBox(
                          label: 'Password',
                          hint: _isEditing ? 'Leave blank to keep current password' : null,
                          child: TextFormField(
                            controller: passwordController,
                            enabled: _isEditing,
                            validator: _validatePassword,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('New password (optional)').copyWith(
                              suffixIcon: _isEditing
                                  ? IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.white54,
                                      ),
                                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Risk Category ──
                        _fieldBox(
                          label: 'Risk Category',
                          child: _isEditing
                              ? DropdownButtonFormField<String>(
                                  value: selectedRisk,
                                  dropdownColor: Colors.grey[900],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Select risk level'),
                                  items: ['Low', 'Medium', 'High'].map((r) => DropdownMenuItem(
                                    value: r,
                                    child: Row(children: [
                                      Icon(Icons.circle, size: 10,
                                        color: r == 'High' ? Colors.redAccent
                                             : r == 'Medium' ? Colors.orangeAccent
                                             : greenMain),
                                      const SizedBox(width: 8),
                                      Text(r),
                                    ]),
                                  )).toList(),
                                  onChanged: (val) => setState(() => selectedRisk = val!),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  child: Row(children: [
                                    Icon(Icons.circle, size: 10,
                                      color: selectedRisk == 'High' ? Colors.redAccent
                                           : selectedRisk == 'Medium' ? Colors.orangeAccent
                                           : greenMain),
                                    const SizedBox(width: 8),
                                    Text(selectedRisk, style: const TextStyle(color: Colors.white, fontSize: 15)),
                                  ]),
                                ),
                        ),

                        const SizedBox(height: 28),

                        // ── Save Button ──
                        if (_isEditing)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenMain,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: isSaving ? null : _saveProfile,
                              child: isSaving
                                  ? const SizedBox(width: 20, height: 20,
                                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                  : const Text('Save Changes',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),

                        const SizedBox(height: 24),

                        // ── Options ──
                        _optionButton('Notifications', Icons.notifications, () {}),
                        const SizedBox(height: 16),
                        _optionButton('FAQs', Icons.help_outline, () {}),
                        const SizedBox(height: 16),
                        _optionButton('Share App', Icons.share, () {}),
                        const SizedBox(height: 16),
                       _optionButton('Delete Account', Icons.delete_forever, () {
  _confirmDialog(
    title: 'Delete Account',
    content: 'Are you sure you want to delete your account?',
    onConfirm: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final prodUrl = dotenv.env['base_url_production'] ?? '';
      
      final response = await http.delete(
        Uri.parse('$prodUrl/users/delete/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        await prefs.clear();
        if (mounted) Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SignupScreen()));
      } else {
        _showErrorSnack('Failed to delete account');
      }
    },
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

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }

  // ── Helpers ──
  Widget _fieldBox({ required String label, required Widget child, String? hint }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: purpleAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(hint, style: const TextStyle(color: Colors.white24, fontSize: 11)),
          ],
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      disabledBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
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
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _optionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () { _playClickSound(); onTap(); },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: purpleAccent.withOpacity(0.5)),
        ),
        child: Row(children: [
          Icon(icon, color: purpleAccent),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ]),
      ),
    );
  }
}