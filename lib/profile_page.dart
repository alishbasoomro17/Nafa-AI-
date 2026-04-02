import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'signup.dart';
import 'customer_support_page.dart';
import 'recommendation_page.dart';

// ─── Theme Notifier (global state) ───────────────────────────────────────────
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

final themeNotifier = ThemeNotifier();

// ─── Theme Definitions ────────────────────────────────────────────────────────
class AppThemes {
  static const Color purple = Color(0xFF6E4BD8);
  static const Color green = Color(0xFFAAF308);

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    colorScheme: const ColorScheme.dark(
      primary: purple,
      secondary: green,
      surface: Color(0xFF1A1A1A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A0A),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A0A),
      selectedItemColor: green,
      unselectedItemColor: Colors.white54,
    ),
    cardColor: const Color(0xFF1A1A1A),
  );

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F6FA),
    colorScheme: const ColorScheme.light(
      primary: purple,
      secondary: green,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF4F6FA),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
      titleTextStyle: TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.bold,
          fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: purple,
      unselectedItemColor: Colors.black45,
    ),
    cardColor: Colors.white,
  );
}

// ─── Profile Page ─────────────────────────────────────────────────────────────
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
      builder: (_) => _SuccessDialog(message: message),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _confirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    final isDark = themeNotifier.isDark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppThemes.purple.withOpacity(0.4)),
        ),
        title: Text(title,
            style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold)),
        content: Text(content,
            style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Yes",
                style: TextStyle(color: AppThemes.green)),
          ),
        ],
      ),
    );
  }

  void _passwordUpdated() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF4F6FA);
        final card = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
        final textSecondary =
            isDark ? Colors.white60 : Colors.black54;
        final border = AppThemes.purple.withOpacity(0.25);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () {
                _playClickSound();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
            title: Text("Profile",
                style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            actions: [
              // ── Theme Toggle ──
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    _playClickSound();
                    themeNotifier.toggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 58,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isDark
                          ? AppThemes.purple.withOpacity(0.3)
                          : const Color(0xFFE0E0E0),
                      border: Border.all(
                          color: AppThemes.purple.withOpacity(0.5)),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: isDark
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppThemes.purple
                                  : Colors.orange.shade400,
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ── Avatar ──
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppThemes.purple,
                            AppThemes.purple.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppThemes.purple.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person,
                          size: 55, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppThemes.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(username,
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(email,
                    style:
                        TextStyle(color: textSecondary, fontSize: 14)),

                const SizedBox(height: 28),

                // ── Editable Fields ──
                _sectionLabel("Account Info", textSecondary),
                const SizedBox(height: 10),
                _editableField(
                  label: "Username",
                  icon: Icons.person_outline,
                  controller: usernameController,
                  fieldName: "username",
                  card: card,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  border: border,
                ),
                const SizedBox(height: 12),
                _editableField(
                  label: "Email",
                  icon: Icons.email_outlined,
                  controller: emailController,
                  fieldName: "email",
                  card: card,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  border: border,
                ),

                const SizedBox(height: 28),

                // ── Settings ──
                _sectionLabel("Settings", textSecondary),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.notifications_outlined,
                  label: "Notifications",
                  card: card,
                  textPrimary: textPrimary,
                  border: border,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen())),
                ),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.lock_outline,
                  label: "Change Password",
                  card: card,
                  textPrimary: textPrimary,
                  border: border,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangePasswordScreen(
                              onSuccess: _passwordUpdated))),
                ),

                const SizedBox(height: 28),

                // ── Support ──
                _sectionLabel("Support", textSecondary),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.help_outline,
                  label: "FAQs",
                  card: card,
                  textPrimary: textPrimary,
                  border: border,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FaqsScreen())),
                ),
                const SizedBox(height: 10),
                // // ── Email Contact ──
                // _menuTile(
                //   icon: Icons.mail_outline,
                //   label: "Contact Us via Email",
                //   card: card,
                //   textPrimary: textPrimary,
                //   border: border,
                //   trailing: const Icon(Icons.open_in_new,
                //       size: 16, color: AppThemes.purple),
                //   onTap: () async {
                //     final Uri emailUri = Uri(
                //       scheme: 'mailto',
                //       path: 'support@nafaai.com',
                //       queryParameters: {
                //         'subject': 'Support Request – Nafa AI',
                //         'body':
                //             'Hi Nafa AI Support,\n\nI need help with...',
                //       },
                //     );
                //     if (await canLaunchUrl(emailUri)) {
                //       await launchUrl(emailUri);
                //     } else {
                //       if (context.mounted) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //               content: Text(
                //                   'Could not open email app.')),
                //         );
                //       }
                //     }
                //   },
                // ),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.share_outlined,
                  label: "Share App",
                  card: card,
                  textPrimary: textPrimary,
                  border: border,
                  onTap: () {
                    // TODO: implement share
                  },
                ),

                const SizedBox(height: 28),

                // ── Danger Zone ──
                _sectionLabel("Account", textSecondary),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.logout,
                  label: "Logout",
                  card: card,
                  textPrimary: textPrimary,
                  border: border,
                  iconColor: Colors.orange,
                  onTap: () => _confirmDialog(
                    title: "Logout",
                    content: "Are you sure you want to logout?",
                    onConfirm: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (_) => const SignupScreen())),
                  ),
                ),
                const SizedBox(height: 10),
                _menuTile(
                  icon: Icons.delete_outline,
                  label: "Delete Account",
                  card: card,
                  textPrimary: Colors.redAccent,
                  border: Colors.redAccent.withOpacity(0.2),
                  iconColor: Colors.redAccent,
                  onTap: () => _confirmDialog(
                    title: "Delete Account",
                    content:
                        "This action is permanent. Delete your account?",
                    onConfirm: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (_) => const SignupScreen())),
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
          bottomNavigationBar:
              _bottomNavBar(context, 3, _playClickSound, isDark),
        );
      },
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4),
      ),
    );
  }

  Widget _editableField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String fieldName,
    required Color card,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
  }) {
    bool editing = false;
    return StatefulBuilder(builder: (context, setSB) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: editing
                  ? AppThemes.purple.withOpacity(0.6)
                  : border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppThemes.purple, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: editing
                  ? TextField(
                      controller: controller,
                      autofocus: true,
                      style: TextStyle(color: textPrimary, fontSize: 15),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: TextStyle(
                                color: textSecondary, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(controller.text,
                            style: TextStyle(
                                color: textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
            ),
            GestureDetector(
              onTap: () {
                if (editing) {
                  _updateField(controller, fieldName);
                  _showUpdatePrompt("$label updated!");
                }
                setSB(() => editing = !editing);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: editing
                      ? AppThemes.green.withOpacity(0.15)
                      : AppThemes.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  editing ? Icons.check_rounded : Icons.edit_outlined,
                  size: 18,
                  color:
                      editing ? AppThemes.green : AppThemes.purple,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _menuTile({
    required IconData icon,
    required String label,
    required Color card,
    required Color textPrimary,
    required Color border,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: () {
        _playClickSound();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppThemes.purple, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            trailing ??
                Icon(Icons.chevron_right,
                    color: textPrimary.withOpacity(0.3), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Success Dialog ──────────────────────────────────────────────────────────
class _SuccessDialog extends StatelessWidget {
  final String message;
  const _SuccessDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.isDark;
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppThemes.green, width: 2),
      ),
      content: SizedBox(
        width: 200,
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppThemes.green, size: 44),
            const SizedBox(height: 12),
            Text(message,
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Change Password Screen ───────────────────────────────────────────────────
class ChangePasswordScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const ChangePasswordScreen({super.key, required this.onSuccess});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showNew = false, showConfirm = false;
  final TextEditingController currentCtrl = TextEditingController();
  final TextEditingController newCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg =
            isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF4F6FA);
        final card = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary =
            isDark ? Colors.white : const Color(0xFF1A1A1A);
        final textSecondary = isDark ? Colors.white60 : Colors.black54;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Change Password",
                style: TextStyle(
                    color: textPrimary, fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _passField("Current Password", currentCtrl, false, null,
                    card, textPrimary, textSecondary),
                const SizedBox(height: 14),
                _passField(
                    "New Password",
                    newCtrl,
                    showNew,
                    () => setState(() => showNew = !showNew),
                    card,
                    textPrimary,
                    textSecondary),
                const SizedBox(height: 14),
                _passField(
                    "Confirm Password",
                    confirmCtrl,
                    showConfirm,
                    () => setState(() => showConfirm = !showConfirm),
                    card,
                    textPrimary,
                    textSecondary),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.green,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      _playClickSound();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const _SuccessDialog(
                            message: "Password Updated!"),
                      );
                      Future.delayed(const Duration(milliseconds: 1500),
                          () {
                        Navigator.pop(context);
                        widget.onSuccess();
                      });
                    },
                    child: const Text("Update Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _passField(
    String hint,
    TextEditingController ctrl,
    bool visible,
    VoidCallback? toggle,
    Color card,
    Color textPrimary,
    Color textSecondary,
  ) {
    return TextField(
      controller: ctrl,
      obscureText: !visible,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary),
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppThemes.purple.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppThemes.purple.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppThemes.purple, width: 1.5),
        ),
        prefixIcon:
            const Icon(Icons.lock_outline, color: AppThemes.purple),
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                    visible ? Icons.visibility : Icons.visibility_off,
                    color: AppThemes.purple),
                onPressed: toggle,
              )
            : null,
      ),
    );
  }
}

// ─── Notifications Screen ─────────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg =
            isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF4F6FA);
        final card = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary =
            isDark ? Colors.white : const Color(0xFF1A1A1A);
        final textSecondary = isDark ? Colors.white60 : Colors.black54;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Notifications",
                style: TextStyle(
                    color: textPrimary, fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _card("🎉 Welcome!", "Thank you for joining Nafa AI!", card,
                  textPrimary, textSecondary),
              const SizedBox(height: 12),
              _card("✨ New Feature",
                  "Check out the latest recommendations feature.", card,
                  textPrimary, textSecondary),
            ],
          ),
        );
      },
    );
  }

  Widget _card(String title, String content, Color card, Color textPrimary,
      Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 6),
          Text(content,
              style: TextStyle(color: textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}

// ─── FAQs Screen ─────────────────────────────────────────────────────────────
class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg =
            isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF4F6FA);
        final textPrimary =
            isDark ? Colors.white : const Color(0xFF1A1A1A);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("FAQs",
                style: TextStyle(
                    color: textPrimary, fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              FaqCard("What is Nafa AI?",
                  "Nafa AI is a stock investment recommendation app that provides personalized recommendations based on your profile."),
              FaqCard("Can I perform transactions?",
                  "No, Nafa AI only provides stock recommendations — no buying or selling."),
              FaqCard("How are recommendations personalized?",
                  "The app analyzes your investment profile and suggests stocks suited to your risk level."),
              FaqCard("Is Nafa AI easy to use?",
                  "Absolutely! It's designed to be simple and user-friendly for everyone."),
              FaqCard("Can I learn investing through the app?",
                  "Yes! Nafa AI has a learning module to help you understand investing."),
              FaqCard("How do I contact support?",
                  "Use the 'Contact Us via Email' option on your profile page, or reach us on WhatsApp at 0318-8975730."),
              FaqCard("What if I forgot my password?",
                  "You can reset your password directly from the signup page."),
            ],
          ),
        );
      },
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
    final isDark = themeNotifier.isDark;
    final card = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    return GestureDetector(
      onTap: () => setState(() => open = !open),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: open
                  ? AppThemes.purple.withOpacity(0.5)
                  : AppThemes.purple.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title,
                      style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),
                Icon(
                    open
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppThemes.purple),
              ],
            ),
            if (open)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(widget.content,
                    style:
                        TextStyle(color: textSecondary, fontSize: 13, height: 1.5)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
Widget _bottomNavBar(
    BuildContext context, int currentIndex, VoidCallback playSound, bool isDark) {
  return BottomNavigationBar(
    backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
    selectedItemColor: isDark ? AppThemes.green : AppThemes.purple,
    unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle:
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
    onTap: (index) {
      playSound();
      if (index == currentIndex) return;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
          break;
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const RecommendationPage()));
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
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(Icons.star_outline), label: "Recommendation"),
      BottomNavigationBarItem(
          icon: Icon(Icons.support_agent_outlined), label: "Support"),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_outline), label: "Profile"),
    ],
  );
}
