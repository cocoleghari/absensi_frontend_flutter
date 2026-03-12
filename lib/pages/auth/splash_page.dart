import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
class AppColors {
  static const red = Color(0xFFE9573F);
  static const redLight = Color(0xFFFF7A5C);
  static const blue = Color(0xFF1B6EF3);
  static const blueDeep = Color(0xFF1044C0);
  static const blueSoft = Color(0xFF5B8EF0);
  static const bluePale = Color(0xFFEDF2FF);
  static const green = Color(0xFF0EA87E);
  static const greenDeep = Color(0xFF077A5C);
  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1A2E);
  static const muted = Color(0xFF8A8FA8);
}

// ─────────────────────────────────────────────
//  SLIDE DATA MODEL
// ─────────────────────────────────────────────
class _Slide {
  final String tag;
  final String title;
  final String titleAccent;
  final String body;
  final IconData heroIcon;
  final List<Color> gradient;
  final Color accent;
  final List<({IconData icon, String label, String value})> stats;

  const _Slide({
    required this.tag,
    required this.title,
    required this.titleAccent,
    required this.body,
    required this.heroIcon,
    required this.gradient,
    required this.accent,
    required this.stats,
  });
}

const _kSlides = [
  _Slide(
    tag: 'ABSENSI DIGITAL',
    title: 'Catat Kehadiran\n',
    titleAccent: 'Lebih Cepat & Akurat',
    body:
        'Rekam absensi karyawan secara real-time\nlangsung dari smartphone Anda.',
    heroIcon: Icons.fingerprint_rounded,
    gradient: [Color(0xFF1B6EF3), Color(0xFF1044C0)],
    accent: AppColors.blue,
    stats: [
      (icon: Icons.bolt_rounded, label: 'Real-time', value: '< 1s'),
      (icon: Icons.location_on_rounded, label: 'GPS Akurat', value: '99%'),
      (icon: Icons.history_rounded, label: 'Riwayat', value: '∞'),
    ],
  ),
  _Slide(
    tag: 'MANAJEMEN SDM',
    title: 'Kelola Karyawan\n',
    titleAccent: 'Tanpa Kerumitan',
    body:
        'Dashboard lengkap untuk data karyawan,\njadwal shift, dan pengajuan cuti.',
    heroIcon: Icons.people_alt_rounded,
    gradient: [Color(0xFFE9573F), Color(0xFFBF3A24)],
    accent: AppColors.red,
    stats: [
      (icon: Icons.dashboard_rounded, label: 'Dashboard', value: '1 Layar'),
      (icon: Icons.edit_calendar_rounded, label: 'Shift', value: 'Fleksibel'),
      (icon: Icons.beach_access_rounded, label: 'Cuti & Izin', value: 'Online'),
    ],
  ),
  _Slide(
    tag: 'LAPORAN INSTAN',
    title: 'Ekspor Laporan\n',
    titleAccent: 'Dalam Sekejap',
    body: 'Buat laporan absensi bulanan otomatis\ndalam format PDF atau Excel.',
    heroIcon: Icons.insert_chart_rounded,
    gradient: [Color(0xFF0EA87E), Color(0xFF077A5C)],
    accent: AppColors.green,
    stats: [
      (icon: Icons.picture_as_pdf_rounded, label: 'PDF', value: 'Otomatis'),
      (icon: Icons.table_chart_rounded, label: 'Excel', value: 'Langsung'),
      (icon: Icons.auto_graph_rounded, label: 'Grafik', value: 'Interaktif'),
    ],
  ),
];

