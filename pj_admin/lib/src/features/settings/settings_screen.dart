import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../auth/auth_provider.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final locale = ref.watch(localeProvider);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 240,
            color: AppTheme.ink,
            child: Column(
              children: [
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.rose, Color(0xFFFB7185)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text('\u{1F6E1}', style: TextStyle(fontSize: 18)), // Shield 🛡️
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.ltmsAdmin,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _sidebarItem('\u{1F3E0}', l10n.overview, false, () => context.go('/')), // House 🏠
                _sidebarItem(
                  '\u{1F465}', // Users 👥
                  l10n.usersLabel,
                  false,
                  () => context.go('/users'),
                ),
                _sidebarItem(
                  '\u{1F4E6}', // Package 📦
                  l10n.catalogLabel,
                  false,
                  () => context.go('/catalog'),
                ),
                _sidebarItem(
                  '\u{1F5C2}', // Folder 🗂️
                  l10n.categories,
                  false,
                  () => context.go('/categories'),
                ),
                _sidebarItem(
                  '\u{1F69B}', // Truck 🚚
                  l10n.vehiclesLabel,
                  false,
                  () => context.go('/vehicles'),
                ),
                _sidebarItem(
                  '\u{2753}', // Question ❓
                  l10n.faqLabel,
                  false,
                  () => context.go('/faq'),
                ),
                _sidebarItem(
                  '\u{1F4B0}', // Money 💰
                  l10n.pricingLabel,
                  false,
                  () => context.go('/pricing'),
                ),
                _sidebarItem(
                  '\u{1F4CA}', // Chart 📊
                  l10n.reportsLabel,
                  false,
                  () => context.go('/reports'),
                ),
                _sidebarItem(
                  '\u{1F514}', // Bell 🔔
                  l10n.notifications,
                  false,
                  () => context.go('/notifications'),
                ),
                const Spacer(),
                _sidebarItem('\u{2699}', l10n.settings, true, () {}), // Gear ⚙️
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settings, style: tt.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    l10n.manageAccount,
                    style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      children: [
                        _settingsTile(
                          context: context,
                          icon: Icons.person_outline,
                          title: l10n.accountSettings,
                          subtitle: l10n.accountSubtitle,
                          onTap: () {},
                        ),
                        _settingsTile(
                          context: context,
                          icon: Icons.palette_outlined,
                          title: l10n.appearanceSettings,
                          subtitle: l10n.appearanceSubtitle,
                          onTap: () {},
                        ),
                        _settingsTile(
                          context: context,
                          icon: Icons.language,
                          title: l10n.language,
                          subtitle: '${l10n.english} / ${l10n.kurdish}',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.roseLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              locale.languageCode.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.rose,
                              ),
                            ),
                          ),
                          onTap: () =>
                              ref.read(localeProvider.notifier).toggle(),
                        ),
                        _settingsTile(
                          context: context,
                          icon: Icons.notifications_outlined,
                          title: l10n.notificationsSettings,
                          subtitle: l10n.notificationsSubtitle,
                          onTap: () {},
                        ),
                        _settingsTile(
                          context: context,
                          icon: Icons.security_outlined,
                          title: l10n.securitySettings,
                          subtitle: l10n.securitySubtitle,
                          onTap: () {},
                        ),
                        const Divider(height: 48),
                        _settingsTile(
                          context: context,
                          icon: Icons.help_outline,
                          title: l10n.helpSupportSettings,
                          subtitle: l10n.helpSupportSubtitle,
                          onTap: () {},
                        ),
                        _settingsTile(
                          context: context,
                          icon: Icons.info_outline,
                          title: l10n.aboutSettings,
                          subtitle: l10n.aboutSubtitle,
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(authProvider.notifier).logout();
                            context.go('/login');
                          },
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.signOutSettings),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 48),
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
    );
  }

  static Widget _sidebarItem(
    String emoji,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? Colors.white : Colors.white.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.roseLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.rose),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
