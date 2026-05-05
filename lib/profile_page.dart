import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'signup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const Color purpleAccent = Color(0xFF6E4BD8);
const Color greenMain    = Color(0xFFAAF308);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isLoading = true;
  bool isSaving  = false;
  String? errorMessage;

  int?   userId;
  String role = '';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRisk = 'Low';

  bool _passwordVisible = false;
  bool _isEditing       = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() { super.initState(); _loadUserProfile(); }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

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
          userId                  = data['id'];
          role                    = data['role'] ?? '';
          usernameController.text = data['username']     ?? '';
          emailController.text    = data['email']        ?? '';
          selectedRisk            = data['riskCategory'] ?? 'Low';
          isLoading               = false;
        });
      } else {
        setState(() { errorMessage = 'Failed to load profile (${response.statusCode})'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'Error: $e'; isLoading = false; });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    try {
      final prefs   = await SharedPreferences.getInstance();
      final token   = prefs.getString('token');
      final prodUrl = dotenv.env['base_url_production'] ?? '';

      final Map<String, dynamic> body = {
        'username':     usernameController.text.trim(),
        'email':        emailController.text.trim(),
        'riskCategory': selectedRisk,
      };
      if (passwordController.text.isNotEmpty) body['password'] = passwordController.text;

      final response = await http.patch(
        Uri.parse("$prodUrl/users/update/$userId"),
        headers: { "Authorization": "Bearer $token", "Content-Type": "application/json" },
      );

      if (response.statusCode == 200) {
        await prefs.setString('username', usernameController.text.trim());
        await prefs.setString('riskCategory', selectedRisk);
        passwordController.clear();
        setState(() { _isEditing = false; isSaving = false; });
        _showSuccessDialog('Profile updated successfully!');
      } else {
        final err = jsonDecode(response.body);
        setState(() => isSaving = false);
        _showErrorSnack(err['message'] ?? 'Update failed');
      }
    } catch (e) {
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
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: greenMain.withOpacity(0.6), width: 1.5),
            boxShadow: [ BoxShadow(color: greenMain.withOpacity(0.15), blurRadius: 30) ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: greenMain.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: greenMain.withOpacity(0.4)),
              ),
              child: const Icon(Icons.check_rounded, color: greenMain, size: 36),
            ),
            const SizedBox(height: 16),
            Text(message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _showErrorSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _confirmDialog({ required String title, required String content, required VoidCallback onConfirm }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F1A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: purpleAccent.withOpacity(0.4)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(color: Colors.white54, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenMain,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () { Navigator.pop(context); onConfirm(); },
                  child: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

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
    if (v == null || v.isEmpty) return null;
    if (v.length < 6)  return 'At least 6 characters';
    if (v.length > 15) return 'At most 15 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Add a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add a number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) return 'Add a special character';
    return null;
  }

  Color _riskAccent() {
    if (selectedRisk == 'High')   return Colors.redAccent;
    if (selectedRisk == 'Medium') return Colors.orangeAccent;
    return greenMain;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _playClickSound();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: purpleAccent.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: purpleAccent.withOpacity(0.4)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.4),
        ),
        actions: [
          if (!isLoading && errorMessage == null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  _playClickSound();
                  if (_isEditing) {
                    setState(() => _isEditing = false);
                    _loadUserProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _isEditing ? Colors.white10 : greenMain.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isEditing ? Colors.white24 : greenMain.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Cancel' : 'Edit',
                    style: TextStyle(
                      color: _isEditing ? Colors.white54 : greenMain,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: purpleAccent))
          : errorMessage != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 48),
                  const SizedBox(height: 12),
                  Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: purpleAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () { setState(() { isLoading = true; errorMessage = null; }); _loadUserProfile(); },
                    child: const Text('Retry'),
                  ),
                ]))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [

                      // ── Avatar section ──
                      Stack(alignment: Alignment.center, children: [
                        // Glow ring
                        Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [
                              purpleAccent.withOpacity(0.35),
                              Colors.transparent,
                            ]),
                          ),
                        ),
                        Container(
                          width: 108, height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B63F0), Color(0xFF4B2FA8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: purpleAccent.withOpacity(0.6), width: 2),
                          ),
                          child: const Icon(Icons.person_rounded, size: 52, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 8, right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: greenMain,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF07070F), width: 2),
                            ),
                            child: const Icon(Icons.edit_rounded, size: 14, color: Colors.black),
                          ),
                        ),
                      ]),

                      const SizedBox(height: 14),

                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: purpleAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: purpleAccent.withOpacity(0.5)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: purpleAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 7),
                          Text(role.toUpperCase(),
                            style: const TextStyle(color: purpleAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        ]),
                      ),

                      const SizedBox(height: 28),

                      // ── Fields ──
                      _fieldBox(
                        label: 'Username',
                        icon: Icons.person_outline_rounded,
                        child: TextFormField(
                          controller: usernameController,
                          enabled: _isEditing,
                          validator: _validateUsername,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          decoration: _inputDecoration('Enter username'),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _fieldBox(
                        label: 'Email',
                        icon: Icons.alternate_email_rounded,
                        child: TextFormField(
                          controller: emailController,
                          enabled: _isEditing,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          decoration: _inputDecoration('Enter email'),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _fieldBox(
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        hint: _isEditing ? 'Leave blank to keep current password' : null,
                        child: TextFormField(
                          controller: passwordController,
                          enabled: _isEditing,
                          validator: _validatePassword,
                          obscureText: !_passwordVisible,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          decoration: _inputDecoration('New password (optional)').copyWith(
                            suffixIcon: _isEditing
                                ? IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: Colors.white38, size: 20,
                                    ),
                                    onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Risk Category ──
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: purpleAccent.withOpacity(0.35)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Icon(Icons.speed_rounded, color: _riskAccent(), size: 16),
                            const SizedBox(width: 8),
                            const Text('Risk Category', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 0.3)),
                          ]),
                          const SizedBox(height: 6),
                          _isEditing
                              ? DropdownButtonFormField<String>(
                                  value: selectedRisk,
                                  dropdownColor: const Color(0xFF13131F),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Select risk level'),
                                  items: ['Low', 'Medium', 'High'].map((r) {
                                    final c = r == 'High' ? Colors.redAccent : r == 'Medium' ? Colors.orangeAccent : greenMain;
                                    return DropdownMenuItem(value: r, child: Row(children: [
                                      Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                                      const SizedBox(width: 10),
                                      Text(r),
                                    ]));
                                  }).toList(),
                                  onChanged: (val) => setState(() => selectedRisk = val!),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(children: [
                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: _riskAccent(), shape: BoxShape.circle)),
                                    const SizedBox(width: 10),
                                    Text(selectedRisk, style: const TextStyle(color: Colors.white, fontSize: 15)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: _riskAccent().withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: _riskAccent().withOpacity(0.4)),
                                      ),
                                      child: Text(selectedRisk, style: TextStyle(color: _riskAccent(), fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ]),
                                ),
                        ]),
                      ),

                      const SizedBox(height: 24),

                      // ── Save Button ──
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenMain,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            onPressed: isSaving ? null : _saveProfile,
                            child: isSaving
                                ? const SizedBox(width: 20, height: 20,
                                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.check_rounded, color: Colors.black, size: 20),
                                    SizedBox(width: 8),
                                    Text('Save Changes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                                  ]),
                          ),
                        ),

                      if (_isEditing) const SizedBox(height: 24),

                      // ── Divider ──
                      Row(children: [
                        Expanded(child: Divider(color: Colors.white12, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Settings', style: TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 1)),
                        ),
                        Expanded(child: Divider(color: Colors.white12, thickness: 1)),
                      ]),

                      const SizedBox(height: 20),

                      // ── Option Buttons ──
                     
                      _optionButton('Delete Account', Icons.delete_forever_rounded, Colors.redAccent, () {
                        _confirmDialog(
                          title: 'Delete Account',
                          content: 'Are you sure you want to permanently delete your account?',
                          onConfirm: () async {
                            final prefs   = await SharedPreferences.getInstance();
                            final token   = prefs.getString('token');
                            final prodUrl = dotenv.env['base_url_production'] ?? '';
                            final response = await http.delete(
                              Uri.parse('$prodUrl/users/delete/$userId'),
                              headers: { 'Authorization': 'Bearer $token', 'Content-Type': 'application/json' },
                            );
                            if (response.statusCode == 200) {
                              await prefs.clear();
                              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                            } else {
                              _showErrorSnack('Failed to delete account');
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 12),
                      _optionButton('Logout', Icons.logout_rounded, Colors.orangeAccent, () {
                        _confirmDialog(
                          title: 'Logout',
                          content: 'Are you sure you want to logout?',
                          onConfirm: _logout,
                        );
                      }),
                    ]),
                  ),
                ),
    );
  }

  Widget _fieldBox({ required String label, required IconData icon, required Widget child, String? hint }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: purpleAccent.withOpacity(0.35)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: Colors.white38, size: 15),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 0.3)),
        ]),
        if (hint != null) ...[
          const SizedBox(height: 2),
          Text(hint, style: const TextStyle(color: Colors.white24, fontSize: 11)),
        ],
        child,
      ]),
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

  Widget _optionButton(String title, IconData icon, Color? accentColor, VoidCallback onTap) {
    final color = accentColor ?? purpleAccent;
    return GestureDetector(
      onTap: () { _playClickSound(); onTap(); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Text(title, style: TextStyle(
            color: accentColor != null ? color : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          )),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
        ]),
      ),
    );
  }
}