// ─────────────────────────────────────────────
//  SPLASH PAGE
// ─────────────────────────────────────────────
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;
  Timer? _timer;
  bool _ready = false;

  // ── per-slide animation bundles ──────────────
  List<AnimationController> _slideAcs = [];
  List<Animation<double>> _fadeTo = [];
  List<Animation<Offset>> _riseTo = [];
  List<Animation<double>> _iconPop = [];
  List<Animation<double>> _iconSpin = [];

  // ── progress bar animation ───────────────────
  AnimationController? _progAc;
  Animation<double>? _progValue;

  // ── bottom entrance animation ────────────────
  AnimationController? _btmAc;
  Animation<Offset>? _btmRise;
  Animation<double>? _btmFade;

  // ── floating particle animation ──────────────
  AnimationController? _particleAc;

  static const _autoSec = 4;

  @override
  void initState() {
    super.initState();

    // Slide animations
    _slideAcs = List.generate(
      _kSlides.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 650),
      ),
    );
    _fadeTo = _slideAcs
        .map(
          (ac) => CurvedAnimation(
            parent: ac,
            curve: const Interval(.0, .55, curve: Curves.easeOut),
          ),
        )
        .toList();
    _riseTo = _slideAcs
        .map(
          (ac) => Tween<Offset>(begin: const Offset(0, .06), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: ac,
                  curve: const Interval(.05, .75, curve: Curves.easeOutCubic),
                ),
              ),
        )
        .toList();
    _iconPop = _slideAcs
        .map(
          (ac) => Tween<double>(begin: .60, end: 1.0).animate(
            CurvedAnimation(
              parent: ac,
              curve: const Interval(.0, .65, curve: Curves.elasticOut),
            ),
          ),
        )
        .toList();
    _iconSpin = _slideAcs
        .map(
          (ac) => Tween<double>(begin: -.06, end: 0.0).animate(
            CurvedAnimation(
              parent: ac,
              curve: const Interval(.0, .60, curve: Curves.easeOutBack),
            ),
          ),
        )
        .toList();

    // Progress bar
    _progAc = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _autoSec),
    );
    _progValue = CurvedAnimation(parent: _progAc!, curve: Curves.linear);

    // Bottom controls entrance
    _btmAc = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _btmRise = Tween<Offset>(begin: const Offset(0, .30), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _btmAc!,
            curve: const Interval(.0, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _btmFade = CurvedAnimation(
      parent: _btmAc!,
      curve: const Interval(.0, .65, curve: Curves.easeOut),
    );

    // Floating particles (looping)
    _particleAc = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Kick off
    _slideAcs[0].forward();
    _btmAc!.forward();
    _startProgress();

    _timer = Timer.periodic(const Duration(seconds: _autoSec), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _kSlides.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });

    // All controllers ready
    setState(() => _ready = true);
  }

  void _startProgress() {
    _progAc?.reset();
    _progAc?.forward();
  }

  void _onPageChanged(int idx) {
    _slideAcs[_current].reverse(from: .35);
    setState(() => _current = idx);
    _slideAcs[idx].forward(from: 0);
    _startProgress();
    // Reset timer on manual swipe
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: _autoSec), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _kSlides.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _goNext() {
    if (_current < _kSlides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Get.toNamed('/login');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    for (final a in _slideAcs) a.dispose();
    _progAc?.dispose();
    _btmAc?.dispose();
    _particleAc?.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B6EF3),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final size = MediaQuery.of(context).size;
    final slide = _kSlides[_current];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // ── 1. Background blobs (animated color transition) ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: SizedBox.expand(
              key: ValueKey(_current),
              child: CustomPaint(
                painter: _BlobPainter(
                  gradient: slide.gradient,
                  accent: slide.accent,
                ),
              ),
            ),
          ),

          // ── 2. Floating particles overlay ───────────────────
          if (_particleAc != null)
            AnimatedBuilder(
              animation: _particleAc!,
              builder: (_, __) => CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  progress: _particleAc!.value,
                  accent: slide.accent,
                ),
              ),
            ),

          // ── 3. Page content ─────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // skip button top-right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14, 20, 0),
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/login'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(.30),
                          ),
                        ),
                        child: Text(
                          'Lewati',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(.90),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    onPageChanged: _onPageChanged,
                    itemCount: _kSlides.length,
                    itemBuilder: (_, i) => _buildSlide(i),
                  ),
                ),

                // bottom controls
                if (_btmRise != null && _btmFade != null)
                  SlideTransition(
                    position: _btmRise!,
                    child: FadeTransition(
                      opacity: _btmFade!,
                      child: _buildBottom(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Single slide ────────────────────────────
  Widget _buildSlide(int idx) {
    final s = _kSlides[idx];

    return FadeTransition(
      opacity: _fadeTo[idx],
      child: SlideTransition(
        position: _riseTo[idx],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── tag badge ─────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.white.withOpacity(.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      s.tag,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── hero illustration card ────────
              Center(
                child: ScaleTransition(
                  scale: _iconPop[idx],
                  child: AnimatedBuilder(
                    animation: _iconSpin[idx],
                    builder: (_, child) => Transform.rotate(
                      angle: _iconSpin[idx].value,
                      child: child,
                    ),
                    child: _HeroIllustration(slide: s),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── headline ──────────────────────
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.20,
                    letterSpacing: -.6,
                  ),
                  children: [
                    TextSpan(text: s.title),
                    TextSpan(
                      text: s.titleAccent,
                      style: TextStyle(color: s.accent),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── body text ─────────────────────
              Text(
                s.body,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.65,
                  letterSpacing: .1,
                ),
              ),

              const SizedBox(height: 22),

              // ── stat chips ────────────────────
              Row(
                children: s.stats
                    .map(
                      (st) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _StatChip(stat: st, accent: s.accent),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom controls ─────────────────────────
  Widget _buildBottom() {
    final slide = _kSlides[_current];
    final isLast = _current == _kSlides.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
      child: Column(
        children: [
          // ── progress dots + bar ─────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_kSlides.length, (i) {
              final isActive = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: isActive
                    ? (_progValue != null
                          ? _ProgressDot(
                              color: slide.accent,
                              progress: _progValue!,
                              autoSec: _autoSec,
                            )
                          : Container(
                              width: 28,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: slide.accent.withOpacity(.18),
                              ),
                            ))
                    : Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.muted.withOpacity(.22),
                        ),
                      ),
              );
            }),
          ),

          const SizedBox(height: 22),

          // ── main CTA button ─────────────────────
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: slide.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: slide.accent.withOpacity(.36),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'MULAI SEKARANG' : 'SELANJUTNYA',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isLast
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        key: ValueKey(isLast),
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── register link ───────────────────────
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Belum punya akun?',
                  style: TextStyle(color: AppColors.muted, fontSize: 13.5),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => Get.toNamed('/register'),
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HERO ILLUSTRATION CARD
// ─────────────────────────────────────────────
class _HeroIllustration extends StatelessWidget {
  final _Slide slide;
  const _HeroIllustration({required this.slide});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardSize = size.width * .58;

    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: LinearGradient(
          colors: [
            slide.gradient[0].withOpacity(.15),
            slide.gradient[1].withOpacity(.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: slide.accent.withOpacity(.20), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: slide.accent.withOpacity(.18),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // outer ring
          Container(
            width: cardSize * .80,
            height: cardSize * .80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: slide.accent.withOpacity(.12),
                width: 1,
              ),
            ),
          ),
          // inner ring
          Container(
            width: cardSize * .55,
            height: cardSize * .55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slide.accent.withOpacity(.10),
              border: Border.all(
                color: slide.accent.withOpacity(.20),
                width: 1.2,
              ),
            ),
          ),
          // centre icon
          Container(
            width: cardSize * .36,
            height: cardSize * .36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: slide.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: slide.accent.withOpacity(.38),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              slide.heroIcon,
              color: AppColors.white,
              size: cardSize * .17,
            ),
          ),

          // ── small floating badge top-left ──────
          Positioned(
            top: cardSize * .10,
            left: cardSize * .08,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: slide.accent,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Live',
                    style: TextStyle(
                      color: slide.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── small floating badge bottom-right ──
          Positioned(
            bottom: cardSize * .10,
            right: cardSize * .06,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 11,
                    color: slide.accent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    slide.stats[0].value,
                    style: TextStyle(
                      color: slide.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STAT CHIP
// ─────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final ({IconData icon, String label, String value}) stat;
  final Color accent;
  const _StatChip({required this.stat, required this.accent});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: accent.withOpacity(.07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: accent.withOpacity(.16)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(stat.icon, size: 12, color: accent),
            const SizedBox(width: 4),
            Text(
              stat.label,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                letterSpacing: .3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          stat.value,
          style: TextStyle(
            color: accent,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────
//  ANIMATED PROGRESS DOT
// ─────────────────────────────────────────────
class _ProgressDot extends StatelessWidget {
  final Color color;
  final Animation<double> progress;
  final int autoSec;
  const _ProgressDot({
    required this.color,
    required this.progress,
    required this.autoSec,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: progress,
    builder: (_, __) => Container(
      width: 28,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color.withOpacity(.18),
      ),
      clipBehavior: Clip.hardEdge,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  BACKGROUND BLOB PAINTER
// ─────────────────────────────────────────────
class _BlobPainter extends CustomPainter {
  final List<Color> gradient;
  final Color accent;
  const _BlobPainter({required this.gradient, required this.accent});

  @override
  void paint(Canvas canvas, Size s) {
    // ── top-right wave (main brand colour) ─────
    canvas.drawPath(
      Path()
        ..moveTo(s.width, 0)
        ..cubicTo(
          s.width,
          s.height * .28,
          s.width * .52,
          s.height * .36,
          s.width * .44,
          s.height * .20,
        )
        ..cubicTo(s.width * .36, s.height * .06, s.width * .60, 0, s.width, 0)
        ..close(),
      Paint()
        ..shader =
            LinearGradient(
              colors: gradient,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ).createShader(
              Rect.fromLTWH(s.width * .35, 0, s.width * .65, s.height * .38),
            ),
    );

    // ── white shimmer sub-wave ──────────────────
    canvas.drawPath(
      Path()
        ..moveTo(s.width * .56, s.height * .04)
        ..cubicTo(
          s.width * .76,
          s.height * .02,
          s.width * .88,
          s.height * .11,
          s.width * .80,
          s.height * .18,
        )
        ..cubicTo(
          s.width * .72,
          s.height * .24,
          s.width * .58,
          s.height * .20,
          s.width * .56,
          s.height * .04,
        )
        ..close(),
      Paint()..color = Colors.white.withOpacity(.20),
    );

    // ── red corner accent ───────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(s.width * .80, 0)
        ..cubicTo(
          s.width + 18,
          0,
          s.width + 18,
          s.height * .08,
          s.width * .90,
          s.height * .06,
        )
        ..cubicTo(
          s.width * .82,
          s.height * .04,
          s.width * .77,
          0,
          s.width * .80,
          0,
        )
        ..close(),
      Paint()..color = const Color(0xFFE9573F).withOpacity(.88),
    );

    // ── small red dot ───────────────────────────
    canvas.drawCircle(
      Offset(s.width * .91, s.height * .09),
      12,
      Paint()..color = const Color(0xFFE9573F).withOpacity(.55),
    );

    // ── bottom faint wave ───────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(0, s.height * .90)
        ..cubicTo(
          s.width * .22,
          s.height * .85,
          s.width * .44,
          s.height * .92,
          s.width * .56,
          s.height * .87,
        )
        ..cubicTo(
          s.width * .72,
          s.height * .82,
          s.width * .86,
          s.height * .91,
          s.width,
          s.height * .86,
        )
        ..lineTo(s.width, s.height)
        ..lineTo(0, s.height)
        ..close(),
      Paint()..color = accent.withOpacity(.06),
    );

    // ── soft glow behind card ───────────────────
    canvas.drawCircle(
      Offset(s.width * .50, s.height * .42),
      s.width * .35,
      Paint()
        ..color = accent.withOpacity(.07)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32),
    );

    // ── left ring ──────────────────────────────
    canvas.drawCircle(
      Offset(s.width * .08, s.height * .60),
      22,
      Paint()
        ..color = accent.withOpacity(.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // ── diagonal precision lines ────────────────
    canvas.drawLine(
      Offset(0, s.height * .22),
      Offset(s.width * .50, s.height * .05),
      Paint()
        ..color = Colors.white.withOpacity(.09)
        ..strokeWidth = .9,
    );
    canvas.drawLine(
      Offset(s.width * .28, 0),
      Offset(s.width, s.height * .26),
      Paint()
        ..color = Colors.white.withOpacity(.06)
        ..strokeWidth = .7,
    );

    // ── crosshair ──────────────────────────────
    final cx = s.width * .65;
    final cy = s.height * .13;
    final cp = Paint()
      ..color = Colors.white.withOpacity(.25)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - 9, cy), Offset(cx + 9, cy), cp);
    canvas.drawLine(Offset(cx, cy - 9), Offset(cx, cy + 9), cp);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.accent != accent;
}

// ─────────────────────────────────────────────
//  FLOATING PARTICLE PAINTER  (looping)
// ─────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress; // 0..1 looping
  final Color accent;

  const _ParticlePainter({required this.progress, required this.accent});

  static const _specs = [
    // (x_factor, y_start_factor, y_range_factor, radius, opacity, speed_phase)
    (.12, .30, .12, 3.5, .22, 0.0),
    (.28, .55, .08, 2.5, .18, 0.3),
    (.78, .25, .10, 3.0, .20, 0.6),
    (.90, .60, .12, 2.0, .15, 0.15),
    (.52, .70, .06, 2.8, .20, 0.8),
    (.40, .18, .09, 2.0, .16, 0.5),
    (.65, .45, .11, 3.2, .19, 0.9),
  ];

  @override
  void paint(Canvas canvas, Size s) {
    for (final (xf, yStart, yRange, r, op, phase) in _specs) {
      final t = (progress + phase) % 1.0;
      final yOffset = math.sin(t * math.pi * 2) * s.height * yRange;
      final y = s.height * yStart + yOffset;
      canvas.drawCircle(
        Offset(s.width * xf, y),
        r,
        Paint()..color = accent.withOpacity(op),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.accent != accent;
}
