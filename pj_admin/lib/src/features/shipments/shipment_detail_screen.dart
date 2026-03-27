import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

class ShipmentDetailScreen extends ConsumerWidget {
  final String shipmentId;
  const ShipmentDetailScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    
    // Mock data - in real app, fetch from API
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
            _sidebarItem('📦', L10n.of(context)!.shipments, true, () {}),
            _sidebarItem('👥', L10n.of(context)!.users, false, () => context.go('/users')),
            _sidebarItem('📊', L10n.of(context)!.reports, false, () => context.go('/reports')),
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
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
                const SizedBox(width: 8),
                Text(L10n.of(context)!.shipmentDetails, style: tt.headlineLarge),
              ]),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.amberLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(L10n.of(context)!.pendingCount, style: TextStyle(color: AppTheme.amber, fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          Text('#${shipmentId.substring(0, 8)}', style: TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 20),
                          Expanded(child: _infoColumn(l10n.origin, 'بەغدا، عێراق')),
                          const Icon(Icons.arrow_forward, color: AppTheme.muted),
                          Expanded(child: _infoColumn(l10n.destination, 'هەولێر، عێراق')),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Details
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(l10n.shipmentDetails, style: tt.titleMedium),
                            const SizedBox(height: 16),
                            _detailRow(l10n.weight, L10n.of(context)!.kgUnit('25')),
                            _detailRow(l10n.category, 'بەڵگەنامەکان'),
                            _detailRow(l10n.vehicleType, 'ڤان'),
                            _detailRow(l10n.estimatedDelivery, '3 ${l10n.days}'),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(L10n.of(context)!.customer, style: tt.titleMedium),
                            const SizedBox(height: 16),
                            _detailRow(l10n.nameLabel, 'Ahmed Ali'),
                            _detailRow(l10n.email, 'ahmed@example.com'),
                            _detailRow('مۆبایل', '+964 750 123 4567'),
                          ]),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    // Price Breakdown
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(L10n.of(context)!.priceBreakdown, style: tt.titleMedium),
                        const SizedBox(height: 16),
                        _detailRow(l10n.basePrice, '\$10.00'),
                        _detailRow('نرخی کێش (25kg × \$0.50)', '\$12.50'),
                        _detailRow('زیادەی پۆل', '\$5.00'),
                        _detailRow('زێدەکەری ئامێر (1.2x)', '+\$3.30'),
                        const Divider(height: 24),
                        _detailRow(l10n.total, '\$30.80', isBold: true),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Actions
                    Row(children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.local_shipping),
                        label: Text(l10n.assignDriver),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: Text(L10n.of(context)!.edit),
                      ),
                    ]),
                  ]),
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

  Widget _infoColumn(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    ]);
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: AppTheme.muted)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
      ]),
    );
  }
}
