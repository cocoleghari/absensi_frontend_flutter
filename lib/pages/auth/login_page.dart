import 'package:absensi_frontend_flutter/controllers/auth_controller.dart';
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
  static const white = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1A2E);
  static const muted = Color(0xFF8A8FA8);
  static const fieldBg = Color(0xFFF4F6FB);
}

// ─────────────────────────────────────────────
//  LOGIN PAGE
// ─────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = ''.obs;
  final passwordError = ''.obs;

  late final AnimationController _ac;
  late final Animation<double> _fade;
  late final Animation<Offset> _rise;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fade = CurvedAnimation(
      parent: _ac,
      curve: const Interval(0, .65, curve: Curves.easeOut),
    );
    _rise = Tween<Offset>(begin: const Offset(0, .10), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ac,
            curve: const Interval(.20, .90, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _ac.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (authController.isLoading.value) return _loadingView();
        return Stack(
          children: [
            // blob painter (white bg + blue wave + red accents)
            Positioned.fill(child: CustomPaint(painter: _LoginBlobPainter())),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _topWaveSection(),
                      SlideTransition(position: _rise, child: _formSection()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Loading ────────────────────────────────
  Widget _loadingView() => Container(
    color: AppColors.white,
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.blue.withOpacity(.4),
              width: 1.5,
            ),
            color: AppColors.blue.withOpacity(.07),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CircularProgressIndicator(
              color: AppColors.blue,
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Memproses login…',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            letterSpacing: .5,
          ),
        ),
      ],
    ),
  );

  // ── Top wave / illustration section ────────
  Widget _topWaveSection() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .38,
      child: Stack(
        children: [
          // centre illustration container
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // icon badge
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [AppColors.white, Color(0xFFDCE8FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withOpacity(.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.blue.withOpacity(.18),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: AppColors.blue,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Admin Portal',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistem Absensi Karyawan',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(.75),
                    fontSize: 12.5,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),

          // floating feature pill – top left
          Positioned(
            top: 24,
            left: 20,
            child: _floatPill(
              Icons.verified_rounded,
              'Terpercaya',
              AppColors.white,
            ),
          ),

          // floating feature pill – bottom right
          Positioned(
            bottom: 50,
            right: 20,
            child: _floatPill(Icons.shield_rounded, 'Aman', AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _floatPill(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: AppColors.white.withOpacity(.18),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.white.withOpacity(.35), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: .3,
          ),
        ),
      ],
    ),
  );

  // ── Form section ───────────────────────────
  Widget _formSection() => Container(
    decoration: const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
    ),
    child: Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // subtle blue glow top-right inside card
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.blue.withOpacity(.08), Colors.transparent],
              ),
            ),
          ),
        ),
        // subtle red glow bottom-left inside card
        Positioned(
          bottom: 40,
          left: -30,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.red.withOpacity(.05),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDE8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // page title
              const Text(
                'Sign In',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Masukkan kredensial Anda untuk melanjutkan',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),

              // ── email field ──
              Obx(
                () => _field(
                  controller: emailController,
                  hint: 'Masukkan Email',
                  icon: Icons.alternate_email_rounded,
                  error: emailError.value.isEmpty ? null : emailError.value,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => emailError.value = '',
                ),
              ),
              const SizedBox(height: 14),

              // ── password field ──
              Obx(
                () => _field(
                  controller: passwordController,
                  hint: 'Masukkan Password',
                  icon: Icons.lock_outline_rounded,
                  error: passwordError.value.isEmpty
                      ? null
                      : passwordError.value,
                  obscure: true,
                  onChanged: (_) => passwordError.value = '',
                ),
              ),
              const SizedBox(height: 8),

              // forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.snackbar(
                    'Informasi',
                    'Fitur lupa password belum tersedia saat ini.',
                    backgroundColor: AppColors.red,
                    colorText: AppColors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    borderRadius: 14,
                    margin: const EdgeInsets.all(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── SIGN IN button ──
              _signInButton(),
              const SizedBox(height: 24),

              // register row
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.muted, fontSize: 13.5),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Get.toNamed('/register'),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // info card
              _infoCard(),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Input field ────────────────────────────
  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? error,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    final hasErr = error != null && error.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.muted.withOpacity(.60),
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                icon,
                size: 19,
                color: hasErr
                    ? AppColors.red
                    : AppColors.muted.withOpacity(.60),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            filled: true,
            fillColor: hasErr ? const Color(0xFFFFF1EE) : AppColors.fieldBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: _border(Colors.transparent),
            enabledBorder: _border(
              hasErr ? AppColors.red.withOpacity(.35) : Colors.transparent,
            ),
            focusedBorder: _border(AppColors.blue.withOpacity(.50)),
            errorBorder: _border(AppColors.red),
            focusedErrorBorder: _border(AppColors.red),
            errorText: error,
            errorStyle: const TextStyle(
              color: AppColors.red,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c, width: 1.4),
  );

  // ── Sign In button ─────────────────────────
  Widget _signInButton() => SizedBox(
    height: 54,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.redLight, AppColors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(.38),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'SIGN IN',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.5,
          ),
        ),
      ),
    ),
  );

  // ── Info card ──────────────────────────────
  Widget _infoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.bluePale,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.blue.withOpacity(.15), width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue.withOpacity(.12),
          ),
          child: const Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 15,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .3,
                ),
              ),
              const SizedBox(height: 6),
              ...[
                'Gunakan akun admin yang sudah terdaftar.',
                'Jika belum punya akun, silahkan registrasi terlebih dahulu.',
                'Hubungi administrator jika mengalami kendala.',
              ].map(
                (t) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.5),
                        child: Container(
                          width: 3.5,
                          height: 3.5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ── Login logic (unchanged) ────────────────
  void _login() {
    emailError.value = '';
    passwordError.value = '';

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    bool isValid = true;

    if (email.isEmpty) {
      emailError.value = 'Email wajib diisi';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Format email tidak valid';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'Password wajib diisi';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password minimal 6 karakter';
      isValid = false;
    }

    if (!isValid) return;
    authController.login(email, password);
  }
}

