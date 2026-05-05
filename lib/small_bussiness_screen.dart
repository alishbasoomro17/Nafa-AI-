import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';
import 'quiz_screen.dart';

const Color _green  = Color(0xFFAAF308);
const Color _purple = Color(0xFF6E4BD8);

class SmallBusinessScreen extends StatelessWidget {
  const SmallBusinessScreen({super.key});

  static const List<Map<String, dynamic>> _ideas = [
    {
      'title': 'Freelance Writing & Content',
      'desc': 'Write articles, blogs, or social media content for businesses. Platforms like Fiverr and Upwork let you start with zero investment.',
      'icon': Icons.edit_note_rounded,
      'color': Color(0xFF6E4BD8),
      'tag': 'Zero Capital',
    },
    {
      'title': 'Online Tutoring',
      'desc': 'Teach subjects you know — Quran, maths, English, or coding — to students online or in your area.',
      'icon': Icons.school_rounded,
      'color': Color(0xFF00BCD4),
      'tag': 'Zero Capital',
    },
    {
      'title': 'Home Cooking & Catering',
      'desc': 'Cook and sell food from home. Start with your neighborhood and grow through word of mouth.',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFFF9800),
      'tag': 'Low Capital',
    },
    {
      'title': 'Social Media Management',
      'desc': 'Manage Instagram, Facebook, or TikTok accounts for small businesses. No degree needed — just skills.',
      'icon': Icons.thumb_up_rounded,
      'color': Color(0xFFE91E63),
      'tag': 'Zero Capital',
    },
    {
      'title': 'Handmade Crafts & Products',
      'desc': 'Sell handmade items — jewelry, candles, or stitching — on Daraz, Facebook Marketplace, or Instagram.',
      'icon': Icons.handyman_rounded,
      'color': Color(0xFF4CAF50),
      'tag': 'Low Capital',
    },
    {
      'title': 'Reselling / Dropshipping',
      'desc': 'Buy products wholesale or dropship without holding inventory. Start on Daraz or OLX.',
      'icon': Icons.local_shipping_rounded,
      'color': Color(0xFF9C27B0),
      'tag': 'Low Capital',
    },
    {
      'title': 'Graphic Design',
      'desc': 'Use free tools like Canva to design logos, posters, and social media graphics for clients.',
      'icon': Icons.brush_rounded,
      'color': Color(0xFFF44336),
      'tag': 'Zero Capital',
    },
    {
      'title': 'Photography & Videography',
      'desc': 'Use your smartphone to offer photography services for events, products, or social media.',
      'icon': Icons.camera_alt_rounded,
      'color': Color(0xFF795548),
      'tag': 'Low Capital',
    },
    {
      'title': 'Virtual Assistant',
      'desc': 'Help businesses with emails, scheduling, data entry, and research — all done remotely.',
      'icon': Icons.support_agent_rounded,
      'color': Color(0xFF00BCD4),
      'tag': 'Zero Capital',
    },
    {
      'title': 'Stitching & Tailoring',
      'desc': 'Offer stitching services from home. Bridal, casual, or alterations — all in high demand locally.',
      'icon': Icons.checkroom_rounded,
      'color': Color(0xFFFF5722),
      'tag': 'Low Capital',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audio = AudioPlayer();

    void playSound() async {
      try { await audio.play(AssetSource('success.mp3')); } catch (_) {}
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const QuizScreen())),
        ),
        title: const Text('Business Ideas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // ── Top banner ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_purple.withOpacity(0.8), _purple.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _purple.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.lightbulb_rounded, color: _green, size: 22),
                  const SizedBox(width: 8),
                  const Text('Smart Move!',
                      style: TextStyle(
                          color: _green, fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'Since your monthly surplus is tight, stock investment may not be the right fit right now. Instead, here are proven ways to build income with little or no starting capital.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 14),
                // ── Read full article button ──
                GestureDetector(
                  onTap: () async {
                    playSound();
                    final uri = Uri.parse('https://momekh.com/15-ways-of-creative-self-employment/');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _green.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new, color: _green, size: 14),
                        SizedBox(width: 6),
                        Text('Read Full Article',
                            style: TextStyle(
                                color: _green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Filter chips ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _chip('All Ideas', true),
              const SizedBox(width: 8),
              _chip('Zero Capital', false),
              const SizedBox(width: 8),
              _chip('Low Capital', false),
            ]),
          ),

          const SizedBox(height: 12),

          // ── Ideas list ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _ideas.length,
              itemBuilder: (context, index) {
                final idea = _ideas[index];
                final color = idea['color'] as Color;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(idea['icon'] as IconData, color: color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                child: Text(idea['title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(idea['tag'],
                                    style: TextStyle(
                                        color: color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                            const SizedBox(height: 6),
                            Text(idea['desc'],
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Bottom CTA ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retake Quiz',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    playSound();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()));
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.home_rounded, color: _green),
                  label: const Text('Go to Home',
                      style: TextStyle(color: _green, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _green),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    playSound();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _purple : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
    );
  }
}