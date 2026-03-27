import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // â”€â”€ Animation Controllers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final AnimationController _pulseCtrl;
  late final AnimationController _entranceCtrl;
  late final AnimationController _buttonCtrl;

  // â”€â”€ Pulse glows â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<double> _pulse1Scale;
  late final Animation<double> _pulse1Opacity;
  late final Animation<double> _pulse2Opacity;

  // â”€â”€ Back button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<Offset> _backSlide;
  late final Animation<double> _backOpacity;

  // â”€â”€ Title block â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;

  // â”€â”€ Form fields (name=0, email=1, password=2, confirm=3) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final List<Animation<Offset>> _fieldSlides;
  late final List<Animation<double>> _fieldOpacities;

  // â”€â”€ Button + footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late final Animation<double> _btnScale;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    // Breathing glow â€” repeating
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Main entrance (1.2 s to cover 4 staggered fields)
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Button press feedback
    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );

    // â”€â”€ Pulse â”€â”€
    _pulse1Scale = Tween<double>(begin: 0.80, end: 1.20).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _pulse1Opacity = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _pulse2Opacity = Tween<double>(begin: 0.20, end: 0.60).animate(
      CurvedAnimation(
        parent: _pulseCtrl,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // â”€â”€ Back button slides from left â”€â”€
    _backSlide = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.00, 0.30, curve: Curves.easeOutCubic),
    ));
    _backOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.25, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ Title block â”€â”€
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.10, 0.42, curve: Curves.easeOutCubic),
    ));
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.10, 0.38, curve: Curves.easeOut),
      ),
    );

    // â”€â”€ 4 form fields â€” staggered â”€â”€
    _fieldSlides = List.generate(4, (i) {
      final start = 0.28 + i * 0.09;
      final end = (start + 0.28).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.55),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entranceCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });
    _fieldOpacities = List.generate(4, (i) {
      final start = 0.28 + i * 0.09;
      final end = (start + 0.22).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // â”€â”€ Button press scale â”€â”€
    _btnScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeInOut),
    );

    // â”€â”€ Footer (terms + sign-in link) â”€â”€
    _footerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _pulseCtrl.dispose();
    _entranceCtrl.dispose();
    _buttonCtrl.dispose();
    super.dispose();
  }

  // â”€â”€ Helper: wrap a widget in its staggered animation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _animated(int index, Widget child) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, _) => SlideTransition(
        position: _fieldSlides[index],
        child: FadeTransition(
          opacity: _fieldOpacities[index],
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B14), Color(0xFF0A1628)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // â”€â”€ Primary pulsing glow (top-right) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Positioned(
                top: 50, right: -60,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Transform.scale(
                    scale: _pulse1Scale.value,
                    child: Opacity(
                      opacity: _pulse1Opacity.value,
                      child: Container(
                        width: 280, height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.teal.withAlpha(50),
                              AppTheme.teal.withAlpha(15),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // â”€â”€ Secondary accent glow (bottom-left) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Positioned(
                bottom: 60, left: -50,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Opacity(
                    opacity: _pulse2Opacity.value,
                    child: Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF3B82F6).withAlpha(40),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // â”€â”€ Tertiary tiny glow (mid-right) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Positioned(
                top: 320, right: -20,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Opacity(
                    opacity: (1.0 - (_pulse1Opacity.value - 0.35)) * 0.35,
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6EE7B7).withAlpha(35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // â”€â”€ Scrollable content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // â”€â”€ Back button â”€â”€
                      AnimatedBuilder(
                        animation: _entranceCtrl,
                        builder: (_, child) => SlideTransition(
                          position: _backSlide,
                          child: FadeTransition(
                            opacity: _backOpacity,
                            child: child,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _CircleIconButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => context.go('/'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // â”€â”€ Title block â”€â”€
                      AnimatedBuilder(
                        animation: _entranceCtrl,
                        builder: (_, child) => SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleOpacity,
                            child: child,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: tt.displayLarge?.copyWith(
                                  color: Colors.white,
                                  height: 1.15,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${L10n.of(context)!.createAccount}\n',
                                  ),
                                  TextSpan(
                                    text: L10n.of(context)!.account,
                                    style: TextStyle(color: Color(0xFF6EE7B7)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              L10n.of(context)!.createAccountSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withAlpha(110),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // â”€â”€ Full Name â”€â”€
                      _animated(
                        0,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DarkLabel(
                              text: L10n.of(context)!.fullNameLabel,
                              tt: tt,
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _nameCtrl,
                              hint: L10n.of(context)!.yourFullNameHint,
                              icon: Icons.person_outline_rounded,
                              validator: (val) =>
                                  (val == null || val.trim().isEmpty)
                                      ? L10n.of(context)!.enterName
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ Email â”€â”€
                      _animated(
                        1,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DarkLabel(
                              text: L10n.of(context)!.emailAddressLabel,
                              tt: tt,
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _emailCtrl,
                              hint: L10n.of(context)!.emailPlaceholder,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return L10n.of(context)!.enterEmail;
                                }
                                final emailRegex = RegExp(
                                    r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
                                if (!emailRegex.hasMatch(val)) {
                                  return L10n.of(context)!.enterValidEmail;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ Password â”€â”€
                      _animated(
                        2,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DarkLabel(
                              text: L10n.of(context)!.password.toUpperCase(),
                              tt: tt,
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _passCtrl,
                              hint: L10n.of(context)!.passwordMinHint,
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePass,
                              onToggleObscure: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              validator: (val) =>
                                  (val == null || val.length < 8)
                                      ? L10n.of(context)!.passwordMin8
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ Confirm Password â”€â”€
                      _animated(
                        3,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DarkLabel(
                              text: L10n.of(context)!.confirmPasswordLabel,
                              tt: tt,
                            ),
                            const SizedBox(height: 6),
                            _DarkTextField(
                              controller: _confirmCtrl,
                              hint: L10n.of(context)!.repeatPasswordHint,
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscureConfirm,
                              onToggleObscure: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              validator: (val) =>
                                  (val != _passCtrl.text)
                                      ? L10n.of(context)!.passwordMismatch
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // â”€â”€ Create Account button â”€â”€
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_entranceCtrl, _buttonCtrl]),
                        builder: (_, child) => FadeTransition(
                          opacity: _footerOpacity,
                          child: Transform.scale(
                            scale: _btnScale.value,
                            child: child,
                          ),
                        ),
                        child: GestureDetector(
                          onTapDown: (_) => _buttonCtrl.forward(),
                          onTapUp: (_) {
                            _buttonCtrl.reverse();
                            if (!_isLoading) _handleRegister();
                          },
                          onTapCancel: () => _buttonCtrl.reverse(),
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppTheme.teal,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.teal.withAlpha(70),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      L10n.of(context)!.createAccount,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // â”€â”€ Footer (terms + sign-in link) â”€â”€
                      FadeTransition(
                        opacity: _footerOpacity,
                        child: Column(
                          children: [
                            Text(
                              L10n.of(context)!.termsAgree,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withAlpha(60),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Center(
                              child: GestureDetector(
                                onTap: () => context.go('/login'),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withAlpha(100),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: L10n.of(context)!.alreadyMember,
                                      ),
                                      TextSpan(
                                        text: L10n.of(context)!.signIn,
                                        style: TextStyle(
                                          color: Color(0xFF6EE7B7),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _nameCtrl.text.trim(),
            _emailCtrl.text.trim(),
            _passCtrl.text,
            _confirmCtrl.text,
          );
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        String msg = L10n.of(context)!.registrationFailed;
        if (e is DioException && e.response?.data?['message'] != null) {
          msg = e.response!.data['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// â”€â”€ Dark label â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DarkLabel extends StatelessWidget {
  final String text;
  final TextTheme tt;

  const _DarkLabel({required this.text, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: tt.labelLarge?.copyWith(color: Colors.white.withAlpha(140)),
    );
  }
}

// â”€â”€ Reusable dark-themed text field â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;

  const _DarkTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.onToggleObscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withAlpha(70)),
        filled: true,
        fillColor: Colors.white.withAlpha(12),
        prefixIcon: Icon(icon, size: 18, color: Colors.white.withAlpha(100)),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Colors.white.withAlpha(100),
                ),
                onPressed: onToggleObscure,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFCA5A5)),
      ),
      validator: validator,
    );
  }
}

// â”€â”€ Circle icon button with press scale feedback â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(30)),
          ),
          child: Icon(widget.icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

