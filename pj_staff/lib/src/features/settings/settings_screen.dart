import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import '../shell/staff_sidebar.dart';
import 'package:pj_l10n/pj_l10n.dart';

class StaffSettingsScreen extends ConsumerWidget {
  const StaffSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Row(
        children: [
          // ── Sidebar ──
          const StaffSidebar(activeRoute: '/settings'),

          // ── Main Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Page Header ──
                  Text(L10n.of(context)!.settings, style: tt.headlineLarge),
                  const SizedBox(height: 4),
                  Text(L10n.of(context)!.manageAccount,
                      style: tt.bodyMedium?.copyWith(color: AppTheme.muted)),
                  const SizedBox(height: 28),

                  // ── Profile Card ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.ink, Color(0xFF1E2038)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AppTheme.indigo, Color(0xFF818CF8)]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              (user?.name ?? 'S')[0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? L10n.of(context)!.staff,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user?.email ?? '',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(150)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.indigo.withAlpha(50),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppTheme.indigo.withAlpha(80)),
                          ),
                          child: Text(
                            L10n.of(context)!.staff,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFA5B4FC)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Two Column Layout ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          children: [
                            _Section(
                              title: L10n.of(context)!.accountSection,
                              children: [
                                _SettingsTile(
                                  emoji: '\u{270F}\u{FE0F}', // Pencil ✏️
                                  label: L10n.of(context)!.editProfile,
                                  subtitle: L10n.of(context)!.editProfileSubtitle,
                                  onTap: () =>
                                      _showEditProfile(context, user?.name),
                                ),
                                _SettingsTile(
                                  emoji: '\u{1F512}', // Lock 🔒
                                  label: L10n.of(context)!.changePassword,
                                  subtitle: L10n.of(context)!.updatePasswordSubtitle,
                                  onTap: () => _showChangePassword(context),
                                ),
                                _SettingsTile(
                                  emoji: '\u{1F310}', // Globe 🌐
                                  label: L10n.of(context)!.language,
                                  subtitle: '${L10n.of(context)!.english} / ${L10n.of(context)!.kurdish}',
                                  trailing: Consumer(
                                    builder: (context, ref, _) {
                                      final locale = ref.watch(localeProvider);
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.indigoLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          locale.languageCode.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.indigo),
                                        ),
                                      );
                                    },
                                  ),
                                  onTap: () => ref.read(localeProvider.notifier).toggle(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _Section(
                              title: L10n.of(context)!.notificationsSection,
                              children: [
                                _SettingsTile(
                                  emoji: '\u{1F514}',
                                  label: L10n.of(context)!.pushNotifications,
                                  subtitle: L10n.of(context)!.pushNotificationsSubtitle,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Right Column
                      Expanded(
                        child: Column(
                          children: [
                            _Section(
                              title: L10n.of(context)!.appearanceSection,
                              children: [
                                _SettingsTile(
                                  emoji: '\u{1F4CA}',
                                  label: L10n.of(context)!.compactView,
                                  subtitle: L10n.of(context)!.compactViewSubtitle,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _Section(
                              title: L10n.of(context)!.supportSection,
                              children: [
                                _SettingsTile(
                                  emoji: '\u{1F4AC}', // Message 💬
                                  label: L10n.of(context)!.help,
                                  subtitle: L10n.of(context)!.findAnswers,
                                  onTap: () => _showHelp(context),
                                ),
                                _SettingsTile(
                                  emoji: '\u{2B50}', // Star ⭐
                                  label: L10n.of(context)!.signOut, // Reusing Sign Out if feedback not available
                                  subtitle: L10n.of(context)!.help,
                                  onTap: () {},
                                ),
                                _SettingsTile(
                                  emoji: '\u{2139}\u{FE0F}', // Info ℹ️
                                  label: L10n.of(context)!.aboutLtms,
                                  subtitle: L10n.of(context)!.versionLabel,
                                  trailing: Text(
                                    L10n.of(context)!.versionLabel,
                                    style: TextStyle(
                                        fontSize: 12, color: AppTheme.muted),
                                  ),
                                  onTap: () => _showAbout(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Sign Out ──
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppTheme.red.withAlpha(60)),
                              ),
                              child: ListTile(
                                onTap: () => _confirmLogout(context, ref),
                                leading: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.redLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.logout_rounded,
                                        size: 18, color: AppTheme.red),
                                  ),
                                ),
                                title: Text(
                                  L10n.of(context)!.signOut,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.red),
                                ),
                                subtitle: Text(
                                  L10n.of(context)!.signOutSubtitle,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppTheme.muted),
                                ),
                                trailing: const Icon(Icons.chevron_right_rounded,
                                    size: 18, color: AppTheme.red),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(L10n.of(context)!.signOut,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
            L10n.of(context)!.signOutConfirmStaff),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context)!.cancel,
                style: const TextStyle(color: AppTheme.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            child: Text(L10n.of(context)!.signOut,
                style: const TextStyle(
                    color: AppTheme.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context, String? name) {
    final ctrl = TextEditingController(text: name ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(L10n.of(context)!.editProfile,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L10n.of(context)!.nameLabel,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted)),
            const SizedBox(height: 6),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(hintText: L10n.of(context)!.fullNameHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context)!.cancel,
                style: TextStyle(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.indigo,
                minimumSize: const Size(0, 36)),
            child: Text(L10n.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(L10n.of(context)!.changePassword,
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PassField(label: L10n.of(context)!.currentPasswordLabel, hint: L10n.of(context)!.passwordPlaceholder),
            const SizedBox(height: 12),
            _PassField(label: L10n.of(context)!.newPasswordLabel, hint: L10n.of(context)!.minPasswordHint),
            const SizedBox(height: 12),
            _PassField(label: L10n.of(context)!.confirmNewPasswordLabel, hint: L10n.of(context)!.passwordPlaceholder),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context)!.cancel,
                style: TextStyle(color: AppTheme.muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.indigo,
                minimumSize: const Size(0, 36)),
            child: Text(L10n.of(context)!.updateBtn),
          ),
        ],
      ),
    );
  }


  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(L10n.of(context)!.help,
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpRow(emoji: '\u{1F4E7}', label: L10n.of(context)!.email, value: 'support@ltms.app'), // Envelope 📧
            const SizedBox(height: 10),
            _HelpRow(emoji: '\u{1F4DE}', label: L10n.of(context)!.help, value: '+964 750 000 0000'), // Phone 📞
            const SizedBox(height: 10),
            _HelpRow(emoji: '\u{1F4AC}', label: L10n.of(context)!.help, value: L10n.of(context)!.supportHours), // Message 💬
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context)!.closeBtn, style: const TextStyle(color: AppTheme.indigo)),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Text('\u{1F4CB}', style: TextStyle(fontSize: 22)), // Clipboard 📋
          const SizedBox(width: 8),
          Text(L10n.of(context)!.aboutLtms, style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpRow(emoji: '\u{1F680}', label: L10n.of(context)!.buildLabel, value: '1.0.0'), // Rocket 🚀
            const SizedBox(height: 8),
            _HelpRow(emoji: '\u{1F4C5}', label: L10n.of(context)!.buildLabel, value: '2026.03'), // Calendar 📅
            const SizedBox(height: 8),
            _HelpRow(
                emoji: '\u{1F30D}', // Earth 🌍
                label: L10n.of(context)!.productLabel,
                value: L10n.of(context)!.logisticsSystemName),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(L10n.of(context)!.closeBtn, style: const TextStyle(color: AppTheme.indigo)),
          ),
        ],
      ),
    );
  }
}

// ── Section wrapper ───────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppTheme.muted,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(children: [
                children[i],
                if (i < children.length - 1)
                  const Divider(height: 1, indent: 54),
              ]);
            }),
          ),
        ),
      ],
    );
  }
}

// ── Tiles ─────────────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.emoji,
    required this.label,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.indigoLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 17))),
      ),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: AppTheme.muted),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.indigoLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 17))),
      ),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: AppTheme.indigo,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _PassField extends StatelessWidget {
  final String label;
  final String hint;
  const _PassField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.muted)),
        const SizedBox(height: 5),
        TextField(
          obscureText: true,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}


class _HelpRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _HelpRow(
      {required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.ink)),
          ],
        ),
      ],
    );
  }
}
