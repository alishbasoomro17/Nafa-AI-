import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDark = true;
  int _selectedSection = 0;
  bool _drawerOpen = false;
  bool _showUserMenu = false;

  static const kLime   = Color(0xFFAAF308);
  static const kPurple = Color(0xFF6E4BD8);

  Color get kBg     => _isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF4F4F8);
  Color get kCard   => _isDark ? const Color(0xFF12121A) : Colors.white;
  Color get kField  => _isDark ? const Color(0xFF1C1C28) : const Color(0xFFEEEEF5);
  Color get kBorder => _isDark ? const Color(0xFF2E2E42) : const Color(0xFFDDDDEE);
  Color get kText   => _isDark ? Colors.white : const Color(0xFF0A0A0F);
  Color get kSub    => _isDark ? Colors.white38 : Colors.black38;

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.dashboard_rounded,       'label': 'Dashboard'},
    {'icon': Icons.recommend_rounded,       'label': 'Recommendations'},
    {'icon': Icons.school_rounded,          'label': 'Students'},
    {'icon': Icons.payment_rounded,         'label': 'Payment Status'},
    {'icon': Icons.receipt_long_rounded,    'label': 'Payment Proof'},
    {'icon': Icons.account_balance_rounded, 'label': 'Bank Details'},
  ];

  // ── DATA ────────────────────────────────────────────────────────
  List<Map<String, dynamic>> recData = [
    {'title': 'Hub Power Company (HUBC)', 'subtitle': 'Power generation & distribution', 'percent': '+1.2%', 'risk': 'Low',    'shariah': true,  'active': true},
    {'title': 'Lucky Cement (LUCK)',      'subtitle': 'Cement manufacturing',            'percent': '+3.5%', 'risk': 'Medium', 'shariah': true,  'active': true},
    {'title': 'Pakistan Petroleum (PPL)', 'subtitle': 'Oil & Gas Exploration',           'percent': '-0.8%', 'risk': 'High',   'shariah': false, 'active': true},
    {'title': 'Engro Corporation (ENGRO)','subtitle': 'Fertilizers & Chemicals',         'percent': '+2.1%', 'risk': 'Medium', 'shariah': true,  'active': true},
    {'title': 'Bank Al Habib',            'subtitle': 'Banking & Financial Services',    'percent': '+0.9%', 'risk': 'Low',    'shariah': true,  'active': false},
    {'title': 'Meezan Bank',              'subtitle': 'Islamic Banking Services',        'percent': '+1.1%', 'risk': 'Low',    'shariah': true,  'active': true},
  ];

  List<Map<String, dynamic>> studentData = [
    {'name': 'john john',  'email': 'john9@example.com',   'date': 'Mar 11, 2026', 'auth': 'EMAIL'},
    {'name': 'Shehnila',   'email': 'shehnila@gmail.com',  'date': 'Dec 27, 2025', 'auth': 'EMAIL'},
    {'name': 'guest',      'email': 'guest@example.com',   'date': 'Dec 27, 2025', 'auth': 'EMAIL'},
  ];

  final List<Map<String, String>> paymentData = [
    {'id': '#52', 'customer': 'alishba',   'email': 'alishba@gmail.com',   'amount': '\$18.00',       'status': 'no_subscription', 'paid': 'Oct 2, 2025',  'expires': 'Jan 2, 2026'},
    {'id': '#45', 'customer': 'shehnila',  'email': 'shehnila@gmail.com',  'amount': 'PKR 1,000.00', 'status': 'revoked',          'paid': 'Sep 25, 2025', 'expires': 'Sep 26, 2025'},
    {'id': '#30', 'customer': 'kulsoom',   'email': 'kulsoom@gmail.com',   'amount': '\$10.00',       'status': 'inactive',         'paid': 'Sep 21, 2025', 'expires': 'Oct 21, 2025'},
  ];

  // Payment proof: status is mutable (Pending / Approved / Rejected)
  List<Map<String, dynamic>> proofData = [
    {'username': 'shehnilausman', 'email': 'narejo4502932@clo...', 'amount': 'PKR 1000', 'status': 'Approved', 'ref': '55',     'imageBase64': null},
    {'username': 'shehnilausman', 'email': 'narejo4502932@clo...', 'amount': 'PKR 1000', 'status': 'Approved', 'ref': 'Okkkk',  'imageBase64': null},
    {'username': 'narejo',        'email': 'narejo123@gmail.com',  'amount': 'PKR 500',  'status': 'Pending',  'ref': 'REF123', 'imageBase64': null},
  ];

  // Bank: thumbnail stored as base64 string (nullable)
  List<Map<String, dynamic>> bankData = [
    {'name': 'EASY PAISA ACCOUNT',            'title': 'Asia Bibi',               'account': '03408696004', 'iban': 'PK65TMFB00000000...', 'branch': '',                       'status': false, 'date': 'Jul 19, 2025',  'thumbnail': null},
    {'name': 'Payment Link OVERSEAS/Indians', 'title': '',                         'account': '',            'iban': 'https://buy.stripe.com/...', 'branch': 'Copy paste in browser', 'status': false, 'date': 'Dec 13, 2025', 'thumbnail': null},
    {'name': 'BANK AL-FALAH ISLAMIC',         'title': 'TEKRON VENTURES PVT LTD', 'account': '',            'iban': 'PK04ALFH563900500...', 'branch': 'YASEENABAD KARACHI',    'status': false, 'date': 'Aug 13, 2025',  'thumbnail': null},
    {'name': 'JAZZ CASH ACCOUNT',             'title': 'Asia Bibi',               'account': '03408696004', 'iban': '',                    'branch': '',                       'status': true,  'date': 'Jul 30, 2025',  'thumbnail': null},
  ];

  // ── REC FORM ────────────────────────────────────────────────────
  bool showRecForm = false;
  int? editRecIdx;
  final recTitleCtrl    = TextEditingController();
  final recSubtitleCtrl = TextEditingController();
  final recPercentCtrl  = TextEditingController();
  String recRisk    = 'Low';
  bool   recShariah = true;
  bool   recActive  = true;

  // ── BANK FORM ───────────────────────────────────────────────────
  bool showBankForm    = false;
  int? editBankIdx;
  final bankNameCtrl    = TextEditingController();
  final bankTitleCtrl   = TextEditingController();
  final bankAccountCtrl = TextEditingController();
  final bankIbanCtrl    = TextEditingController();
  final bankBranchCtrl  = TextEditingController();
  bool   bankActive     = true;
  String? bankThumbnailBase64; // holds selected thumbnail

  // ── SCROLL CONTROLLERS ──────────────────────────────────────────
  final Map<int, ScrollController> _scrollControllers = {};
  ScrollController scrollFor(int page) {
    _scrollControllers[page] ??= ScrollController();
    return _scrollControllers[page]!;
  }

  @override
  void dispose() {
    recTitleCtrl.dispose(); recSubtitleCtrl.dispose(); recPercentCtrl.dispose();
    bankNameCtrl.dispose(); bankTitleCtrl.dispose();
    bankAccountCtrl.dispose(); bankIbanCtrl.dispose(); bankBranchCtrl.dispose();
    for (final c in _scrollControllers.values) { c.dispose(); }
    super.dispose();
  }

  // ── TOAST ────────────────────────────────────────────────────────
  void showToast(String msg, {bool ok = true}) {
    final ov = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => Positioned(
      top: 40, left: 0, right: 0,
      child: Center(child: Material(color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: ok ? kLime : const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 4))]),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(ok ? Icons.check_circle_rounded : Icons.error_rounded,
              color: ok ? Colors.black : Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(msg, style: TextStyle(color: ok ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
      )),
    ));
    ov.insert(entry);
    Future.delayed(const Duration(seconds: 3), () { if (entry.mounted) entry.remove(); });
  }

  // ── IMAGE PICKER (thumbnail) ─────────────────────────────────────
  Future<String?> pickImageAsBase64() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60, maxWidth: 300);
      if (picked == null) return null;
      final bytes = await picked.readAsBytes();
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(child: GestureDetector(
        onTap: () { if (_showUserMenu) setState(() => _showUserMenu = false); },
        child: Stack(children: [
          Column(children: [
            buildTopBar(),
            Expanded(child: buildCurrentPage()),
          ]),
          if (_drawerOpen) ...[
            GestureDetector(
              onTap: () => setState(() { _drawerOpen = false; _showUserMenu = false; }),
              child: Container(color: Colors.black54)),
            buildSideDrawer(),
          ],
          if (_showUserMenu) buildUserMenu(),
        ]),
      )),
    );
  }

  // ── TOP BAR ─────────────────────────────────────────────────────
  Widget buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: kCard, border: Border(bottom: BorderSide(color: kBorder))),
      child: Row(children: [
        GestureDetector(
          onTap: () => setState(() { _drawerOpen = !_drawerOpen; _showUserMenu = false; }),
          child: Container(width: 34, height: 34,
            decoration: BoxDecoration(color: kField, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBorder)),
            child: Icon(Icons.menu_rounded, color: kText, size: 17))),
        const SizedBox(width: 12),
        Text(menuItems[_selectedSection]['label'],
          style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w700)),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() => _isDark = !_isDark),
          child: Container(width: 46, height: 24,
            decoration: BoxDecoration(
              color: _isDark ? kField : const Color(0xFFE0E0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder)),
            child: Stack(children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: _isDark ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(width: 18, height: 18, margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: _isDark ? kLime : kPurple, shape: BoxShape.circle),
                  child: Icon(_isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 11, color: _isDark ? Colors.black : Colors.white))),
            ]))),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => setState(() { _showUserMenu = !_showUserMenu; _drawerOpen = false; }),
          child: Container(width: 34, height: 34,
            decoration: const BoxDecoration(color: kPurple, shape: BoxShape.circle),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 18))),
      ]),
    );
  }

  // ── USER MENU ────────────────────────────────────────────────────
  Widget buildUserMenu() {
    return Positioned(
      top: 60, right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kBorder))),
              child: Row(children: [
                Container(width: 32, height: 32,
                  decoration: const BoxDecoration(color: kPurple, shape: BoxShape.circle),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 16)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Admin', style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w700)),
                  Text('admin@nafai.com', style: TextStyle(color: kSub, fontSize: 10)),
                ]),
              ]),
            ),
            GestureDetector(
              onTap: () { setState(() => _showUserMenu = false); confirmLogout(); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: const Row(children: [
                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
                  SizedBox(width: 10),
                  Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── SIDE DRAWER ─────────────────────────────────────────────────
  Widget buildSideDrawer() {
    return Positioned(top: 0, left: 0, bottom: 0,
      child: Container(width: 230,
        decoration: BoxDecoration(color: kCard,
          border: Border(right: BorderSide(color: kBorder)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)]),
        child: Column(children: [
          Container(padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kBorder))),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/nafa-logo.jpeg', width: 30, height: 30, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(width: 30, height: 30,
                    decoration: BoxDecoration(color: kLime, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Text('N', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13)))))),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Nafai Ai', style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1)),
                Text('Admin Panel', style: TextStyle(color: kSub, fontSize: 10)),
              ]),
              const Spacer(),
              GestureDetector(onTap: () => setState(() => _drawerOpen = false),
                child: Icon(Icons.close_rounded, color: kSub, size: 15)),
            ])),
          Expanded(child: ListView(padding: const EdgeInsets.all(8),
            children: List.generate(menuItems.length, (i) {
              final sel = _selectedSection == i;
              return GestureDetector(
                onTap: () => setState(() { _selectedSection = i; _drawerOpen = false; }),
                child: Container(margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? kLime.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: sel ? kLime.withValues(alpha: 0.3) : Colors.transparent)),
                  child: Row(children: [
                    Icon(menuItems[i]['icon'], color: sel ? kLime : kSub, size: 16),
                    const SizedBox(width: 9),
                    Text(menuItems[i]['label'], style: TextStyle(color: sel ? kLime : kText, fontSize: 12,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
                    if (sel) ...[const Spacer(), Container(width: 5, height: 5, decoration: const BoxDecoration(color: kLime, shape: BoxShape.circle))],
                  ])));
            }))),
        ])));
  }

  // ── PAGE ROUTER ─────────────────────────────────────────────────
  Widget buildCurrentPage() {
    return Stack(children: [
      IndexedStack(index: _selectedSection, children: [
        scrollPage(0, pageDashboard()),
        scrollPage(1, pageRecommendations()),
        scrollPage(2, pageStudents()),
        scrollPage(3, pagePaymentStatus()),
        scrollPage(4, pagePaymentProof()),
        scrollPage(5, pageBankDetails()),
      ]),
      Positioned(bottom: 20, right: 20,
        child: Column(children: [
          _scrollBtn(Icons.keyboard_arrow_up_rounded,
            () => scrollFor(_selectedSection).animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut)),
          const SizedBox(height: 8),
          _scrollBtn(Icons.keyboard_arrow_down_rounded,
            () => scrollFor(_selectedSection).animateTo(
              scrollFor(_selectedSection).position.maxScrollExtent,
              duration: const Duration(milliseconds: 400), curve: Curves.easeOut)),
        ])),
    ]);
  }

  Widget _scrollBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(width: 36, height: 36,
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)]),
      child: Icon(icon, color: kText, size: 20)));

  Widget scrollPage(int idx, Widget child) => SingleChildScrollView(
    controller: scrollFor(idx),
    padding: const EdgeInsets.fromLTRB(20, 20, 60, 80),
    child: child,
  );

  // ════════════════════════════════════════════════════════════════
  // PAGE 0 — DASHBOARD
  // ════════════════════════════════════════════════════════════════
  Widget pageDashboard() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Welcome back, Admin 👋', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('Platform overview', style: TextStyle(color: kSub, fontSize: 12)),
      const SizedBox(height: 16),
      GridView.count(crossAxisCount: 4, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.6,
        children: [
          miniStat('Students',  '${studentData.length}', Icons.school_rounded,          kLime),
          miniStat('Funds',     '${recData.length}',     Icons.recommend_rounded,        kPurple),
          miniStat('Payments',  '${paymentData.length}', Icons.payment_rounded,          Colors.orange),
          miniStat('Banks',     '${bankData.length}',    Icons.account_balance_rounded,  Colors.cyan),
        ]),
      const SizedBox(height: 20),
      Text('Active Fund Recommendations', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      ...recData.where((r) => r['active'] == true).take(3).map((r) {
        final isPos = !(r['percent'] as String).contains('-');
        return Container(
          margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(11), border: Border.all(color: kBorder)),
          child: Row(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(color: kPurple.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.show_chart, color: kPurple, size: 16)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['title'], style: TextStyle(color: kText, fontWeight: FontWeight.w600, fontSize: 12)),
              Text(r['subtitle'], style: TextStyle(color: kSub, fontSize: 10)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(r['percent'], style: TextStyle(color: isPos ? Colors.green : Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 3),
              shariahBadge(r['shariah']),
            ]),
          ]));
      }),
      const SizedBox(height: 20),
      // Pending proof summary
      Builder(builder: (_) {
        final pending = proofData.where((p) => p['status'] == 'Pending').toList();
        if (pending.isEmpty) return const SizedBox.shrink();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Pending Payment Proofs', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
              child: Text('${pending.length}', style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 8),
          ...pending.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.orange.withValues(alpha: 0.3))),
            child: Row(children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.receipt_long_rounded, color: Colors.orange, size: 14)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['username'], style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600)),
                Text('${p['amount']}  •  Ref: ${p['ref']}', style: TextStyle(color: kSub, fontSize: 10)),
              ])),
              GestureDetector(
                onTap: () => setState(() { _selectedSection = 4; }),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: kPurple.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text('Review', style: TextStyle(color: kPurple, fontSize: 10, fontWeight: FontWeight.w600)))),
            ]))).toList(),
        ]);
      }),
    ]);
  }

  Widget miniStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBorder)),
      child: Row(children: [
        Container(width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 16)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: kSub, fontSize: 10)),
        ]),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // PAGE 1 — RECOMMENDATIONS
  // ════════════════════════════════════════════════════════════════
  Widget pageRecommendations() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Fund Recommendations', style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700)),
          Text('${recData.length} funds • shown in your app', style: TextStyle(color: kSub, fontSize: 11)),
        ]),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            if (showRecForm && editRecIdx == null) { setState(() => showRecForm = false); return; }
            recTitleCtrl.clear(); recSubtitleCtrl.clear(); recPercentCtrl.clear();
            recRisk = 'Low'; recShariah = true; recActive = true; editRecIdx = null;
            setState(() => showRecForm = true);
          },
          icon: Icon(showRecForm && editRecIdx == null ? Icons.close_rounded : Icons.add_rounded, size: 15),
          label: Text(showRecForm && editRecIdx == null ? 'Cancel' : 'Add Fund', style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: (showRecForm && editRecIdx == null) ? kBorder : kLime,
            foregroundColor: (showRecForm && editRecIdx == null) ? kText : Colors.black,
            elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
      ]),
      const SizedBox(height: 14),

      if (showRecForm) ...[
        Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(editRecIdx != null ? 'Edit Fund' : 'Add New Fund',
              style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: labelField(recTitleCtrl, 'Fund Title *', 'e.g. Meezan Bank')),
              const SizedBox(width: 10),
              Expanded(child: labelField(recSubtitleCtrl, 'Subtitle', 'e.g. Islamic Banking')),
              const SizedBox(width: 10),
              Expanded(child: labelField(recPercentCtrl, 'Percent', 'e.g. +1.2%')),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              SizedBox(width: 160, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Risk', style: TextStyle(color: kSub, fontSize: 10, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Container(height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: kField, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBorder)),
                  child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                    value: recRisk, dropdownColor: kCard, isExpanded: true,
                    style: TextStyle(color: kText, fontSize: 12),
                    items: ['Low','Medium','High'].map((r) => DropdownMenuItem(value: r, child: Text(r, style: TextStyle(color: kText)))).toList(),
                    onChanged: (v) => setState(() => recRisk = v!)))),
              ])),
              const SizedBox(width: 16),
              Row(children: [
                tog(recShariah, (v) => setState(() => recShariah = v)),
                const SizedBox(width: 6),
                Text('Shariah', style: TextStyle(color: kText, fontSize: 12)),
              ]),
              const SizedBox(width: 16),
              Row(children: [
                tog(recActive, (v) => setState(() => recActive = v)),
                const SizedBox(width: 6),
                Text('Active', style: TextStyle(color: kText, fontSize: 12)),
              ]),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() { showRecForm = false; editRecIdx = null; }),
                style: TextButton.styleFrom(foregroundColor: kSub),
                child: const Text('Cancel', style: TextStyle(fontSize: 12))),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (recTitleCtrl.text.trim().isEmpty) { showToast('Fund title required', ok: false); return; }
                  setState(() {
                    final rec = {
                      'title': recTitleCtrl.text.trim(), 'subtitle': recSubtitleCtrl.text.trim(),
                      'percent': recPercentCtrl.text.trim().isEmpty ? '0%' : recPercentCtrl.text.trim(),
                      'risk': recRisk, 'shariah': recShariah, 'active': recActive,
                    };
                    if (editRecIdx != null) { recData[editRecIdx!] = rec; showToast('Fund updated!'); }
                    else { recData.add(rec); showToast('Fund added!'); }
                    showRecForm = false; editRecIdx = null;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: kLime, foregroundColor: Colors.black,
                  elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                child: Text(editRecIdx != null ? 'Update' : 'Save', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ]),
          ]),
        ),
      ],

      Container(
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: kBorder)),
        child: Column(children: [
          tHead([
            Expanded(flex: 4, child: tCol('FUND NAME')),
            Expanded(flex: 2, child: tCol('PERCENT')),
            Expanded(flex: 2, child: tCol('RISK')),
            Expanded(flex: 2, child: tCol('SHARIAH')),
            Expanded(flex: 1, child: tCol('ON')),
            Expanded(flex: 2, child: tCol('ACTIONS')),
          ]),
          ...recData.asMap().entries.map((e) {
            final i = e.key; final r = e.value;
            final isPos = !(r['percent'] as String).contains('-');
            return tRow([
              Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['title'], style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600)),
                Text(r['subtitle'], style: TextStyle(color: kSub, fontSize: 10)),
              ])),
              Expanded(flex: 2, child: Text(r['percent'],
                style: TextStyle(color: isPos ? Colors.green : Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 12))),
              Expanded(flex: 2, child: riskBadge(r['risk'])),
              Expanded(flex: 2, child: shariahBadge(r['shariah'])),
              Expanded(flex: 1, child: tog(r['active'], (v) => setState(() => r['active'] = v))),
              Expanded(flex: 2, child: Row(children: [
                iconBtn(Icons.edit_outlined, kSub, kField, () {
                  recTitleCtrl.text = r['title']; recSubtitleCtrl.text = r['subtitle'];
                  recPercentCtrl.text = r['percent']; recRisk = r['risk'];
                  recShariah = r['shariah']; recActive = r['active']; editRecIdx = i;
                  setState(() => showRecForm = true);
                }),
                const SizedBox(width: 8),
                iconBtn(Icons.delete_outline_rounded, Colors.redAccent, Colors.red.withValues(alpha: 0.08), () {
                  setState(() => recData.removeAt(i));
                  showToast('Fund removed', ok: false);
                }),
              ])),
            ]);
          }),
          tFooter('${recData.length} total'),
        ])),
    ]);
  }

  // ════════════════════════════════════════════════════════════════
  // PAGE 2 — STUDENTS  (removed notification column)
  // ════════════════════════════════════════════════════════════════
  Widget pageStudents() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Students', style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text('${studentData.length} registered users', style: TextStyle(color: kSub, fontSize: 11)),
      const SizedBox(height: 14),
      Container(
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: kBorder)),
        child: Column(children: [
          tHead([
            const SizedBox(width: 32),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: tCol('USERNAME')),
            Expanded(flex: 3, child: tCol('EMAIL')),
            Expanded(flex: 2, child: tCol('REGISTERED')),
            Expanded(flex: 1, child: tCol('AUTH')),
          ]),
          ...studentData.asMap().entries.map((e) {
            final s = e.value;
            return tRow([
              CircleAvatar(radius: 13, backgroundColor: kBorder,
                child: Icon(Icons.person_outline_rounded, color: kSub, size: 14)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: Text(s['name'], style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w500))),
              Expanded(flex: 3, child: Text(s['email'], style: TextStyle(color: kSub, fontSize: 11), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: Text(s['date'], style: TextStyle(color: kSub, fontSize: 11))),
              Expanded(flex: 1, child: authBadge(s['auth'])),
            ]);
          }),
          tFooter('${studentData.length} students'),
        ])),
    ]);
  }

  // ════════════════════════════════════════════════════════════════
  // PAGE 3 — PAYMENT STATUS  (read-only, clean view)
  // ════════════════════════════════════════════════════════════════
  Widget pagePaymentStatus() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Payment Status', style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text('${paymentData.length} records', style: TextStyle(color: kSub, fontSize: 11)),
      const SizedBox(height: 14),
      Container(
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: kBorder)),
        child: Column(children: [
          tHead([
            Expanded(flex: 1, child: tCol('ID')),
            Expanded(flex: 2, child: tCol('CUSTOMER')),
            Expanded(flex: 3, child: tCol('EMAIL')),
            Expanded(flex: 2, child: tCol('AMOUNT')),
            Expanded(flex: 2, child: tCol('STATUS')),
            Expanded(flex: 2, child: tCol('PAID')),
            Expanded(flex: 2, child: tCol('EXPIRES')),
          ]),
          ...paymentData.map((p) => tRow([
            Expanded(flex: 1, child: Text(p['id']!, style: TextStyle(color: kSub, fontSize: 11))),
            Expanded(flex: 2, child: Text(p['customer']!, style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w500))),
            Expanded(flex: 3, child: Text(p['email']!, style: TextStyle(color: kSub, fontSize: 11), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(p['amount']!, style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(flex: 2, child: payBadge(p['status']!)),
            Expanded(flex: 2, child: Text(p['paid']!, style: TextStyle(color: kSub, fontSize: 11))),
            Expanded(flex: 2, child: Text(p['expires']!, style: TextStyle(color: kSub, fontSize: 11))),
          ])),
          tFooter('${paymentData.length} total'),
        ])),
    ]);
  }

  // ════════════════════════════════════════════════════════════════
  // PAGE 4 — PAYMENT PROOF  (Approve / Reject actions)
  // ════════════════════════════════════════════════════════════════
  Widget pagePaymentProof() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Payment Proof', style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700)),
          Text('${proofData.length} submissions', style: TextStyle(color: kSub, fontSize: 11)),
        ]),
        const Spacer(),
        // Status counters
        _proofCounter('Pending', Colors.orange, proofData.where((p) => p['status'] == 'Pending').length),
        const SizedBox(width: 8),
        _proofCounter('Approved', Colors.green, proofData.where((p) => p['status'] == 'Approved').length),
        const SizedBox(width: 8),
        _proofCounter('Rejected', Colors.redAccent, proofData.where((p) => p['status'] == 'Rejected').length),
      ]),
      const SizedBox(height: 14),
      Container(
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: kBorder)),
        child: Column(children: [
          tHead([
            Expanded(flex: 2, child: tCol('PROOF IMAGE')),
            Expanded(flex: 2, child: tCol('USERNAME')),
            Expanded(flex: 3, child: tCol('EMAIL')),
            Expanded(flex: 2, child: tCol('AMOUNT')),
            Expanded(flex: 2, child: tCol('STATUS')),
            Expanded(flex: 2, child: tCol('REF ID')),
            Expanded(flex: 3, child: tCol('ACTIONS')),
          ]),
          ...proofData.asMap().entries.map((e) {
            final i = e.key; final p = e.value;
            final status = p['status'] as String;
            final isPending = status == 'Pending';

            return tRow([
              // Proof image
              Expanded(flex: 2, child: GestureDetector(
                onTap: p['imageBase64'] != null ? () => _showImageDialog(p['imageBase64']) : null,
                child: Container(width: 50, height: 36,
                  decoration: BoxDecoration(color: kField, borderRadius: BorderRadius.circular(6), border: Border.all(color: kBorder)),
                  child: p['imageBase64'] != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(6),
                        child: Image.memory(base64Decode(p['imageBase64']), fit: BoxFit.cover))
                    : Icon(Icons.image_outlined, color: kSub, size: 16)),
              )),
              Expanded(flex: 2, child: Text(p['username'], style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w500))),
              Expanded(flex: 3, child: Text(p['email'], style: TextStyle(color: kSub, fontSize: 11), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: Text(p['amount'], style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: proofBadge(status)),
              Expanded(flex: 2, child: Text(p['ref'], style: TextStyle(color: kSub, fontSize: 12))),
              // ACTIONS — Approve / Reject
              Expanded(flex: 3, child: Row(children: [
                if (status != 'Approved') ...[
                  _actionBtn('Approve', Colors.green, () => _updateProofStatus(i, 'Approved')),
                  const SizedBox(width: 6),
                ],
                if (status != 'Rejected') ...[
                  _actionBtn('Reject', Colors.redAccent, () => _confirmReject(i)),
                ],
                if (!isPending && status == 'Rejected') ...[
                  const SizedBox(width: 6),
                  _actionBtn('Pending', Colors.orange, () => _updateProofStatus(i, 'Pending')),
                ],
              ])),
            ]);
          }),
          tFooter('${proofData.length} total'),
        ])),
    ]);
  }

  Widget _proofCounter(String label, Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text('$count $label', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
      ]));
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(5), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700))));
  }

  void _updateProofStatus(int index, String newStatus) {
    setState(() => proofData[index]['status'] = newStatus);
    final color = newStatus == 'Approved' ? 'Approved ✓' : newStatus == 'Rejected' ? 'Rejected' : 'Reset to Pending';
    showToast('$color', ok: newStatus == 'Approved');
  }

  void _confirmReject(int index) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: kCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Reject Proof?', style: TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.w700)),
      content: Text('Reject payment proof from "${proofData[index]['username']}"?', style: TextStyle(color: kSub, fontSize: 13)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
          style: TextButton.styleFrom(foregroundColor: kSub),
          child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { Navigator.pop(ctx); _updateProofStatus(index, 'Rejected'); },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
            elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700))),
      ]));
  }

  void _showImageDialog(String base64) {
    showDialog(context: context, builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.pop(ctx),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(base64Decode(base64), fit: BoxFit.contain)))));
  }

  // ════════════════════════════════════════════════════════════════
  // PAGE 5 — BANK DETAILS  (with thumbnail upload)
  // ════════════════════════════════════════════════════════════════
  Widget pageBankDetails() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bank Details', style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700)),
          Text('${bankData.length} payment methods', style: TextStyle(color: kSub, fontSize: 11)),
        ]),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            if (showBankForm && editBankIdx == null) { setState(() => showBankForm = false); return; }
            bankNameCtrl.clear(); bankTitleCtrl.clear(); bankAccountCtrl.clear();
            bankIbanCtrl.clear(); bankBranchCtrl.clear();
            bankActive = true; bankThumbnailBase64 = null; editBankIdx = null;
            setState(() => showBankForm = true);
          },
          icon: Icon(showBankForm && editBankIdx == null ? Icons.close_rounded : Icons.add_rounded, size: 15),
          label: Text(showBankForm && editBankIdx == null ? 'Cancel' : 'ADD NEW', style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: (showBankForm && editBankIdx == null) ? kBorder : kPurple,
            foregroundColor: Colors.white, elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
      ]),
      const SizedBox(height: 14),

      if (showBankForm) ...[
        Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(editBankIdx != null ? 'Edit Bank Detail' : 'Create New Bank Detail',
              style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: labelField(bankNameCtrl, 'Name *', 'e.g. EASY PAISA')),
              const SizedBox(width: 10),
              Expanded(child: labelField(bankTitleCtrl, 'Account Title', 'e.g. Shehnila Narejo')),
              const SizedBox(width: 10),
              Expanded(child: labelField(bankAccountCtrl, 'Account Number', '03508...')),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: labelField(bankIbanCtrl, 'IBAN / Link', 'PK... or https://...')),
              const SizedBox(width: 10),
              Expanded(child: labelField(bankBranchCtrl, 'Branch Name', 'e.g. Gulshan Karachi')),
              const SizedBox(width: 10),
              // Thumbnail upload
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Thumbnail', style: TextStyle(color: kSub, fontSize: 10, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () async {
                    final b64 = await pickImageAsBase64();
                    if (b64 != null) setState(() => bankThumbnailBase64 = b64);
                  },
                  child: Container(height: 52,
                    decoration: BoxDecoration(
                      color: kField, borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: bankThumbnailBase64 != null ? kPurple : kBorder)),
                    child: bankThumbnailBase64 != null
                      ? Row(children: [
                          ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                            child: Image.memory(base64Decode(bankThumbnailBase64!), width: 52, height: 52, fit: BoxFit.cover)),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Image selected', style: TextStyle(color: kText, fontSize: 11))),
                          GestureDetector(
                            onTap: () => setState(() => bankThumbnailBase64 = null),
                            child: Padding(padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.close_rounded, color: kSub, size: 14))),
                        ])
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.cloud_upload_outlined, color: kSub, size: 16),
                          const SizedBox(width: 6),
                          Text('Upload image', style: TextStyle(color: kSub, fontSize: 11)),
                        ])),
                ),
              ])),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              tog(bankActive, (v) => setState(() => bankActive = v)),
              const SizedBox(width: 8),
              Text('Active', style: TextStyle(color: kText, fontSize: 12)),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() { showBankForm = false; editBankIdx = null; bankThumbnailBase64 = null; }),
                style: TextButton.styleFrom(foregroundColor: kSub),
                child: const Text('Cancel', style: TextStyle(fontSize: 12))),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (bankNameCtrl.text.trim().isEmpty) { showToast('Bank name required', ok: false); return; }
                  setState(() {
                    final bank = {
                      'name': bankNameCtrl.text.trim(), 'title': bankTitleCtrl.text.trim(),
                      'account': bankAccountCtrl.text.trim(), 'iban': bankIbanCtrl.text.trim(),
                      'branch': bankBranchCtrl.text.trim(), 'status': bankActive,
                      'date': DateTime.now().toString().substring(0, 10),
                      'thumbnail': bankThumbnailBase64,
                    };
                    if (editBankIdx != null) {
                      // Keep old thumbnail if no new one picked
                      if (bankThumbnailBase64 == null && bankData[editBankIdx!]['thumbnail'] != null) {
                        bank['thumbnail'] = bankData[editBankIdx!]['thumbnail'];
                      }
                      bankData[editBankIdx!] = bank;
                      showToast('Bank updated!');
                    } else {
                      bankData.add(bank);
                      showToast('Bank added!');
                    }
                    showBankForm = false; editBankIdx = null; bankThumbnailBase64 = null;
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPurple, foregroundColor: Colors.white,
                  elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                child: Text(editBankIdx != null ? 'Update' : 'Create',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
            ]),
          ]),
        ),
      ],

      Container(
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(13), border: Border.all(color: kBorder)),
        child: Column(children: [
          tHead([
            Expanded(flex: 2, child: tCol('THUMBNAIL')),
            Expanded(flex: 3, child: tCol('NAME')),
            Expanded(flex: 3, child: tCol('ACCOUNT TITLE')),
            Expanded(flex: 3, child: tCol('ACCOUNT NO.')),
            Expanded(flex: 3, child: tCol('IBAN / LINK')),
            Expanded(flex: 3, child: tCol('BRANCH')),
            Expanded(flex: 2, child: tCol('ACTIVE')),
            Expanded(flex: 3, child: tCol('CREATED')),
            Expanded(flex: 2, child: tCol('ACTIONS')),
          ]),
          ...bankData.asMap().entries.map((e) {
            final i = e.key; final b = e.value;
            return tRow([
              // Thumbnail cell
              Expanded(flex: 2, child: GestureDetector(
                onTap: b['thumbnail'] != null ? () => _showImageDialog(b['thumbnail']) : null,
                child: Container(width: 40, height: 30,
                  decoration: BoxDecoration(color: kField, borderRadius: BorderRadius.circular(5), border: Border.all(color: kBorder)),
                  child: b['thumbnail'] != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(5),
                        child: Image.memory(base64Decode(b['thumbnail']), fit: BoxFit.cover))
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.image_outlined, color: kSub, size: 11),
                        Text('No img', style: TextStyle(color: kSub, fontSize: 6)),
                      ])),
              )),
              Expanded(flex: 3, child: Text(b['name'], style: TextStyle(color: kText, fontSize: 11, fontWeight: FontWeight.w500))),
              Expanded(flex: 3, child: Text(b['title'], style: TextStyle(color: kSub, fontSize: 11))),
              Expanded(flex: 3, child: Text(b['account'], style: TextStyle(color: kSub, fontSize: 11))),
              Expanded(flex: 3, child: Text(b['iban'], style: TextStyle(color: kSub, fontSize: 10), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 3, child: Text(b['branch'], style: TextStyle(color: kSub, fontSize: 10))),
              Expanded(flex: 2, child: tog(b['status'], (v) => setState(() => b['status'] = v))),
              Expanded(flex: 3, child: Text(b['date'], style: TextStyle(color: kSub, fontSize: 10))),
              Expanded(flex: 2, child: Row(children: [
                iconBtn(Icons.edit_outlined, kSub, kField, () {
                  bankNameCtrl.text    = b['name'];
                  bankTitleCtrl.text   = b['title'];
                  bankAccountCtrl.text = b['account'];
                  bankIbanCtrl.text    = b['iban'];
                  bankBranchCtrl.text  = b['branch'];
                  bankActive           = b['status'];
                  bankThumbnailBase64  = null; // user can pick new or keep old
                  editBankIdx          = i;
                  setState(() => showBankForm = true);
                }),
                const SizedBox(width: 6),
                iconBtn(Icons.delete_outline_rounded, Colors.redAccent, Colors.red.withValues(alpha: 0.08), () {
                  showDialog(context: context, builder: (ctx) => AlertDialog(
                    backgroundColor: kCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    title: Text('Delete Bank?', style: TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.w700)),
                    content: Text('Remove "${b['name']}"?', style: TextStyle(color: kSub, fontSize: 13)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(foregroundColor: kSub),
                        child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () { Navigator.pop(ctx); setState(() => bankData.removeAt(i)); showToast('Bank removed', ok: false); },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                          elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Delete')),
                    ]));
                }),
              ])),
            ]);
          }),
          tFooter('${bankData.length} banks'),
        ])),
    ]);
  }

  // ════════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ════════════════════════════════════════════════════════════════
  Widget tCol(String t) => Text(t, style: TextStyle(color: kSub, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.2));

  Widget tHead(List<Widget> cols) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: kField,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13))),
    child: Row(children: cols));

  Widget tRow(List<Widget> cols) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kBorder.withValues(alpha: 0.4)))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: cols));

  Widget tFooter(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(label, style: TextStyle(color: kSub, fontSize: 11)),
    ]));

  Widget labelField(TextEditingController ctrl, String label, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: kSub, fontSize: 10, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Container(
        decoration: BoxDecoration(color: kField, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBorder)),
        child: TextField(controller: ctrl, style: TextStyle(color: kText, fontSize: 12),
          decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: kSub.withValues(alpha: 0.5)),
            border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9)))),
    ]);
  }

  Widget tog(bool val, ValueChanged<bool> onChange) => GestureDetector(
    onTap: () => onChange(!val),
    child: Container(width: 34, height: 18,
      decoration: BoxDecoration(color: val ? kPurple : kBorder, borderRadius: BorderRadius.circular(9)),
      child: AnimatedAlign(duration: const Duration(milliseconds: 150),
        alignment: val ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(width: 14, height: 14, margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))));

  Widget iconBtn(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: iconColor, size: 14)));

  Widget riskBadge(String risk) {
    final color = risk == 'High' ? Colors.redAccent : risk == 'Medium' ? Colors.orange : Colors.green;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(risk == 'High' ? Icons.arrow_downward : risk == 'Medium' ? Icons.arrow_forward : Icons.arrow_upward, color: color, size: 10),
        const SizedBox(width: 2),
        Text(risk, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
      ]));
  }

  Widget shariahBadge(bool s) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: s ? Colors.green.withValues(alpha: 0.12) : Colors.red.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(4)),
    child: Text(s ? 'Shariah' : 'Non-Shariah',
      style: TextStyle(color: s ? Colors.green : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w600)));

  Widget authBadge(String t) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
    child: Text(t, style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.w600)));

  Widget payBadge(String s) {
    final color = s == 'revoked' ? Colors.red : s.contains('inactive') ? Colors.grey : Colors.orange;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
      child: Text(s, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis));
  }

  Widget proofBadge(String s) {
    final color = s == 'Approved' ? Colors.green : s == 'Rejected' ? Colors.redAccent : Colors.orange;
    final icon  = s == 'Approved' ? Icons.check_circle_outline : s == 'Rejected' ? Icons.cancel_outlined : Icons.hourglass_top_rounded;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 3),
        Text(s, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
      ]));
  }

  void confirmLogout() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: kCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Logout', style: TextStyle(color: kText, fontWeight: FontWeight.w700)),
      content: Text('Are you sure you want to logout?', style: TextStyle(color: kSub, fontSize: 13)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
          style: TextButton.styleFrom(foregroundColor: kSub),
          child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { Navigator.pop(ctx); Navigator.pushReplacementNamed(context, '/login'); },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
            elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700))),
      ]));
  }
}