import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _keyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  late final AnimationController _entranceCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _buttonCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<Offset> _leftSlide;
  late final Animation<double> _leftOpacity;
  late final Animation<Offset> _rightSlide;
  late final Animation<double> _rightOpacity;
  late final List<Animation<Offset>> _fieldSlides;
  late final List<Animation<double>> _fieldOpacities;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _btnPressScale;
  late final Animation<double> _logoFloat;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _leftSlide = Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.00, 0.60, curve: Curves.easeOutCubic),
          ),
        );
    _leftOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.00, 0.40, curve: Curves.easeOut),
      ),
    );
    _rightSlide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.10, 0.65, curve: Curves.easeOutCubic),
          ),
        );
    _rightOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.10, 0.45, curve: Curves.easeOut),
      ),
    );

    _fieldSlides = List.generate(5, (i) {
      final start = 0.30 + i * 0.08;
      return Tween<Offset>(
        begin: const Offset(0, 0.40),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(
            start,
            (start + 0.30).clamp(0, 1),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
    _fieldOpacities = List.generate(5, (i) {
      final start = 0.30 + i * 0.08;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceCtrl,
          curve: Interval(
            start,
            (start + 0.22).clamp(0, 1),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _pulseScale = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _pulseOpacity = Tween<double>(
      begin: 0.35,
      end: 0.80,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _btnPressScale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeInOut));
    _logoFloat = Tween<double>(
      begin: -7.0,
      end: 7.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _keyCtrl.dispose();
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    _buttonCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Widget _fieldAnimated(int index, Widget child) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, _) => SlideTransition(
        position: _fieldSlides[index],
        child: FadeTransition(opacity: _fieldOpacities[index], child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    final isKurdish = locale.languageCode == 'ku';
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Left branding panel
              Expanded(
                flex: 5,
                child: AnimatedBuilder(
                  animation: _entranceCtrl,
                  builder: (_, child) => SlideTransition(
                    position: _leftSlide,
                    child: FadeTransition(opacity: _leftOpacity, child: child),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.ink, Color(0xFF1E2038)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (_, _) => Transform.scale(
                              scale: _pulseScale.value,
                              child: Opacity(
                                opacity: _pulseOpacity.value,
                                child: Container(
                                  width: 380,
                                  height: 380,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppTheme.rose.withAlpha(45),
                                        AppTheme.rose.withAlpha(12),
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
                        // Branding content
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _floatCtrl,
                                builder: (_, child) => Transform.translate(
                                  offset: Offset(0, _logoFloat.value),
                                  child: child,
                                ),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.rose,
                                        Color(0xFFFB7185),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.rose.withAlpha(80),
                                        blurRadius: 28,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.admin_panel_settings_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: tt.displayLarge?.copyWith(
                                    color: Colors.white,
                                    height: 1.15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${L10n.of(context)!.appTitle} ',
                                    ),
                                    TextSpan(
                                      text: L10n.of(context)!.adminRole,
                                      style: TextStyle(
                                        color: Color(0xFFFDA4AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isKurdish
                                    ? 'داشبۆردی ئەدمینی گەورە'
                                    : 'Super Admin Dashboard',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withAlpha(100),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              ...[
                                (Icons.inventory_2_outlined, L10n.of(context)!.shipmentMonitor),
                                (Icons.people_alt_outlined, L10n.of(context)!.userManagement),
                                (Icons.bar_chart_rounded, L10n.of(context)!.reportsLabel),
                              ].map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(10),
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withAlpha(18),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              item.$1,
                                              size: 16,
                                              color: Colors.white.withAlpha(180),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              item.$2,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white.withAlpha(
                                                  160,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
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
                  ),
                ),
              ),

              // Right form panel
              Expanded(
                flex: 4,
                child: AnimatedBuilder(
                  animation: _entranceCtrl,
                  builder: (_, child) => SlideTransition(
                    position: _rightSlide,
                    child: FadeTransition(opacity: _rightOpacity, child: child),
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 380),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _fieldAnimated(
                              0,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    L10n.of(context)!.welcomeBack,
                                    style: tt.displayMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    L10n.of(context)!.signInToManage,
                                    style: tt.bodyMedium?.copyWith(
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),
                            _fieldAnimated(
                              1,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    L10n.of(context)!.email,
                                    style: tt.labelLarge,
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _emailCtrl,
                                    decoration: InputDecoration(
                                      hintText: L10n.of(context)!.emailPlaceholder,
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        size: 18,
                                        color: AppTheme.muted,
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return L10n.of(context)!.required;
                                      }
                                      if (!val.contains('@')) {
                                        return L10n.of(context)!.invalidEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _fieldAnimated(
                              2,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    L10n.of(context)!.password,
                                    style: tt.labelLarge,
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: L10n.of(context)!.passwordPlaceholder,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        size: 18,
                                        color: AppTheme.muted,
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return L10n.of(context)!.required;
                                      }
                                      if (val.length < 6) {
                                        return L10n.of(
                                          context,
                                        )!.passwordTooShort;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _fieldAnimated(
                              3,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isKurdish
                                        ? 'کلیلی ئەدمین'
                                        : 'Admin Key',
                                    style: tt.labelLarge,
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _keyCtrl,
                                    decoration: InputDecoration(
                                      hintText: isKurdish
                                          ? 'کلیلەکەت لێرە بنووسە'
                                          : 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                                      prefixIcon: const Icon(
                                        Icons.key_rounded,
                                        size: 18,
                                        color: AppTheme.muted,
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val == null || val.length != 36) {
                                        return isKurdish
                                            ? 'کلیلەکە دەبێت تەواو ٣٦ پیت بێت'
                                            : 'Key must be exactly 36 characters';
                                      }
                                      if (!RegExp(
                                        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                                      ).hasMatch(val)) {
                                        return isKurdish
                                            ? 'فۆرماتی UUID هەڵەیە'
                                            : 'Invalid UUID format';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            _fieldAnimated(
                              4,
                              AnimatedBuilder(
                                animation: _buttonCtrl,
                                builder: (_, child) => Transform.scale(
                                  scale: _btnPressScale.value,
                                  child: child,
                                ),
                                child: GestureDetector(
                                  onTapDown: (_) => _buttonCtrl.forward(),
                                  onTapUp: (_) {
                                    _buttonCtrl.reverse();
                                    if (!_loading) _handleLogin();
                                  },
                                  onTapCancel: () => _buttonCtrl.reverse(),
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: AppTheme.rose,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.rose.withAlpha(70),
                                          blurRadius: 18,
                                          offset: const Offset(0, 7),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: _loading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              L10n.of(context)!.signIn,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Language Toggle
          Positioned(
            top: 24,
            right: 24,
            child: Consumer(
              builder: (context, ref, _) {
                final theme = Theme.of(context).textTheme;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => ref.read(localeProvider.notifier).toggle(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        border: Border.all(color: AppTheme.rose.withAlpha(80)),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 18,
                            color: AppTheme.rose,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isKurdish ? 'EN' : 'KU',
                            style: theme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailCtrl.text, _passwordCtrl.text, _keyCtrl.text);
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${L10n.of(context)!.error}: $e'),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
