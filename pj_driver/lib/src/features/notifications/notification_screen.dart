import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

final driverNotificationsProvider = FutureProvider<List<domain.Notification>>((ref) async {
  final response = await ref.read(apiClientProvider).getNotifications();
  final List data = response.data;
  return data.map((json) => domain.Notification.fromJson(json)).toList();
});

class DriverNotificationScreen extends ConsumerWidget {
  const DriverNotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(driverNotificationsProvider);
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(L10n.of(context)!.notifications)),
      body: notifAsync.when(
        data: (list) => list.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🔔', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(L10n.of(context)!.noNotifications, style: Theme.of(context).textTheme.titleMedium),
            ]))
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final n = list[i];
                final (Color accent, String emoji) = switch (n.type) {
                  domain.NotificationType.statusUpdate => (AppTheme.blue, '🚛'),
                  domain.NotificationType.reportUpdate => (AppTheme.red, '⚠️'),
                  domain.NotificationType.assignment => (AppTheme.orange, '📋'),
                };
                final bgColor = switch (n.type) {
                  domain.NotificationType.statusUpdate => AppTheme.blueLight,
                  domain.NotificationType.reportUpdate => AppTheme.redLight,
                  domain.NotificationType.assignment => AppTheme.orangeLight,
                };
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
                  child: Opacity(
                    opacity: n.isRead ? 0.55 : 1.0,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(switch (n.type) {
                          domain.NotificationType.statusUpdate => L10n.of(context)!.statusUpdate,
                          domain.NotificationType.reportUpdate => L10n.of(context)!.reportUpdate,
                          domain.NotificationType.assignment => L10n.of(context)!.assignment,
                        }, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink)),
                        const SizedBox(height: 2),
                        Text(L10n.of(context)!.localeName == 'ku' ? n.messageKu : n.messageEn, style: const TextStyle(fontSize: 12, color: AppTheme.muted, height: 1.4)),
                      ])),
                      if (!n.isRead) Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 5), decoration: BoxDecoration(shape: BoxShape.circle, color: accent)),
                    ]),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${L10n.of(context)!.error}: $e')),
      ),
    );
  }
}
