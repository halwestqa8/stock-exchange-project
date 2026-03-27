import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

class AdminNotificationsScreen extends ConsumerWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    
    // Mock notifications data
    final notifications = [
      {'id': 1, 'type': 'status_update', 'title': 'دۆخی بار نوێکرایەوە', 'message': 'باری #abc123 گەیەندرا', 'time': L10n.of(context)!.minutesAgo(2), 'read': false},
      {'id': 2, 'type': 'report', 'title': 'ڕاپۆرتێکی نوێ نێردرا', 'message': 'کڕیار کێشەیەکی بۆ باری #def456 ڕاپۆرت کردووە', 'time': L10n.of(context)!.hoursAgo(1), 'read': false},
      {'id': 3, 'type': 'assignment', 'title': 'بارێکی نوێ ئەسپێردرا', 'message': 'باری #ghi789 بۆ شۆفێر John ئەسپێردرا', 'time': L10n.of(context)!.hoursAgo(3), 'read': true},
      {'id': 4, 'type': 'status_update', 'title': 'بار لە ڕێگایە', 'message': 'باری #jkl012 ئێستا لە ڕێگایە', 'time': L10n.of(context)!.yesterday, 'read': true},
      {'id': 5, 'type': 'report', 'title': 'ڕاپۆرت چارەسەرکرا', 'message': 'ڕاپۆرتی باری #mno345 چارەسەرکرا', 'time': L10n.of(context)!.yesterday, 'read': true},
    ];

    return Scaffold(
      body: Row(children: [
        // Sidebar
        Container(
          width: 240,
          color: AppTheme.ink,
          child: Column(children: [
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.rose, Color(0xFFFB7185)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('🛡️', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Text(L10n.of(context)!.ltmsAdmin, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ]),
            ),
            const SizedBox(height: 32),
            _sidebarItem('🏠', L10n.of(context)!.overview, false, () => context.go('/')),
            _sidebarItem('👥', L10n.of(context)!.users, false, () => context.go('/users')),
            _sidebarItem('📦', L10n.of(context)!.catalogLabel, false, () => context.go('/catalog')),
            _sidebarItem('🗂️', L10n.of(context)!.categories, false, () => context.go('/categories')),
            _sidebarItem('🚚', L10n.of(context)!.vehicles, false, () => context.go('/vehicles')),
            _sidebarItem('❓', L10n.of(context)!.faqLabel, false, () => context.go('/faq')),
            _sidebarItem('💰', L10n.of(context)!.pricingLabel, false, () => context.go('/pricing')),
            _sidebarItem('📊', L10n.of(context)!.reports, false, () => context.go('/reports')),
            _sidebarItem('🔔', L10n.of(context)!.notifications, true, () {}),
            const Spacer(),
            _sidebarItem('⚙️', L10n.of(context)!.settings, false, () => context.go('/settings')),
            const SizedBox(height: 16),
          ]),
        ),
        // Main Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(L10n.of(context)!.notifications, style: tt.headlineLarge),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.done_all, size: 18),
                  label: Text(L10n.of(context)!.markAllRead),
                ),
              ]),
              const SizedBox(height: 4),
              Text('هەموو ئاگادارکردنەوەکانی سیستەم ببینە', style: tt.bodyMedium?.copyWith(color: AppTheme.muted)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    final isRead = notif['read'] as bool;
                    return _notificationTile(
                      icon: _getIconForType(notif['type'] as String),
                      title: notif['title'] as String,
                      message: notif['message'] as String,
                      time: notif['time'] as String,
                      isRead: isRead,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  static Widget _sidebarItem(String emoji, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.white : Colors.white.withAlpha(128),
          )),
        ]),
      ),
    );
  }

  static IconData _getIconForType(String type) {
    switch (type) {
      case 'status_update':
        return Icons.local_shipping;
      case 'report':
        return Icons.report_problem;
      case 'assignment':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Widget _notificationTile({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isRead ? null : AppTheme.roseLight.withAlpha(50),
      child: ListTile(
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: isRead ? AppTheme.border : AppTheme.rose,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isRead ? AppTheme.muted : Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: isRead ? FontWeight.w500 : FontWeight.w700),
        ),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 11, color: AppTheme.muted)),
        ]),
        trailing: !isRead ? Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(color: AppTheme.rose, shape: BoxShape.circle),
        ) : null,
        onTap: onTap,
      ),
    );
  }
}
