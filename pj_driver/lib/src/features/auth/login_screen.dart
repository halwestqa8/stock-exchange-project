import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:dio/dio.dart';

class DriverLoginScreen extends ConsumerStatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  ConsumerState<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends ConsumerState<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E00), // Match gradient start
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0E00), Color(0xFF0A1628)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Glow
              Positioned(top: 60, left: 0, right: 0, child: Center(child: Container(
                width: 280, height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppTheme.orange.withAlpha(46), Colors.transparent]),
                ),
              ))),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 80),
                      const Text('\u{1F69B}', style: TextStyle(fontSize: 52), textAlign: TextAlign.center), // Truck 🚚
                      const SizedBox(height: 16),
                      RichText(textAlign: TextAlign.center, text: TextSpan(
                        style: tt.displayLarge?.copyWith(color: Colors.white),
                        children: [
                          TextSpan(text: '${L10n.of(context)!.appTitle}\n'),
                          TextSpan(
                            text: L10n.of(context)!.driver,
                            style: const TextStyle(color: Color(0xFFFBBF24)),
                          ),
                        ],
                      )),
                      const SizedBox(height: 8),
                      Text(L10n.of(context)!.signInToDeliveries, textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(115))),
                      const SizedBox(height: 40),

                      // Email
                      Text(L10n.of(context)!.email.toUpperCase(), style: tt.labelLarge?.copyWith(color: Colors.white.withAlpha(150))),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _emailCtrl, 
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: L10n.of(context)!.driverHint,
                          hintStyle: TextStyle(color: Colors.white.withAlpha(80)),
                          filled: true, fillColor: Colors.white.withAlpha(13),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withAlpha(30))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.orange)),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return L10n.of(context)!.enterEmail;
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                          if (!emailRegex.hasMatch(val)) return L10n.of(context)!.enterValidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      Text(L10n.of(context)!.password.toUpperCase(), style: tt.labelLarge?.copyWith(color: Colors.white.withAlpha(150))),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passCtrl, obscureText: _obscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '••••••••', hintStyle: TextStyle(color: Colors.white.withAlpha(80)),
                          filled: true, fillColor: Colors.white.withAlpha(13),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withAlpha(30))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.orange)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.white.withAlpha(120)),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? L10n.of(context)!.enterPassword : null,
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: _loading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.orange),
                        child: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : Text(L10n.of(context)!.signIn),
                      ),
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = L10n.of(context)!;
    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).login(_emailCtrl.text, _passCtrl.text);
      if (mounted) context.go('/');
    } on DioException catch (e) {
      String msg = l10n.loginFailed;
      if (e.response?.statusCode == 403) {
        msg = e.response?.data['message'] ?? l10n.accountDisabled;
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors is Map) {
          msg = errors.values.first[0];
        } else {
          msg = e.response?.data['message'] ?? l10n.incorrectCredentials;
        }
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.loginFailed}: $e'), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