// ─────────────────────────────────────────────
//  LOGIN PAGE BLOB PAINTER
//  White background + blue wave top + red accents
// ─────────────────────────────────────────────
class _LoginBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final topH = s.height * .42;

    // ── main blue wave fill ───────────────────
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(s.width, 0)
        ..lineTo(s.width, topH * .75)
        ..cubicTo(
          s.width * .85,
          topH * .95,
          s.width * .60,
          topH * 1.05,
          s.width * .48,
          topH * .92,
        )
        ..cubicTo(
          s.width * .30,
          topH * .75,
          s.width * .15,
          topH * .88,
          0,
          topH * .80,
        )
        ..close(),
      Paint()
        ..shader = LinearGradient(
          colors: const [Color(0xFF1B6EF3), Color(0xFF1044C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, s.width, topH)),
    );

    // ── white wave highlight layer ────────────
    canvas.drawPath(
      Path()
        ..moveTo(0, topH * .55)
        ..cubicTo(
          s.width * .20,
          topH * .45,
          s.width * .42,
          topH * .62,
          s.width * .55,
          topH * .52,
        )
        ..cubicTo(
          s.width * .70,
          topH * .40,
          s.width * .85,
          topH * .58,
          s.width,
          topH * .48,
        )
        ..lineTo(s.width, topH * .75)
        ..cubicTo(
          s.width * .85,
          topH * .95,
          s.width * .60,
          topH * 1.05,
          s.width * .48,
          topH * .92,
        )
        ..cubicTo(
          s.width * .30,
          topH * .75,
          s.width * .15,
          topH * .88,
          0,
          topH * .80,
        )
        ..close(),
      Paint()..color = Colors.white.withOpacity(.15),
    );

    // ── red blob top-right corner ─────────────
    canvas.drawPath(
      Path()
        ..moveTo(s.width * .74, 0)
        ..cubicTo(
          s.width + 10,
          0,
          s.width + 10,
          s.height * .09,
          s.width * .88,
          s.height * .07,
        )
        ..cubicTo(
          s.width * .78,
          s.height * .05,
          s.width * .68,
          0,
          s.width * .74,
          0,
        )
        ..close(),
      Paint()..color = const Color(0xFFE9573F).withOpacity(.90),
    );

    // ── smaller red dot accent ────────────────
    canvas.drawCircle(
      Offset(s.width * .92, s.height * .10),
      14,
      Paint()..color = const Color(0xFFE9573F).withOpacity(.55),
    );

    // ── white shimmer ring in blue area ───────
    canvas.drawCircle(
      Offset(s.width * .18, topH * .35),
      26,
      Paint()
        ..color = Colors.white.withOpacity(.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // ── white dot constellation ───────────────
    for (final (x, y, r) in [
      (s.width * .08, topH * .12, 4.0),
      (s.width * .30, topH * .08, 2.5),
      (s.width * .72, topH * .15, 3.0),
      (s.width * .88, topH * .28, 2.0),
      (s.width * .50, topH * .22, 2.0),
    ]) {
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = Colors.white.withOpacity(.35),
      );
    }

    // ── blue dot accents ──────────────────────
    canvas.drawCircle(
      Offset(s.width * .12, topH * .58),
      5,
      Paint()..color = const Color(0xFF1B6EF3).withOpacity(.18),
    );
    canvas.drawCircle(
      Offset(s.width * .90, topH * .65),
      7,
      Paint()..color = const Color(0xFF1B6EF3).withOpacity(.12),
    );

    // ── precision diagonal lines ──────────────
    canvas.drawLine(
      Offset(0, topH * .40),
      Offset(s.width * .55, topH * .10),
      Paint()
        ..color = Colors.white.withOpacity(.10)
        ..strokeWidth = .9,
    );
    canvas.drawLine(
      Offset(s.width * .35, 0),
      Offset(s.width, topH * .35),
      Paint()
        ..color = Colors.white.withOpacity(.07)
        ..strokeWidth = .7,
    );

    // ── crosshair top-right ───────────────────
    final cx = s.width * .62;
    final cy = topH * .14;
    final cp = Paint()
      ..color = Colors.white.withOpacity(.25)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - 8, cy), Offset(cx + 8, cy), cp);
    canvas.drawLine(Offset(cx, cy - 8), Offset(cx, cy + 8), cp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
