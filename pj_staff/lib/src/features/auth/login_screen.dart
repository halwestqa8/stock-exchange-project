import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:dio/dio.dart';

class StaffLoginScreen extends ConsumerStatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  ConsumerState<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends ConsumerState<StaffLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Row(
        children: [
          // Left panel — branding
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.ink, Color(0xFF1E2038)]),
              ),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('\u{1F4CB}', style: TextStyle(fontSize: 52)), // Clipboard 📋
                const SizedBox(height: 16),
                RichText(text: TextSpan(
                  style: tt.displayLarge?.copyWith(color: Colors.white),
                  children: [
                    TextSpan(text: '${L10n.of(context)!.appTitle} '),
                    TextSpan(text: L10n.of(context)!.staff, style: const TextStyle(color: Color(0xFFA5B4FC))),
                  ],
                )),
                const SizedBox(height: 8),
                Text(L10n.of(context)!.logisticsPortal, style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(100))),
              ])),
            ),
          ),
          // Right panel — form
          Expanded(
            flex: 4,
            child: Center(child: Container(
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(L10n.of(context)!.welcomeBack, style: tt.displayMedium),
                    const SizedBox(height: 4),
                    Text(L10n.of(context)!.signInToStaffPortal, style: tt.bodyMedium?.copyWith(color: AppTheme.muted)),
                    const SizedBox(height: 32),
                    Text(L10n.of(context)!.email.toUpperCase(), style: tt.labelLarge), const SizedBox(height: 5),
                    TextFormField(
                      controller: _emailCtrl, 
                      decoration: InputDecoration(
                        hintText: L10n.of(context)!.staffHint,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return L10n.of(context)!.enterEmail;
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                        if (!emailRegex.hasMatch(val)) return L10n.of(context)!.enterValidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Text(L10n.of(context)!.password.toUpperCase(), style: tt.labelLarge), const SizedBox(height: 5),
                    TextFormField(
                      controller: _passCtrl, 
                      obscureText: true, 
                      decoration: const InputDecoration(hintText: '••••••••'),
                      validator: (val) => (val == null || val.isEmpty) ? L10n.of(context)!.enterPassword : null,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _loading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.indigo, minimumSize: const Size(double.infinity, 52)),
                      child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Text(L10n.of(context)!.signIn),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = L10n.of(context)!;
    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).login(_emailCtrl.text, _passCtrl.text);
      if (context.mounted) context.go('/');
    } on DioException catch (e) {
      String msg = l10n.loginFailed;
      if (e.response?.statusCode == 403) {
        msg = e.response?.data['message'] ?? l10n.accountDisabled;
      } else if (e.response?.statusCode == 401 || e.response?.statusCode == 422) {
        msg = e.response?.data['message'] ?? l10n.incorrectCredentials;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.loginFailed}: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (context.mounted) setState(() => _loading = false);
    }
  }
}
